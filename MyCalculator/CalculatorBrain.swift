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
    
    // this stack will represent the history
    private var arrayOfLastElements = [ArrayStackMember]()
    
    // to store the first operand with the function
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    // to know if binary operation is pending
    private var resultIsPending: Bool {  /********** depricated **********/
        get{
            return evaluate(using: nil).isPending
        }
    }
    
    
    var isLegalToMakeBinaryOperation: Bool = false
    
    // we use computed propery and not a method - because we wanted to get read only result
    var result: Double? {                   /********** depricated **********/
        get{
            return evaluate(using: nil).result
        }
        
    }
    
    private var description: String {       /********** depricated **********/
        get{
            return evaluate(using: nil).description
        }
    }
 
    var getDescription: String{
        get{
            let res = evaluate(using: nil)
            if (res.description != " " ){
                return res.isPending ? ( res.description + "...") : ( res.description + " = ")
            }else{
                return " "
            }
        }
    }
    
    private var operations: Dictionary<String,Operation> =
        [
            "pi" : Operation.constant(Double.pi),
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
            //"C" : Operation.clear
            
        ]


    /********************** functions **********************/
    
    mutating func performOperations(_ symbol: String){
            arrayOfLastElements.append(ArrayStackMember.operation(symbol))
    }
    
    mutating func setOperand(_ operand: Double){
        arrayOfLastElements.append(ArrayStackMember.operand(operand))
    }

    mutating func clear(){
        arrayOfLastElements.removeAll()
    }
 
    // to handle variable
    mutating func setOperand(variable named: String){
        arrayOfLastElements.append(ArrayStackMember.variable(named))
    }
    
    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String){

        var sum:(value: Double?, description: String) = (0," ")
        var resultIsPending = false
        
        var pendingBinaryOperation: PendingBinaryOperation?
        
        var description: String? {
            get{
                if let pbo = pendingBinaryOperation {
                    return pbo.descriptionFunction(pbo.descriptionOperand, pbo.descriptionOperand != sum.description ? sum.description : " ")
                }else{
                    return sum.description
                }
//                 if !resultIsPending{
//                    return sum.description
//                 }else{
//                    return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand,
//                           pendingBinaryOperation!.descriptionOperand != sum.description ? sum.description : " ")
//                 }
            }
        }
        
        var getDescription: String{
            
                 if(description != " " && description != nil){
                    return description ?? " "
                 }else{
                    return " "
                 }
        }
        
        func performPendingBinaryOperation() {
            if let sumValue = sum.value , let pbo = pendingBinaryOperation {
            //if sum.value != nil && pendingBinaryOperation != nil {
//                sum.description = pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand,sum.description)
//                sum.value = pendingBinaryOperation!.binaryFunction(pendingBinaryOperation!.firstOperand, sum.value ?? 0)
//                pendingBinaryOperation = nil
                sum.description = pbo.descriptionFunction(pbo.descriptionOperand,sum.description)
                sum.value = pbo.binaryFunction(pbo.firstOperand, sumValue)
                pendingBinaryOperation = nil
            }
        }

        // check if array is null
        
        for item in arrayOfLastElements {
            
            switch  item {
                
            case .variable(let variable):
                sum = (variables?[variable] ?? 0, variable)
                
            case .operand(let operand):
                let isInteger = operand.truncatingRemainder(dividingBy: 1) == 0
                sum = (operand, isInteger ? String(format: "%.0f", operand) : String(operand) )
                
            case .operation(let symbol):
                
                if let operation = operations[symbol]{
                    
                    switch operation {
                        
                    case .constant(let value):
                        sum = (value, symbol)
                        
                    case .unaryOperation(let function, let descriptionFunction):
                        if sum.value != nil {
                            sum = (function(sum.value ?? 0), descriptionFunction(sum.description))
                        }
                        
                    case .binaryOperation(let function, let descriptionFunction):
                        
                        // create new pendingBinaryOperation
                        pendingBinaryOperation = PendingBinaryOperation(firstOperand: sum.value ?? 0,
                                                                            binaryFunction: function,
                                                                            descriptionOperand: sum.description,
                                                                            descriptionFunction: descriptionFunction)
                        
                        resultIsPending = true

                    case .equals:
                        performPendingBinaryOperation()
                        resultIsPending = false
                        
                    }
                }
            }
        }
        
        return (sum.value, resultIsPending, getDescription )
    }
 
     mutating func undo(){
        if !arrayOfLastElements.isEmpty{
            arrayOfLastElements.removeLast()
        }
     }
    
    /********************** internal structs **********************/
    
     enum Operation{
        
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double,Double) -> Double, (String,String) -> String)
        case equals
    
    }
    
     enum ArrayStackMember{
        
        case operand(Double)
        case operation(String)
        case variable(String)
        
    }
    
     struct PendingBinaryOperation {
        
        var firstOperand: Double
        var binaryFunction: (Double,Double) -> Double
        var descriptionOperand: String
        var descriptionFunction: (String, String) -> String
        
        func perform(with secondOperand: Double) -> Double{
            return binaryFunction(firstOperand,secondOperand)
        }
        
    }
    
}
