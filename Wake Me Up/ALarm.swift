//
//  Alarm.swift
//  Wake Me Up
//
//  Created by Richard Chiang on 2017-11-09.
//  Copyright © 2017 Richard Chiang. All rights reserved.
//

import Foundation

class Alarm {
    
    var hour = 0
    var minute = 0
    
    required init(atHour h: Int, minute m: Int) {
        self.hour = h
        self.minute = m
    }
    
    func isItNow() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        
        // 24h clock from Foundation Calendar
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        return hour == self.hour && minute == self.minute
    }
    
}
