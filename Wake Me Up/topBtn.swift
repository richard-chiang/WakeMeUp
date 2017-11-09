//
//  topBottom.swift
//  Wake Me Up
//
//  Created by Richard Chiang on 2017-11-08.
//  Copyright © 2017 Richard Chiang. All rights reserved.
//

import Foundation
import UIKit

class topBtn: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
