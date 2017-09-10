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
    
    var M: Double?
    
    // to store the first operand with the function
    var pendingBinaryOperation: PendingBinaryOperation?
    
    // to know if binary operation is pending
    private var resultIsPending: Bool {
        get{
            return evaluate(using: nil).isPending
        }
    }
    /********** depricated **********/
    
    var isLegalToMakeBinaryOperation: Bool = false
    
    // we use computed propery and not a method - because we wanted to get read only result
    var result: Double? {                   /********** depricated **********/
        get{
            //return accumulatorValue
            return evaluate(using: nil).result
        }
        
    }
    
    private var description: String {       /********** depricated **********/
        
        
        get{
            return evaluate(using: nil).description
            /*
            if !resultIsPending{
                return accumulatorDescription
            }else{
                return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand,
                                            pendingBinaryOperation!.descriptionOperand != accumulatorDescription ? accumulatorDescription : " ")
            }*/
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
            /*
            if(description != " "){
                return resultIsPending ? (description + "...") : (description + "= ")
            }else{
                return " "
            }
             */
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
            //"C" : Operation.clear
            
        ]
    
    

    /********************** functions **********************/
    
    mutating func performOperations(_ symbol: String){
        
        
            arrayOfLastElements.append(ArrayStackMember.operation(symbol))
            /*
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
            }*/
            
        
    }
    
    mutating func setOperand(_ operand: Double){
        
        arrayOfLastElements.append(ArrayStackMember.operand(operand))
        /*
        accumulatorValue = operand
        let isInteger = operand.truncatingRemainder(dividingBy: 1) == 0
        accumulatorDescription = isInteger ? String(format: "%.0f", operand) : String(operand)
         */
    }
    
    /*
    private mutating func performPendingBinaryOperation() {

        //resultIsPending = true
        
        if pendingBinaryOperation != nil {
            accumulatorDescription = pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand,accumulatorDescription)
            accumulatorValue = pendingBinaryOperation!.binaryFunction(pendingBinaryOperation!.firstOperand, accumulatorValue!)
            pendingBinaryOperation = nil
        }
    }
    */
    
    mutating func clear(){
        /*
        accumulatorValue = 0
        accumulatorDescription = " "
        pendingBinaryOperation = nil
        resultIsPending = false
        isLegalToMakeBinaryOperation = false
         */
        arrayOfLastElements.removeAll()
    }
 

    
    // to handle variable
    mutating func setOperand(variable named: String){
        
        arrayOfLastElements.append(ArrayStackMember.variable(named))
        /*
         if let operand = Double(named){
         setOperand(operand)
         }
         */
        
    }
    
    
    // not make it mutate!!! if value is not in the Dictionary so it zero
    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String){
        
        // 1. iterate the stack
        // 2. replace all variables with their values from Dict - if not exist - its zero
        // 3. calculate
        
        var sum:(value: Double?, description: String) = (0," ")
        var resultIsPending = false
        
        //var isLegalToMakeBinaryOperation = false
        
        var pendingBinaryOperation: PendingBinaryOperation?
        
        var description: String? {
            get{
                 if !resultIsPending{
                    return sum.description
                 }else{
                    return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand,
                           pendingBinaryOperation!.descriptionOperand != sum.description ? sum.description : " ")
                 }
            }
            
        }
        
        var getDescription: String{
            
                 if(description != " "){
                    // return resultIsPending ? (description! + "...") : (description! + "= ")
                    return description!
                 }else{
                    return " "
                 }
        }
        
        func performPendingBinaryOperation() {
            
            //resultIsPending = true
            if sum.value != nil && pendingBinaryOperation != nil {
                sum.description = pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand,sum.description)
                sum.value = pendingBinaryOperation!.binaryFunction(pendingBinaryOperation!.firstOperand, sum.value!)
                pendingBinaryOperation = nil
            }
        }

        // check if array is null
        
        for item in arrayOfLastElements {
            
            switch  item {
                
            case .variable(let variable):
                sum = (variables?[variable] ?? 0, variable)
//                sum.value = variables?[variable] ?? 0.0
//                sum.description = variable
                
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
                            sum = (function(sum.value!), descriptionFunction(sum.description))
                        }
                        
                    case .binaryOperation(let function, let descriptionFunction):
                        
                        //if isLegalToMakeBinaryOperation{
                            
                            // if there is aa pendingBinaryOperation - perform it - else - ignore
                            //performPendingBinaryOperation()
                            
                        
                            
                            // create new pendingBinaryOperation
                            pendingBinaryOperation = PendingBinaryOperation(firstOperand: sum.value!,
                                                                            binaryFunction: function,
                                                                            descriptionOperand: sum.description,
                                                                            descriptionFunction: descriptionFunction)
                        
                        resultIsPending = true
                            /*
                            pendingBinaryOperation = PendingBinaryOperation(firstOperand: sum.value!,
                                                                            binaryFunction: function,
                                                                            descriptionOperand: sum.description,
                                                                            descriptionFunction: descriptionFunction)
                        */
                            //sum = (0, " ")
                        //sum.value = 0
                            
                            
                        //}
                    
                        
                    case .equals:
                        performPendingBinaryOperation()
                        resultIsPending = false
                      /*
                    case .clear:
                        clear()
                    */
                        
                    }
 
                    
                }
            }
            
        }
        
        return (sum.value, resultIsPending, getDescription )
        

        
        
    }
 
    /*
 
    // TODO: TASK 2
    
     func updateUI(){
     
     }
 
    
     func undo(){
     
     }
     
     // limit numbers after point
     
     // generate random num
     
     */

    
    /********************** internal structs **********************/
    
     enum Operation{
        
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double,Double) -> Double, (String,String) -> String)
        case equals
        //case clear
    
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
