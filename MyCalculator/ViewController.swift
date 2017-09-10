//
//  ViewController.swift
//  MyCalculator
//
//  Created by Gai Carmi on 8/30/17.
//  Copyright © 2017 Gai Carmi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // outlet is a property and not an action
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayDescription: UILabel!
    @IBOutlet weak var displayM: UILabel!
    
    var userIsInMiddleOfTyping:Bool = false

    var displayValueToUpdate:(result: Double?, isPending: Bool, description: String) = (nil, false, " "){

        didSet{
            if let result = displayValueToUpdate.result{
                displayValue = result
            }else{
                displayValue = 0
            }
            
            if displayValueToUpdate.description != " " {
                
                // if we want to display without ... and = ,so use this line
                // displayDescription.text = displayValueToUpdate.description
                
                // to display ... and = , use this line
                displayDescription.text = displayValueToUpdate.description + ( displayValueToUpdate.isPending ? " ... " : " = ")

            }else{
                displayDescription.text = " "
            }
            
        }

    }
    
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }set{
            let isInteger = newValue.truncatingRemainder(dividingBy: 1) == 0
            display.text = isInteger ? String(format: "%.0f", newValue) : String(newValue)
        }
    }
    
    
    var variablesDictionary: Dictionary<String, Double>? = ["M":0]
    
    // listener to the buttons
    @IBAction func touchDigit(_ sender: UIButton) {
        
        
        let digit = sender.currentTitle!
        brain.isLegalToMakeBinaryOperation = true
        
        if userIsInMiddleOfTyping {
            let currentText = display.text!
            if(digit != "." || currentText.range(of: ".") == nil ){
                display.text = currentText + digit
            }
        }else{
            display.text = digit
            userIsInMiddleOfTyping = true
        }
        
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        let testValid: Double? = Double(display.text!)
        if testValid != nil{
            if userIsInMiddleOfTyping{
                brain.setOperand(displayValue)
                userIsInMiddleOfTyping = false
            }
            
            if let mathmaticalSymbol = sender.currentTitle {
                brain.performOperations(mathmaticalSymbol)
            }
            
            if brain.result != nil{
                displayValueToUpdate = brain.evaluate(using: variablesDictionary)
            }
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        brain.clear()
        userIsInMiddleOfTyping = false
        displayValue = 0
        displayDescription.text = " "
        variablesDictionary = ["M": 0]
        displayM.text = " M = 0 "
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // →M
    
    @IBAction func getM(_ sender: UIButton) {
        // M: current value of the display
        variablesDictionary = ["M": displayValue]
        
        if let res = variablesDictionary!["M"] {
            let isInteger = res.truncatingRemainder(dividingBy: 1) == 0
            displayM.text = " M = " + (isInteger ? String(format: "%.0f", res) : String(res))
        }
        
        userIsInMiddleOfTyping = false
        displayValueToUpdate = brain.evaluate(using: variablesDictionary)
    }
    
    // M
    @IBAction func setM(_ sender: UIButton) {
        brain.setOperand(variable: sender.currentTitle!)
        displayValueToUpdate = brain.evaluate(using: variablesDictionary)
    }
    
    @IBAction func undo(_ sender: UIButton) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

