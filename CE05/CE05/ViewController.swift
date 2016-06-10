//
//  ViewController.swift
//  CE05
//
//  Created by Allen Boynton on 6/7/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outlet collection array of webviews
    @IBOutlet var images: [UIImageView]!
    
    // Url's assigned to constants
    let url1 = "http://www.freewallpaperfullhd.com/?fileToDownload=http://www.freewallpaperfullhd.com/wp-content/uploads/2015/03/Beach-Wallpaper-HD-1920x1080.jpg"
    let url2 = "http://www.freewallpaperfullhd.com/?fileToDownload=http://www.freewallpaperfullhd.com/wp-content/uploads/2015/02/Sandy-Beach-Wallpaper-HD-1920x1080.jpg"
    let url3 = "http://www.freewallpaperfullhd.com/?fileToDownload=http://www.freewallpaperfullhd.com/wp-content/uploads/2015/01/beautiful_dream_beach_1920x1080beach.jpg"
    let url4 = "http://www.freewallpaperfullhd.com/?fileToDownload=http://www.freewallpaperfullhd.com/wp-content/uploads/2014/11/beach1.jpg"
    let url5 = "http://www.freewallpaperfullhd.com/?fileToDownload=http://www.freewallpaperfullhd.com/wp-content/uploads/2015/03/wallpapers/red_porsche_carrera_gt-wallpaper-1920x1080.jpg"
    let url6 = "http://www.freewallpaperfullhd.com/?fileToDownload=http://www.freewallpaperfullhd.com/wp-content/uploads/2015/03/wallpapers/2014_lamborghini_aventador_lp700_4_roadster_side_view-wallpaper-1920x1080.jpg"
    let url7 = "http://www.freewallpaperfullhd.com/?fileToDownload=http://www.freewallpaperfullhd.com/wp-content/uploads/2015/02/Cars-Wallpaper-HD-1920x1080.jpg"
    let url8 = "http://www.freewallpaperfullhd.com/?fileToDownload=http://www.freewallpaperfullhd.com/wp-content/uploads/2015/02/World-Top-Exotic-Car-Wallpaper-HD-1920x1080.jpg"
    
    // Local variables
    var urlImages: [String] = []
    
    var mySerialQueue: dispatch_queue_t!
    
    var myConcurrentQueue: dispatch_queue_t!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Array of URL's
        urlImages = [url1, url2, url3, url4, url5, url6, url7, url8]
        
        mySerialQueue = dispatch_queue_create("uniqueString", DISPATCH_QUEUE_SERIAL)
        
        myConcurrentQueue = dispatch_queue_create("quickerUniqueString", DISPATCH_QUEUE_CONCURRENT)
    }
    
    // Action button outlets
    
    // Action for regular download button
    @IBAction func regular(sender: UIButton) {
        
        //Perform Long Running Task On Main Thread (Thread Blocking)
        for (image, pic) in [(images[0], urlImages[0]), (images[1], urlImages[1]), (images[2], urlImages[2]), (images[3], urlImages[3]), (images[4], urlImages[4]), (images[5], urlImages[5]), (images[6], urlImages[6]), (images[7], urlImages[7])] {
            
            if let myURL = NSURL(string: pic) {

                let urlImage = image
                
                if let data = NSData(contentsOfURL: myURL) {
                    
                    urlImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    // Action to download images serially
    @IBAction func serial(sender: UIButton) {
        
        // Version: 3 -> USE THIS MOST EFFICIENT VERSION
        for (image, pic) in [(images[0], urlImages[0]), (images[1], urlImages[1]), (images[2], urlImages[2]), (images[3], urlImages[3]), (images[4], urlImages[4]), (images[5], urlImages[5]), (images[6], urlImages[6]), (images[7], urlImages[7])] {
            
            // Dispatch to new SERIAL QUEUE
            dispatch_async(mySerialQueue, {
                
                if let myURL = NSURL(string: pic) {
                    
                    let urlImage = image
                    
                    if let data = NSData(contentsOfURL: myURL) {
                        
                        // Dispatch back out to main queue
                        dispatch_sync(dispatch_get_main_queue(), {
                            
                            urlImage.image = UIImage(data: data)
                        })
                    }
                }
            })
        }
    }
    
    // Action to download images concurrently
    @IBAction func concurrent(sender: UIButton) {
        
        for (image, pic) in [(images[0], urlImages[0]), (images[1], urlImages[1]), (images[2], urlImages[2]), (images[3], urlImages[3]), (images[4], urlImages[4]), (images[5], urlImages[5]), (images[6], urlImages[6]), (images[7], urlImages[7])] {
            
            // Dispatch to new CONCURRENT QUEUE
            dispatch_async(myConcurrentQueue, {
                
                if let myURL = NSURL(string: pic) {
                    
                    let urlImage = image
                    
                    if let data = NSData(contentsOfURL: myURL) {
                        
                        // Dispatch back out to main queue
                        dispatch_sync(dispatch_get_main_queue(), {
                            
                            urlImage.image = UIImage(data: data)
                        })
                    }
                }
            })
        }
    }
    
    // Action for loop to clear images within the array of images
    @IBAction func clearAllViews(sender: UIButton) {
        for image in images {
            image.image = nil
        }
    }
}

