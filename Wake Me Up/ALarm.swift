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
    var isAm = true
    
    required init(atHour h: Int, minute m: Int, isAm: Bool) {
        self.hour = h
        self.minute = m
        self.isAm = isAm
    }
    
    convenience init(){
        self.init(atHour: 0, minute: 0, isAm: true)
    }
    
    func isItNow() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        
        // 24h clock from Foundation Calendar
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        return hour == self.hour && minute == self.minute
    }
    
    func description() -> String {
        var s = ""
        
        if hour < 10 {
            s.append("0")
            s.append(String(hour))
        } else {
            s.append(String(hour))
        }
        
        s.append(" : ")
        
        if minute < 10 {
            s.append("0")
            s.append(String(minute))
        } else {
            s.append(String(minute))
        }
        
        s.append(" ")
        
        if isAm {
            s.append("AM")
        } else {
            s.append("PM")
        }
        
        return s
    }
    
}
