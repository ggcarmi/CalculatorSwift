//
//  CalculatorBrain.swift
//  MyCalculator
//
//  Created by Gai Carmi on 8/30/17.
//  Copyright © 2017 Gai Carmi. All rights reserved.
//

import Foundation

// The Model - we need to think what is the public api what the app do
struct CalculatorBrain{
    

    
    /********************** vars **********************/
    
    // upgrade - those two should be tuple
    private var accumulatorValue: Double?
    private var accumulatorDescription = " "
    
    
    // to store the first operand with the function
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    // to know if binary operation is pending
    private var resultIsPending = false
    
    var isLegalToMakeBinaryOperation: Bool = false
    
    // we use computed propery and not a method - because we wanted to get read only result
    var result: Double? {
        get{
            return accumulatorValue
        }
        
    }
    
    private var description: String {
        get{
            if !resultIsPending{
                return accumulatorDescription
            }else{
                return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand,
                                            pendingBinaryOperation!.descriptionOperand != accumulatorDescription ? accumulatorDescription : " ")
            }
        }
    }
    
    var getDescription: String{
        get{
            if(description != " "){
                return resultIsPending ? (description + "...") : (description + "= ")
            }else{
                return " "
            }
        }
    }
    
    private var operations: Dictionary<String,Operation> =
        [
            "𝝅" : Operation.constant(Double.pi),
            "e" : Operation.constant(M_E),
            "√" : Operation.unaryOperation(sqrt, { "√(\($0))"}),
            "cos" : Operation.unaryOperation(cos, { "cos(\($0))"}),
            "sin" : Operation.unaryOperation(sin, { "sin(\($0))"}),
            "tan" : Operation.unaryOperation(tan, { "tan(\($0))"}),
            "log" : Operation.unaryOperation(log, { "log(\($0))"}),
            "±" : Operation.unaryOperation({ -$0 }, { "-(\($0))"}),
            "x²" : Operation.unaryOperation({ $0 * $0 }, { "(\($0))²"}),
            
            // lets use Closures - its embeded functions in line.
            "×" : Operation.binaryOperation( { (op1: Double, op2: Double) -> Double in return op1*op2}, { "\($0) × \($1)"} ),
            
            // lets make the closure more clean - because swift knows the types
            "+" : Operation.binaryOperation( { (op1, op2) in return op1+op2}, { "\($0) + \($1)"} ),
            
            // and the simpliest way for Closure is...
            "÷" : Operation.binaryOperation({ ($0 / $1) }, { "\($0) ÷ \($1)"}),
            "-" : Operation.binaryOperation({ ($0 - $1) }, { "\($0) - \($1)"}),
            "=" : Operation.equals,
            "C" : Operation.clear
            
        ]
    

    /********************** functions **********************/
    
    mutating func performOperations(_ symbol: String){
        
        if let operation = operations[symbol]{
            switch operation {
                
                case .constant(let value):
                    accumulatorValue = value
                    accumulatorDescription = symbol
                
                case .unaryOperation(let function, let descriptionFunction):
                    if accumulatorValue != nil {
                        accumulatorValue = function(accumulatorValue!)
                        accumulatorDescription = descriptionFunction(accumulatorDescription)
                    }
                
                case .binaryOperation(let function, let descriptionFunction):

                    if isLegalToMakeBinaryOperation{
                        
                        // if there is aa pendingBinaryOperation - perform it - else - ignore
                        //performPendingBinaryOperation()
                    
                        resultIsPending = true

                        // create new pendingBinaryOperation
                        pendingBinaryOperation = PendingBinaryOperation(firstOperand: accumulatorValue!,
                                                                        binaryFunction: function,
                                                                        descriptionOperand: accumulatorDescription,
                                                                        descriptionFunction: descriptionFunction)
                        
                        
                    }

                
                case .equals:
                    performPendingBinaryOperation()
                    resultIsPending = false
                
                case .clear:
                    clear()
            }
            
        }
    }
    
    mutating func setOperand(_ operand: Double){
        
        accumulatorValue = operand
        let isInteger = operand.truncatingRemainder(dividingBy: 1) == 0
        accumulatorDescription = isInteger ? String(format: "%.0f", operand) : String(operand)
    }
    
    
    private mutating func performPendingBinaryOperation() {

        //resultIsPending = true
        
        if pendingBinaryOperation != nil {
            accumulatorDescription = pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand,accumulatorDescription)
            accumulatorValue = pendingBinaryOperation!.binaryFunction(pendingBinaryOperation!.firstOperand, accumulatorValue!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func clear(){
        
        accumulatorValue = 0
        accumulatorDescription = " "
        pendingBinaryOperation = nil
        resultIsPending = false
        isLegalToMakeBinaryOperation = false
    }
    
    /********************** internal structs **********************/
    
    private enum Operation{
        
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double,Double) -> Double, (String,String) -> String)
        case equals
        case clear
    }
    
    private struct PendingBinaryOperation {
        
        var firstOperand: Double
        var binaryFunction: (Double,Double) -> Double
        var descriptionOperand: String
        var descriptionFunction: (String, String) -> String
        
        
        func perform(with secondOperand: Double) -> Double{
            return binaryFunction(firstOperand,secondOperand)
        }
        
    }
    

    
}
