//
//  CalculatorBrain.swift
//  MyCalculator
//
//  Created by Gai Carmi on 8/30/17.
//  Copyright © 2017 Gai Carmi. All rights reserved.
//

import Foundation

// we need to think what is the public api what the app do

struct CalculatorBrain{
    
    private var accumulator: Double?
    
    func performOperations(_ symbol: String){
        
        switch mathmaticalSymbol {
            
        case "pi":
            displayValue = Double.pi
        case "^":
            displayValue = sqrt(displayValue)
        default:
            break
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
