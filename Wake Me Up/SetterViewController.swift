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
        let date = Date()
        let calendar = Calendar.current
        mm = calendar.component(.minute, from: date) / 10
        m = calendar.component(.minute, from: date) % 10
        
        hh = calendar.component(.hour, from: date) / 10
        h = calendar.component(.hour, from: date) % 10
        
        setTimeVariables()
        
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
            hh = hh + 1
        case 2:
            h += 1
        case 3:
            mm += 1
        case 4:
            m += 1
        case 11:
            hh -= 1
        case 12:
            h -= 1
        case 13:
            mm -= 1
        case 14:
            m -= 1
        case 21:
            isAm = true
        case 22:
            isAm = false
        case 31:
            let hour: Int = hh * 10 + h
            let minute: Int = mm * 10 + m
            let alarm: Alarm = Alarm(atHour: hour, minute: minute)
        default:
            print("Error: no such button should exist")
        }
        
        updateUI()
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
    
    func updateUI(){
        
        var hour = hh * 10 + h
        var minute = mm * 10 + m
        
        // hour : 00 - 23
        hour = hour % 24
        
        hh = hour / 10
        h = hour % 10
        
        // minute : 00 - 59
        minute = minute % 60
        
        mm = minute / 10
        m = minute % 10

        hhLabel.text = String(hh)
        hLabel.text = String(h)
        mmLabel.text = String(mm)
        mLabel.text = String(m)
    }
}
