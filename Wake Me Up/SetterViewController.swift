//
//  SetterViewController.swift
//  Wake Me Up
//
//  Created by Richard Chiang on 2017-11-08.
//  Copyright © 2017 Richard Chiang. All rights reserved.
//

import UIKit

class SetterViewController: UIViewController {
    
    // IBOutlets

    @IBOutlet weak var hhLabel: StylizedTimeLabel!
    @IBOutlet weak var hLabel: StylizedTimeLabel!
    @IBOutlet weak var mmLabel: StylizedTimeLabel!
    @IBOutlet weak var mLabel: StylizedTimeLabel!
    
    
    
    
    
    
    // Variables
    
    var mm: Int = 0
    var m: Int = 0
    var hh: Int = 0
    var h: Int = 0
    var isAm: Bool = true

    // Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
//        setTimeVariables()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // Cocoa Touch Functions
    
    // tags:
    // 1 - 4 : Up (HH H MM M)
    // 11 - 14: Down (HH H MM M)
    // 21 - 22: AM/PM
    // 31: Awaken
    @IBAction func userChangeAlarm(_ sender: UIButton) {
        switch (sender.tag){
        case 1:
            print("add 1 to hh")
            hh = hh + 1
        case 2:
            print("add 1 to h")
            h += 1
        case 3:
            print("add 1 to mm")
            mm += 1
        case 4:
            print("add 1 to m")
            m += 1
        case 11:
            print("minus 1 to hh")
            hh -= 1
        case 12:
            print("minus 1 to h")
            h -= 1
        case 13:
            print("minus 1 to mm")
            mm -= 1
        case 14:
            print("minus 1 to m")
            m -= 1
        case 21:
            print("set to am")
            isAm = true
        case 22:
            print("set to pm")
            isAm = false
        case 31:
            let hour: Int = hh * 10 + h
            let minute: Int = mm * 10 + m
            let alarm: Alarm = Alarm(atHour: hour, minute: minute)
            print("call alarm")
            alarm.isItNow()
        default:
            print("Error: no such button should exist")
        }
    }
    
    // Custom Functions

    func setTimeVariables(){
        guard let mmText = mmLabel.text else { return }
        guard let minuteMM = Int(mmText) else { return }
        mm = minuteMM

        guard let mText = mLabel.text else { return }
        guard let minuteM = Int(mText) else { return }
        m = minuteM

        guard let hhText = hhLabel.text else { return }
        guard let hourHH = Int(hhText) else { return }
        hh = hourHH

        guard let hText = hLabel.text else { return }
        guard let hourH = Int(hText) else { return }
        h = hourH
    }

}
