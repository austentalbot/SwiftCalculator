//
//  ViewController.swift
//  Calculator
//
//  Created by Austen Talbot on 2/7/15.
//  Copyright (c) 2015 Austen Talbot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isTyping = false
    var numberStack = Array<Double>()
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if isTyping == true {
            display.text = display.text! + digit
        } else {
            display.text = digit
            isTyping = true
        }
    }

    @IBAction func enter() {
        isTyping = false
        numberStack.append(displayValue)
        println("stack = \(numberStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            isTyping = false
        }
    }
}

