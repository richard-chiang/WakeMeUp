//
//  QuizBank.swift
//  Wake Me Up
//
//  Created by Richard Chiang on 2017-11-20.
//  Copyright © 2017 Richard Chiang. All rights reserved.
//

import Foundation

class QuizBank{
    
    var quizList = [Question]()
    
    init(){
        addQuestion(Question("0 + 1", answer: 1))
        addQuestion(Question("51, 17, 3, 16, 48, 12, 4, 10, 40, ?, 5, 13, 65", answer: 8))
        addQuestion(Question("1, 5, 9, ?, 25, 37, 49", answer: 17))
        addQuestion(Question("7, 5, 2, 14, 3, 1, 2, 6, 8, 5, 3, 16, 6, 2, 4, ?", answer: 12))
        addQuestion(Question("derivative of x with respect to x", answer: 1))
        addQuestion(Question("derivative of 2x with respect to x", answer: 2))
        addQuestion(Question("What number will I get if I remove 2 tens from the number 43?", answer: 23))
        addQuestion(Question("21, 25, 33, 49, 81, ?", answer: 145))
        addQuestion(Question("2, 7, 9, 3, 8, 11, 4, 9, 13, ?, 10, 15", answer: 5))
        addQuestion(Question("5, 7, 12, 6, 8, 14, 7, ?, 16, 8, 10, 18", answer: 9))
        addQuestion(Question("2, 3, 4, 9, 8, 27, 16, ?", answer: 81))
    }
    
    func addQuestion(_ question: Question){
        quizList.append(question)
    }
}
