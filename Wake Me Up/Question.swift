//
//  Question.swift
//  Wake Me Up
//
//  Created by Richard Chiang on 2017-11-20.
//  Copyright © 2017 Richard Chiang. All rights reserved.
//

import Foundation

class Question {
    
    var question: String
    var answer: Int
    
    required init(_ question: String, answer: Int){
        self.question = question
        self.answer = answer
    }
    
    func checkAnswer(answer: Int) -> Bool{
        return answer == self.answer
    }
}
