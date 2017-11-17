//
//  CustomViewController.swift
//  Wake Me Up
//
//  Created by Richard Chiang on 2017-11-10.
//  Copyright © 2017 Richard Chiang. All rights reserved.
//

import UIKit

class CustomViewController: UITabBarController {
    
    var alarm: Alarm = Alarm()

    override func viewDidLoad() {
        super.viewDidLoad()
        alarm.switchOff()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
