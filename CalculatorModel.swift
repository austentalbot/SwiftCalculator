//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Austen Talbot on 2/8/15.
//  Copyright (c) 2015 Austen Talbot. All rights reserved.
//

import Foundation
import Darwin

class CalculatorModel {
    
    enum Op: Printable {
        case Operand(Double)
        case UniOperation(String, Double -> Double)
        case DuoOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                    case .Operand(let operand):
                        return "\(operand)"
                    case .UniOperation(let symbol, _):
                        return symbol
                    case .DuoOperation(let symbol, _):
                        return symbol
                }
            }
        }
    }
    
    private var knownOps = [String: Op]()
    
    var opStack = [Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op;
        }
        learnOp(Op.DuoOperation("+", +))
        learnOp(Op.DuoOperation("−", { $1 - $0 }))
        learnOp(Op.DuoOperation("×", *))
        learnOp(Op.DuoOperation("÷", { $1 / $0 }))
        learnOp(Op.UniOperation("√", sqrt))
        learnOp(Op.UniOperation("sin", sin))
        learnOp(Op.UniOperation("cos", cos))

    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                case .Operand(let operand):
                    return(operand, remainingOps)
                case .UniOperation(_, let operation):
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                case .DuoOperation(_, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result {
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                    }
            }
            
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    var description: String {
        get {
            var remainingOps = opStack
            return "".join(formatOperation(remainingOps.count - 1, arr: remainingOps).reverse())
        }
    }
    
    private func formatOperation(n: Int, arr: [Op]) -> [String] {
        let op = arr[n]
        switch op {
        case .Operand(let operand):
            return [" \(operand) "]
        case .UniOperation(let symbol, _):
            return [")"] + formatOperation(n - 1, arr: arr) + ["\(symbol)("]
        case .DuoOperation(let symbol, _):
            return formatOperation(n - 1, arr: arr) + ["\(symbol)"] + formatOperation(n - 2, arr: arr)
        }
    }
    
    
}