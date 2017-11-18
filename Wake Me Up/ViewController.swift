//
//  ViewController.swift
//  Wake Me Up
//
//  Created by Richard Chiang on 2017-11-06.
//  Copyright © 2017 Richard Chiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var alarm: Alarm = Alarm()
    var timer: Timer!

    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let customTabController = self.tabBarController as! CustomViewController
        alarm = customTabController.alarm
        timeLabel.text = alarm.description()
        
        // Keep checking for alarm until view is changed
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkTime), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        alarm.switchOff()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        alarm.switchOff()
    }
    
    @objc func checkTime() {
        if alarm.isItNow() {
            alarm.ringSilently()
        }
    }
}

