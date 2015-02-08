//
//  ViewController.swift
//  Calculator
//
//  Created by Austen Talbot on 2/7/15.
//  Copyright (c) 2015 Austen Talbot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isTyping = false;
    
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

}

