//
//  ViewController.swift
//  Calculator
//
//  Created by Austen Talbot on 2/7/15.
//  Copyright (c) 2015 Austen Talbot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var brain = CalculatorModel()
    
    var isTyping = false
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        let newNumber = display.text! + digit
        if isTyping == true {
            if let validNumber = NSNumberFormatter().numberFromString(newNumber) {
                display.text = newNumber
            }
        } else {
            if digit == "Π" {
                display.text = "3.14159265359"
            } else {
                display.text = digit
            }
            isTyping = true
        }
    }
    
    func addToHistory(value: String) {
        if history.text! == "0" {
            history.text = value
        } else {
            history.text = history.text! + " " + value
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        history.text = ""
        displayValue = 0
        isTyping = false
        
    }

    @IBAction func operate(sender: UIButton) {
        if isTyping {
            process()
        }
        if let operation = sender.currentTitle {
            addToHistory("\(operation)")
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }

    func process() {
        isTyping = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func enter() {
        addToHistory("\(displayValue)")
        process()
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

