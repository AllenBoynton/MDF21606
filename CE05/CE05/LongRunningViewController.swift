//
//  LongRunningViewController.swift
//  CE05
//
//  Created by Allen Boynton on 6/7/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import UIKit

extension ViewController {
    
    func LongRunningFunction(timeInterval: Double) {
        
        //Block thread for a number of seconds
        NSThread.sleepForTimeInterval(timeInterval)
    }
}
