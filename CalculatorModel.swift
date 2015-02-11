//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Austen Talbot on 2/8/15.
//  Copyright (c) 2015 Austen Talbot. All rights reserved.
//

import Foundation

class CalculatorModel {
    
    private enum Op {
        case Operand(Double)
        case UniOperation(String, Double -> Double)
        case DuoOperation(String, (Double, Double) -> Double)
    }
    
    private var knownOps = [String: Op]()
    
    private var opStack = [Op]()
    
    init() {
        knownOps["+"] = Op.DuoOperation("+", +)
        knownOps["−"] = Op.DuoOperation("−", { $1 - $0 })
        knownOps["×"] = Op.DuoOperation("×", *)
        knownOps["÷"] = Op.DuoOperation("÷", { $1 / $0 })
        knownOps["√"] = Op.UniOperation("√", sqrt)
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
        return result
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