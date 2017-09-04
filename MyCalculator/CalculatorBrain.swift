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
    

    
    /********************** vars **********************/
    private var accumulator: Double?
    
    // to store the first operand with the function
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    // to know if binary operation is pending
    private var resultIsPending = false
    
    private var description:String = ""
    
    private var operations: Dictionary<String,Operation> =
        [
            "𝝅" : Operation.constant(Double.pi),
            "e" : Operation.constant(M_E),
            "√" : Operation.unaryOperation(sqrt),
            "cos" : Operation.unaryOperation(cos),
            "±" : Operation.unaryOperation(changeSign),
            
            // lets use Closures - its embeded functions in line.
            "×" : Operation.binaryOperation(
                { (op1: Double, op2: Double) -> Double in return op1*op2}
            ),
            
            // lets make the closure more clean - because swift knows the types
            "+" : Operation.binaryOperation(
            { (op1, op2) in return op1+op2}
            ),
            
            // and the simpliest way for Closure is...
            "÷" : Operation.binaryOperation({ ($0 / $1) }),
            "-" : Operation.binaryOperation({ ($0 - $1) }),
            "=" : Operation.equals,
            "C" : Operation.clear
            
            
            
        ]
    
    // we use computed propery and not a method - because we wanted to get read only result
    var result: Double? {
        get{
            return accumulator
        }
        
    }
    
    /********************** functions **********************/
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
                        resultIsPending = true
                    }
                case .equals:
                    performPendingBinaryOperation()
                case .clear:
                    clear()
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
            resultIsPending = false
        }

    }
    
    private mutating func clear(){
        accumulator = 0
        description = " "
        pendingBinaryOperation = nil
    }
    
    /********************** internal structs **********************/
    private enum Operation{
        
        case constant(Double)
        case unaryOperation( (Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
    }
    
    private struct PendingBinaryOperation {
        
        let firstOperand: Double
        let function: (Double,Double) -> Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand,secondOperand)
        }
        
    }
    

    
}
