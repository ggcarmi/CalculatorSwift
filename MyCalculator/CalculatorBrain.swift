//
//  CalculatorBrain.swift
//  MyCalculator
//
//  Created by Gai Carmi on 8/30/17.
//  Copyright © 2017 Gai Carmi. All rights reserved.
//

import Foundation

func changeSign(operand: Double) -> Double {
    return -operand
}



// we need to think what is the public api what the app do
struct CalculatorBrain{
    

    
    // vars
    private var accumulator: Double?
    
    // to store the first operand with the function
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private var operations: Dictionary<String,Operation> =
        [
            "𝝅" : Operation.constant(Double.pi),
            "e" : Operation.constant(M_E),
            "√" : Operation.unaryOperation(sqrt),
            "cos" : Operation.unaryOperation(cos),
            "±" : Operation.unaryOperation(changeSign),
            "×" : Operation.binaryOperation(m),
            "=" : Operation.equals
            
            
        ]
    
    // we use computed propery and not a method - because we wanted to get read only result
    var result: Double? {
        get{
            return accumulator
        }
        
    }
    
    // functions
    mutating func performOperations(_ symbol: String){
        
        if let operation = operations[symbol]{
            switch operation {
                case .constant(let value):
                    accumulator = value
                case .unaryOperation(let function):
                    if accumulator != nil {
                        accumulator = function(accumulator!)
                    }
                case .binaryOperation(let function):
                    if accumulator != nil{
                        pendingBinaryOperation = PendingBinaryOperation(firstOperand: accumulator!, function: function)
                        accumulator = nil
                    }
                
                }
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }

    }
    
    // internal structs
    private enum Operation{
        
        case constant(Double)
        case unaryOperation( (Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private struct PendingBinaryOperation {
        
        let firstOperand: Double
        let function: (Double,Double) -> Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand,secondOperand)
        }
        
    }
    

    
}
