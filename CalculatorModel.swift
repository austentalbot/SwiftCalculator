//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Austen Talbot on 2/8/15.
//  Copyright (c) 2015 Austen Talbot. All rights reserved.
//

import Foundation

class CalculatorModel {
    
    enum Op {
        case Operand(Double)
        case UniOperation(String, Double -> Double)
        case DuoOperation(String, (Double, Double) -> Double)
    }
    
    var knownOps = [String: Op]()
    
    var opStack = [Op]()
    
    init() {
        knownOps["+"] = Op.DuoOperation("+", +)
        knownOps["−"] = Op.DuoOperation("−", { $1 - $0 })
        knownOps["×"] = Op.DuoOperation("×", *)
        knownOps["÷"] = Op.DuoOperation("÷", { $1 / $0 })
        knownOps["√"] = Op.UniOperation("√", sqrt)
    }
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
    }
    
}