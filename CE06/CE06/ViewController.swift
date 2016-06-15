//
//  ViewController.swift
//  CE06
//
//  Created by Allen Boynton on 6/10/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    // Outlets for scene views
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var gameView: UIView!
    
    // Outlets for bar item buttons
    @IBOutlet weak var connectButton: UIBarButtonItem!
    @IBOutlet weak var playNowButton: UIBarButtonItem!
    @IBOutlet weak var navTitleMessage: UINavigationItem!
    
    // Outlets for RPS buttons
    @IBOutlet var rpsButtons: [UIButton]!
    
    // RPS Image Outlets
    @IBOutlet weak var player1Image: UIImageView!
    @IBOutlet weak var player2Image: UIImageView!
    @IBOutlet var handGesture: [UIImageView]!
    
    // Outlets for labels to receive attributes
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var player1Name: UILabel!
    @IBOutlet weak var player2Name: UILabel!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    
    // Local properties
    
    /* The Four Main Building Blocks To a Multipeer App */
    var peerID: MCPeerID! // Our device's ID or name as viewed by other "browsing" devices.
    var session: MCSession! // ~The "Connection" between devices.
    var browser: MCBrowserViewController! // Prebuilt ViewController that searches for nearby advertiser.
    var advertiser: MCAdvertiserAssistant! // Helps us easily advertise ourselves to nearby browsers.
    
    let serviceID = "RPS-boynton" // "Channel"
    
    // Placeholder for player 2 name
    var namePlaceholder = ""
    
    // Track both players' ready status.
    var player1Status = "false"
    var player2Status = "false"
    
    // Player's choice picks
    var player1Choice = ""
    var player2Choice = ""
    
    // Players point added or subracted
    var player1Point = 0
    var player2Point = 0
    
    // Array of labels to consolidate code with a for loop
    var playerImages: [UIImageView] = []
    var image: UIImage!
    
    // Local properties for use with the countdown timer
    var count = 4.0
    var timer = NSTimer()
    
    // Tag of image for users pick
    var tagForRPS: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set game screens
        homeView.hidden = false
        gameView.hidden = true
        
        // Setup our MC objects - added a settings button to change my peerID
        peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        
        // Use PeerID to setup session - can use methods to make more secure
        session = MCSession(peer: peerID)
        session.delegate = self
        
        // Setup and start advertising immediately
        advertiser = MCAdvertiserAssistant(serviceType: serviceID, discoveryInfo: nil, session: session)
        advertiser.start()
        
        // Button attributes
        for image in rpsButtons {
            image.layer.borderWidth = 2
            image.layer.borderColor = UIColor.whiteColor().CGColor
        }
        
        // Adjust Nav bar text to fit status changes
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 16)!]
        
        // Adjust bar button items to a proper size and font
        if let font = UIFont(name: "Helvetica Neue", size: 15) {
            connectButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        if let font = UIFont(name: "Helvetica Neue", size: 15) {
            playNowButton?.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        // Enable button
        connectButton.enabled = true
        
        // Disable button
        playNowButton?.enabled = false
        
    }

    
    // MARK: - Lets Play Now function
    
    // Funtion to start the game play with player 2.
    func playNow() {
        
        print("Play Now")
        
        // Change out sign in screen for game screen
        homeView.hidden = true
        gameView.hidden = false
        
        // Changes the userName text underneath the user's score to their name.
        player1Name.text = peerID.displayName
        
        // Here we change the opponent name under the score to match the connected peer.
        player2Name.text = "\(namePlaceholder)"
        
        // Disable the search button
        connectButton.enabled = false
        
        // These reset the users' choices.
        player1Choice = ""
        player2Choice = ""
        
        // These clear the images that the users is to choose.
        player1Image.image = nil
        player2Image.image = nil
        
        // Starts the countdown timer.
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.shootTimer), userInfo: nil, repeats: true)
    }
    
    // MARK: - Countdown Function
    
    /// Creating this switch statement function displays the 3-2-1-SHOOT! for the game.
    func shootTimer() {
        
        print("Countdown Now")
        
        player1Image.hidden = false
        player2Image.hidden = false
        
        countdownLabel.hidden = false
        
        switch count {
            
        case 4.0:
            countdownLabel.text = "READY?"
            player1Image.highlighted = true
            player2Image.highlighted = true
            count -= 0.5
        case 3.5:
            countdownLabel.text = "READY?"
            player1Image.hidden = false
            player2Image.hidden = false
            count -= 0.5
        case 3.0:
            countdownLabel.text = "\(3)"
            player1Image.highlighted = true
            player2Image.highlighted = true
            count -= 0.5
        case 2.5:
            countdownLabel.text = "\(3)"
            player1Image.hidden = false
            player2Image.hidden = false
            count -= 0.5
        case 2.0:
            countdownLabel.text = "\(2)"
            player1Image.highlighted = true
            player2Image.highlighted = true
            count -= 0.5
        case 1.5:
            countdownLabel.text = "\(2)"
            player1Image.highlighted = false
            player2Image.highlighted = false
            count -= 0.5
        case 1.0:
            countdownLabel.text = "\(1)"
            player1Image.highlighted = true
            player2Image.highlighted = true
            count -= 0.5
        case 0.5:
            countdownLabel.text = "\(1)"
            player1Image.highlighted = false
            player2Image.highlighted = false
            count -= 0.5
        case 0.0:
            countdownLabel.text = "SHOOT!!"
            player1Image.highlighted = false
            player2Image.highlighted = false
            
            // This converts text to NSData object to sent our pick to player 2 through MC.
            if let data = player1Choice.dataUsingEncoding(NSUTF8StringEncoding) {
                
                // Needs a do/catch statement to allow to run with chance of error (try)
                do {
                    try session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
                    
                } catch {
                    print("Error: Send Data Failed after timer and do/try attempt.")
                }
            }
            timer.invalidate()
            count = 4.0
            
        default:
            print("Where's the time?")
        }
    }
    
    // The following 3 functions calculate the score for each player. This keeps code to a minimum.
    func pointPlayer1() {
        player1Point += 1
        player2Point += 0
        player1Score.text = String(player1Point)
        player2Score.text = String(player2Point)
    }
    
    func pointPlayer2() {
        player1Point += 0
        player2Point += 1
        player1Score.text = String(player1Point)
        player2Score.text = String(player2Point)
    }
    
    func noPoints() {
        player1Point += 0
        player2Point += 0
        player1Score.text = String(player1Point)
        player2Score.text = String(player2Point)
    }
    
    // MARK: - Decide Winner Function
    
    // Displays result of match.
    func showWinner() {
        
        print("Deciding Winner")
        
        // Disable the character buttons
        for button in rpsButtons {
            button.enabled = false
        }
        
        // Hide winner decision
        countdownLabel.hidden = false
        
        // Created a switch statement for Player 2's pick.
        switch player2Choice {
            
        case "rock":
            // Player 2 chose this image.
            player2Image.image = UIImage(named: "rightrock")
            self.player2Image.image = UIImage(named: "leftrock")
            
            // If statement that checks the user's own choice and determines if the round was a tie, if the user won, or if the user lost.
            if player1Choice == "rock" {
                countdownLabel.text = "Tie!"
                noPoints()
            }
            else if player1Choice == "paper" {
                countdownLabel.text = "Winner!!"
                pointPlayer1()
            }
            else if player1Choice == "scissors" {
                countdownLabel.text = "Loser!"
                pointPlayer2()
            }
            else if player2Choice == "" {
                countdownLabel.text = "Too Slow...Lose"
                pointPlayer2()
            }
            
        case "paper":
            // Player 2 chose this image.
            player2Image.image = UIImage(named: "rightpaper")
            self.player2Image.image = UIImage(named: "leftpaper")
            
            if player1Choice == "rock" {
                countdownLabel.text = "Loser!"
                pointPlayer2()
            }
            else if player1Choice == "paper" {
                countdownLabel.text = "Tie!"
                noPoints()
            }
            else if player1Choice == "scissors" {
                countdownLabel.text = "Winner!!"
                pointPlayer1()
            }
            else if player1Choice == "" {
                countdownLabel.text = "Too Slow...Lose!"
                pointPlayer2()
            }
            
        case "scissors":
            player2Image.image = UIImage(named: "rightscissor")
            self.player2Image.image = UIImage(named: "leftscissor")
            
            if player1Choice == "rock" {
                countdownLabel.text = "Winner!!"
                pointPlayer1()
            }
            else if player1Choice == "paper" {
                countdownLabel.text = "Loser!"
                pointPlayer2()
            }
            else if player1Choice == "scissors" {
                countdownLabel.text = "Tie!"
                noPoints()
            }
            else if player1Choice == "" {
                countdownLabel.text = "Too Slow..."
                noPoints()
            }
            
        default:
            print("Replay")
        }
        
        // This resets the game played and enables the next game.
        player1Status = "false"
        player2Status = "false"
        
        // Enable play button for another game.
        playNowButton?.enabled = true
    }
    
    
    // Created button to connect to the MC
    @IBAction func connectButton(sender: UIBarButtonItem) {
        
        print("Connect Button Tapped")
        
        // Check if already connected
        if session != nil {
            
            // Our browser will look for advertisers on same serviceID.
            browser = MCBrowserViewController(serviceType: serviceID, session: session)
            
            browser.delegate = self
            
            self.presentViewController(browser, animated: true, completion: nil)
        }
        
        // Disable friend search button and enable play now.
        connectButton.enabled = false
        playNowButton?.enabled = true
    }
    
    // Action opens the game screen and reveals and hides accordingly.
    @IBAction func playNowButton(sender: UIBarButtonItem) {
        
        print("Play Now Button Tapped")
        
        // Hide and unhide views for sign in board. Safety for storyboard settings.
        gameView.hidden = false
        homeView.hidden = true
        
        // Play button is disabled once a game is in the works. Then enables to play next game.
        playNowButton?.enabled = false
        
        // Disable the winner/loser label
        countdownLabel.hidden = true
        
        // Enable the character buttons
        for button in rpsButtons {
            button.enabled = true
        }
        
        // Set's the user's ready status to true.
        player1Status = "true"
        
        // Sends the ready status of this user to their opponent.
        if let data = player1Status.dataUsingEncoding(NSUTF8StringEncoding) {
            
            // Needs a do/catch statement to allow to run with chance of error (try)
            do {
                // This converts text to NSData object to sent through MC
                try session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
                
            } catch {
                statusLabel.text = "Error: Send user's ready status to opponent FAILED."
            }
        }
        
        // If both players have tapped Play now, they are ready and game has begun.
        if player1Status == "true" && player2Status == "true" {
            
            playNowButton?.enabled = true
            
            // Now both players are ready and we can call the playNow function.
            playNow()
        }
    }
    
    // Assigns buttons tags and their names to the images.
    @IBAction func gameButtonsRPS(sender: UIButton) {
        print("Tap Choice Now 1")
        // Variable for tags on buttons.
        tagForRPS = sender.tag
        
        switch tagForRPS {
        case 1:
            // Users saved pick of RPS and then display image.
            player1Choice = "rock"
            player1Image.image = UIImage(named: "leftrock")
            self.player1Image.image = UIImage(named: "rightrock")
        case 2:
            player1Choice = "paper"
            player1Image.image = UIImage(named: "leftpaper")
            self.player1Image.image = UIImage(named: "rightpaper")
        case 3:
            player1Choice = "scissors"
            player1Image.image = UIImage(named: "leftscissor")
            self.player1Image.image = UIImage(named: "rightscissor")
        default:
            print("User did not pick in time.")
        }
        // Call funtion to enter choice into switch and if/else statements to reveal the winner.
        showWinner()
        
        print("Player 1 picked: \(player1Choice).")
    }
    
    
    // MARK: - MCBrowserViewControllerDelegate
    
    // Notifies the delegate, when the user taps the done button.
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        browserViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Notifies delegate that the user taps the cancel button.
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        browserViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - MCSessionDelegate Controls the session
    
    // Remote peer changed state - connects, disconnects, etc.
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        /* This whole callback happens in a background thread*/
        dispatch_async(dispatch_get_main_queue(), {
            if state == MCSessionState.Connected {
                if session.connectedPeers.count == 1 {
                    
                    // Operations once connected with an opponent.
                    self.advertiser.stop()
                    
                    self.navTitleMessage.title = "Connected to \(peerID.displayName)"
                    
                    self.statusLabel.text = "\(peerID.displayName) is not ready."
                    
                    // Now that we have an opponent, we enable the ready to play button.
                    self.connectButton.enabled = false
                    self.playNowButton?.enabled = true
                }
                
            } else if state == MCSessionState.Connecting {
                self.statusLabel.text = "Status: Connecting to opponent..."
                
            } else if state == MCSessionState.NotConnected {
                self.statusLabel.text = "Status: No Connection."
                
                self.playNowButton?.enabled = false
                self.connectButton.enabled = true
                
                self.player1Name.hidden = true
                self.player2Name.hidden = true
                
                self.player1Image.hidden = true
                self.player2Image.hidden = true
                
                self.player1Score.hidden = true
                self.player2Score.hidden = true
                
                // Enable character buttons
                for button in self.rpsButtons {
                    button.enabled = false
                }
                
                self.countdownLabel.text = ""
                self.player1Point = 0
                self.player2Point = 0
                
            } else {
                fatalError("ERROR")
            }
        })
    }
    
    // Received data from remote peer (Choices, readiness).
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
        // Build a new String from the encoded NSData Object - Unencoding
        if let data: String = String(data: data, encoding: NSUTF8StringEncoding) {
            
            if data == "true" {
                
                // UI info on Main Thread
                dispatch_async(dispatch_get_main_queue(), {
                    
                    // Updates player 2 status.
                    self.namePlaceholder = peerID.displayName
                    self.statusLabel.text = "\(self.namePlaceholder) is ready!"
                    self.player2Status = "true"
                    
                    // if statement to check if both opponents are ready.
                    if self.player2Status == "true" && self.player1Status == "true" {
                        self.playNow()
                    }
                })
            } else {
                print("Tap Choice Now 2")
                
                // Switch statement checks for player 2's choices.
                switch data {
                    
                case "rock":
                    
                    // .
                    self.player2Choice = "rock"
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showWinner()
                    })
                    
                case "paper":
                    self.player2Choice = "paper"
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showWinner()
                    })
                    
                case "scissors":
                    self.player2Choice = "scissors"
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showWinner()
                    })
                    
                case "":
                    // .
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if self.player1Choice == "" {
                            self.countdownLabel.text = "No one shot."
                            self.player1Status = "false"
                            self.player2Status = "false"
                            self.playNowButton?.enabled = true
                            
                        } else {
                            self.countdownLabel.text = "Opponent didn't shoot."
                            self.pointPlayer1()
                            self.player1Status = "false"
                            self.player2Status = "false"
                            self.playNowButton?.enabled = true
                        }
                    })
                    
                default:
                    print("Error: Try to reconnect.")
                }
                print("Player 2 chose: \(player2Choice)")
                
                
                // Enables players to replay once player2 is ready.
                dispatch_async(dispatch_get_main_queue(), {
                    self.statusLabel.text = "\(self.namePlaceholder) is not ready."
                    self.player2Status = "false"
                })
            }
        }
    }
    
    // Received a byte stream from remote peer.
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    // Start receiving a resource from remote peer.
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {}
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location
    // - the app is responsible for moving the file to a permanent location within its sandbox.
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {}
}

