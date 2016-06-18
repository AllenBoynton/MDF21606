//
//  ViewController.swift
//  CE04 - Adaptive Layout Project
//
//  Created by Allen Boynton on 6/3/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    // Outlets for views within a storyboard
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var winnersView: UIView!
    @IBOutlet weak var utilityView: UIView!
    
    // Outlet for initial play button
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startButton2: UIButton!
    @IBOutlet weak var restartButton: UIButton!

    // Oulet for timer display
    @IBOutlet weak var timerDisplay: UILabel!
    @IBOutlet weak var timerDisplay2: UILabel!
    @IBOutlet weak var winningTimeText: UILabel!
    
    // Outlet Collection for Card View
    @IBOutlet var cardViewArray: [UIView] = []
    
    // Outlet Collection for Card Images
    @IBOutlet var cardImageArray: [UIImageView] = []
    
    // Local variables - all values change thoughout the game
    
    // Image array
    var cardImages: [String] = []
    
    // View array of Images selected
    var selectedCards: [UIView] = []
    
    // Deducts images until we reach 0 and the user wins
    var cardCounter = 0
    
    // NSTimers for game counter and delays in revealed images
    var timer = NSTimer(), timer1 = NSTimer(), timer2 = NSTimer(), timer3 = NSTimer()
    
    // Audio player
    var cheering = AVAudioPlayer()
    var tadaSound = AVAudioPlayer()
    var patSound = AVAudioPlayer()
    var chime = AVAudioPlayer()
    var wrongAnswer = AVAudioPlayer()
    
    // Time values instantiated
    var minutes: Int = 0
    var seconds: Double = 0
    var time: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize tap gesture
        for view in cardViewArray {
            view.userInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGesture))
            view.addGestureRecognizer(tapGesture)
        }
        
        // Hides card views before game play starts.
        for view in cardViewArray {
            view.hidden = true
            print("View hidden before starting - viewDidLoad")
        }
        
        // Check to see how many buttons are on the screen to determine iPhone or iPad.
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            
            // iPhone array for 20 buttons
            cardImages = [
                "military chainsaw.png", "tools rope.png", "tools saw.png",
                "tools screwdriver.png", "tools shovel.png", "tools swiss knife.png",
                "tools torch.png", "tools wrench.png", "weapons gaunlets.png",
                "weapons katana.png", "military chainsaw.png", "tools rope.png", "tools saw.png",
                "tools screwdriver.png", "tools shovel.png", "tools swiss knife.png",
                "tools torch.png", "tools wrench.png", "weapons gaunlets.png",
                "weapons katana.png"
            ]
            // Call function to populate images
            randomImageLoop()
            
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            
            // iPad array for 30 buttons
            cardImages = [
                "military chainsaw.png", "tools rope.png", "tools saw.png",
                "tools screwdriver.png", "tools shovel.png", "tools swiss knife.png",
                "tools torch.png", "tools wrench.png", "weapons gaunlets.png",
                "weapons katana.png", "magic wizard hat.png", "weapons medieval helmet.png",
                "weapons medieval sword.png", "weapons sledgehammer.png", "weapons wood shield.png",
                "military chainsaw.png", "tools rope.png", "tools saw.png",
                "tools screwdriver.png", "tools shovel.png", "tools swiss knife.png",
                "tools torch.png", "tools wrench.png", "weapons gaunlets.png",
                "weapons katana.png", "magic wizard hat.png", "weapons medieval helmet.png",
                "weapons medieval sword.png", "weapons sledgehammer.png", "weapons wood shield.png"
            ]
            randomImageLoop()
        }
        
        // Verify value of array indices
        print(cardImageArray.indices)
        
        // Play button attributes
        if let play = playButton {
            play.layer.cornerRadius = 6
            play.layer.borderWidth = 2
            play.layer.borderColor = UIColor.blackColor().CGColor
        }
        
        // Start button attributes
        if let start = startButton {
            start.layer.cornerRadius = 6
            start.layer.borderWidth = 2
            start.layer.borderColor = UIColor.blackColor().CGColor
        }
        
        if let start = startButton2 {
            start.layer.cornerRadius = 6
            start.layer.borderWidth = 2
            start.layer.borderColor = UIColor.blackColor().CGColor
        }
        
        // Timer display attributes
        if let display = timerDisplay {
            display.layer.borderWidth = 2
            display.layer.borderColor = UIColor.blackColor().CGColor
        }
        
        if let display = timerDisplay2 {
            display.layer.borderWidth = 2
            display.layer.borderColor = UIColor.blackColor().CGColor
        }
        
        utilityView?.layer.borderWidth = 2
        utilityView?.layer.borderColor = UIColor.yellowColor().CGColor
    }
    
    // for in loop to populate array images by removing a random one at a time while array depletes to ensure pairs
    func randomImageLoop() {
        for index in cardImageArray {
            if cardImages.count > 0 {
                cardCounter += 1
                let random = arc4random_uniform(UInt32(cardImages.count))
                index.image = UIImage(named: cardImages.removeAtIndex(Int(random)))
                index.layer.borderWidth = 2
                index.layer.borderColor = UIColor.blackColor().CGColor
                index.hidden = true
                print("Images populating & Images Hidden")
            }
        }
    }
    
    // Sound files
    func prepareAudios() {
        
        let audioPath1 = NSBundle.mainBundle().pathForResource("Cheering", ofType: "mp3")
        let error1: NSError? = nil
        do {
            cheering = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath1!))
        }
        catch {
            print("Something bad happened \(error1). Try catching specific errors to narrow things down")
        }
        
        let audioPath2 = NSBundle.mainBundle().pathForResource("taDa", ofType: "mp3")
        let error2: NSError? = nil
        do {
            tadaSound = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath2!))
        }
        catch {
            print("Something bad happened \(error2). Try catching specific errors to narrow things down")
        }
        
        let audioPath3 = NSBundle.mainBundle().pathForResource("chime", ofType: "mp3")
        let error3: NSError? = nil
        do {
            chime = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath3!))
        }
        catch {
            print("Something bad happened \(error3). Try catching specific errors to narrow things down")
        }
        
        let audioPath5 = NSBundle.mainBundle().pathForResource("Pat", ofType: "mp3")
        let error5: NSError? = nil
        do {
            patSound = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath5!))
        }
        catch {
            print("Something bad happened \(error5). Try catching specific errors to narrow things down")
        }
    }
    
    // MARK: - Time counter
    
    // Update the timer to the label
    func gameCounter() -> String {
        seconds += 1
        time = seconds.timeString
        
        // Need to use optional binding on timerDisplay because it is showing nil 
        if let label = timerDisplay {
            label.text = time
        } else {
            timerDisplay?.text = time
        }
        
        if let label = timerDisplay2 {
            label.text = time
        } else {
            timerDisplay2?.text = time
        }
        print(time)
        
        return time
    }
    
    // Starts time when play button is pressed.
    func startGameTime() {
        self.timer.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.gameCounter), userInfo: nil, repeats: true)
    }
    
    // Function assigns views with tap gestures
    func tapGesture (sender: UITapGestureRecognizer) {
        
        // Checks if the user has selected more than 0 cards.
        if selectedCards.count > 0 {
            
            // if/else statement to deselect a card if the user retaps the same one.
            if sender.view?.description != selectedCards[0].description {
                selectedCards.append(sender.view!)
                (sender.view?.subviews[0] as! UIImageView).hidden = false
            } else {
                // If 2 cards are selected and have different descriptions, the images are hidden.
                keepCard()
            }
            print("Tapped - No Match")
            
        // If there isn't more than one box in the the array, we have to remove the description check or else that array index will be nil and will cause a crash. We still add the selected box to the array.
        } else {
            selectedCards.append(sender.view!)
            (sender.view?.subviews[0] as! UIImageView).hidden = false
            print("Tapped - Image Added to Array")
        }
        
        // If statement to check if 2 cards have been selected.
        if selectedCards.count == 2 {
            
            // If statement checks subviews to see if they match.
            if (selectedCards[0].subviews[0] as! UIImageView).image == (selectedCards[1].subviews[0] as! UIImageView).image {
                (sender.view?.subviews[0] as! UIImageView).hidden = false
                // Disable user interaction so that they cannot tap any other cards.
                view.userInteractionEnabled = false
                
                // Start a timer for .5 second so user can see the match. Calls removeCards function
                timer2 = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.removeCards), userInfo: nil, repeats: false)
                print("Tapped if 2 cards")
            } else {
                (sender.view?.subviews[0] as! UIImageView).hidden = false
                view.userInteractionEnabled = false
                // Start timer for .5 second so user can see images were NOT a match. Calls hideCards function
                timer3 = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.keepCard), userInfo: nil, repeats: false)
                print("Tapped if 2 cards -else")
            }
        }
    }
    
    // Function used to re-hide images when the user does not get a match.
    func keepCard () {
        
        // Not a match sound
        prepareAudios()
        patSound.play()

        for card in selectedCards {
            card.layer.borderWidth = 2
            card.layer.borderColor = UIColor.yellowColor().CGColor
            card.backgroundColor = UIColor.blackColor()
            (card.subviews[0] as! UIImageView).hidden = true
        }
        
        // Removes the selected boxes from the selected boxes array, allowing the user to start selecting more boxes.
        selectedCards.removeAll(keepCapacity: false)
        
        // Renables user interaction.
        view.userInteractionEnabled = true
    }
    
    // Function used to hide boxes when the user gets a match.
    func removeCards () {
        
        // Correct match sound
        prepareAudios()
        chime.play()

        for card in selectedCards {
            card.hidden = true
        }

        // Removes the count of 1 card per selection so we know how many cards are left.
        cardCounter -= 1
        cardCounter -= 1
        
        selectedCards.removeAll(keepCapacity: false)
        
        // Checks if the number of cards has reached 0.
        if cardCounter == 0 {
            
            // Winning cheers
            prepareAudios()
            tadaSound.play()
            cheering.play()
            
            // Stops the game counter once game is completed.
            timer.invalidate()
            
            // Reveals the winner's screen.
            gameView.hidden = true
            winnersView.hidden = false
            
            // Adds the winning text phrase to the winner's screen label.
            winningTimeText.text! = "You finished in \(time) seconds!"
        }
        
        // Enables the user's interaction once two boxes are matched.
        view.userInteractionEnabled = true
    }
    
    // Function hides images for after the first 5 seconds game preview.
    func seeInitialView(sender: UIButton) {
        
        // Enable user interaction to select views
        view.userInteractionEnabled = true
        
        // Hides card Image and displays View to now select
        for images in cardImageArray {
            images.hidden = true
            print(" 3. Image Hidden - seeInitialView - After Preview")
        }
        
        for view in cardViewArray {
            view.hidden = false
            print("4. View NOT Hidden - seeInitialView - After Preview")
        }
    }
    
    @IBAction func startButton(sender: UIButton) {
        
        // Button sound
        prepareAudios()
        patSound.play()
        
        // Calls functions
        startGameTime()
        
        // Ensures user can not tap buttons while showing 5 second preview.
        view.userInteractionEnabled = false
        
        // Delay images to be shown for 5 seconds.
        self.timer1 = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(ViewController.seeInitialView(_:)), userInfo: nil, repeats: false)
        
        startButton.hidden = true
        startButton2.hidden = true
        
        // Displays Views and Images for the 5 second preview.
        for views in cardViewArray {
            views.layer.borderWidth = 2
            views.layer.borderColor = UIColor.blackColor().CGColor
            views.hidden = false
            print(" 1. View NOT Hidden - startButton - Preview")
        }
        
        for images in cardImageArray {
            images.hidden = false
            print(" 2. Image NOT Hidden - startButton - Preview")
        }
    }
    
    // Button dismisses VC to return to Intro screen
    @IBAction func restartGame(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
        
        // Button sound 
        prepareAudios()
        patSound.play()
        
        startButton.hidden = false
        startButton2.hidden = false
    }
}

