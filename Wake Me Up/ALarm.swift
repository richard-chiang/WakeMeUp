//
//  Alarm.swift
//  Wake Me Up
//
//  Created by Richard Chiang on 2017-11-09.
//  Copyright © 2017 Richard Chiang. All rights reserved.
//

import Foundation
import AVFoundation

class Alarm {
    
    var hour = 0
    var minute = 0
    var isAm = true // if true, time is AM. Otherwise, PM
    var isOn = false // if true, the alarm is activated. Otherwise remains inactive
    
    lazy var alarm: AVAudioPlayer? = AVAudioPlayer()
    let alarmFile = "church-bell"
    let alarmFileType = "mp3"
    
    required init(atHour h: Int, minute m: Int, isAm: Bool) {
        self.hour = h
        self.minute = m
        self.isAm = isAm
    }
    
    convenience init(){
        self.init(atHour: 0, minute: 0, isAm: true)
    }
    
    func switchOn(){
        isOn = true
    }
    
    func switchOff() {
        isOn = false
    }
    
    func ring() {
        let url = Bundle.main.url(forResource: alarmFile, withExtension: alarmFileType)!
        
        do {
            alarm = try AVAudioPlayer(contentsOf: url)
            guard let alarm = alarm else { return }
            
            alarm.prepareToPlay()
            alarm.play()
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    func isItNow() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        
        // 24h clock from Foundation Calendar
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let alarmHour = isAm ? self.hour : self.hour + 12
        let alarmMinute = self.minute
        
        return isOn && hour == alarmHour && minute == alarmMinute
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
