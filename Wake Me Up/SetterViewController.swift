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
    
    // Constants
    let maxHour = 12
    let maxMinute = 59 // Don't have 60 in minutes. I.e. no one says it is 12:60 PM

    // Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimeVariables()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let hour: Int = hh * 10 + h
        let minute: Int = mm * 10 + m
        
        if hour > maxHour {
            showAlert("Exceed Hour",
                      message: "Invalid Time. Please set the time again before activating the alarm.")
            return false
        } else if minute > maxMinute {
            showAlert("Exceed Minute",
                      message: "Invalid Time. Please set the time again before activating the alarm.")
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "awaken"{
            let dest = segue.destination as? ViewController
            dest?.alarm = Alarm(atHour: getHour(), minute: getMinute(), isAm: isAm)
        }
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
            hh = hh % 2
            
        case 2:
            h += 1
            h = h % 10
            
        case 3:
            mm += 1
            mm = mm % 6
            
        case 4:
            m += 1
            m = m % 10
            
        case 11:
            hh -= 1
            if hh < 0 {
                hh = 1
            }
        
        case 12:
            h -= 1
            if h < 0 {
                h = 9
            }
        
        case 13:
            mm -= 1
            if mm < 0 {
                mm = 5
            }
        
        case 14:
            m -= 1
            if m < 0 {
                m = 9
            }
        
        case 21:
            isAm = true
        
        case 22:
            isAm = false

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
        hhLabel.text = String(hh)
        hLabel.text = String(h)
        mmLabel.text = String(mm)
        mLabel.text = String(m)
    }
    
    func alertHandler(alert: UIAlertAction){
        
    }
    
    func showAlert(_ title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alert = UIAlertAction(title: "Ok", style: .default, handler: alertHandler)
        alertController.addAction(alert)
        present(alertController, animated: true, completion: nil)
    }
    
    func getHour() -> Int{
        return hh * 10 + h
    }
    
    func getMinute() -> Int {
        return mm * 10 + m
    }
}

