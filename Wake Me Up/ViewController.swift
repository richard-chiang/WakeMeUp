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

    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let customTabController = self.tabBarController as! CustomViewController
        alarm = customTabController.alarm
        timeLabel.text = alarm.description()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

