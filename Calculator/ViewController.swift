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
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if isTyping {
            enter()
        }
        switch operation {
            case "+": performDuoOperation({ $1 + $0 })
            case "−": performDuoOperation({ $1 - $0 })
            case "×": performDuoOperation({ $1 * $0 })
            case "÷": performDuoOperation({ $1 / $0 })
            case "√": performUniOperation({ sqrt($0) })
            default: break
        }
    }
    
    func performDuoOperation(operation: (Double, Double) -> Double) {
        if numberStack.count >= 2 {
            displayValue = operation(numberStack.removeLast(), numberStack.removeLast())
            enter()
        }
    }
    
    func performUniOperation(operation: Double -> Double) {
        if numberStack.count >= 1 {
            displayValue = operation(numberStack.removeLast())
            enter()
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

