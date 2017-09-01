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
    
    private var accumulator: Double?
    
    private enum Operation{
        
        case constant(Double)
        case unaryOperation( (Double) -> Double )
    }
    
    private var operations: Dictionary<String,Operation> =
        [
            "𝝅" : Operation.constant(Double.pi),
            "e" : Operation.constant(M_E),
            "√" : Operation.unaryOperation(sqrt),
            "cos" : Operation.unaryOperation(cos),
            "±" : Operation.unaryOperation(changeSign)
            
            
        ]
    
    mutating func performOperations(_ symbol: String){
        
        if let operation = operations[symbol]{
            switch operation {
                case .constant(let value):
                    accumulator = value
                case .unaryOperation(let function):
                    if accumulator != nil {
                        accumulator = function(accumulator!)
                    }
                
            }
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    // we use computed propery and not a method - because we wanted to get read only result
    var result: Double? {
        get{
            return accumulator
        }
        
    }
    
}
