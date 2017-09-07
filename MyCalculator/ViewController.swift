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
    
    var userIsInMiddleOfTyping:Bool = false

    var displayValueToUpdate:(result: Double?, isPending: Bool, description: String) = (nil, false, " "){
        
            //updateUI or Model
//            didSet {
//                if let result = displayValueToUpdate.result{
//                    displayValue = result
//                }else{
//                    displayValue = 0
//                }
//
//                if displayValueToUpdate.description != " " {
//                    displayDescription.text = displayValueToUpdate.description + ( displayValueToUpdate.isPending ? " ... " : " = ")
//                }else{
//                    displayDescription.text = " "
//                }
//        }
        didSet{
            if let result = displayValueToUpdate.result{
                displayValue = result
            }else{
                displayValue = 0
            }
            
            if displayValueToUpdate.description != " " {
                displayDescription.text = displayValueToUpdate.description + ( displayValueToUpdate.isPending ? " ... " : " = ")
            }else{
                displayDescription.text = " "
            }
        }

    }
    
    // TODO: should be touple of 3
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }set{
            let isInteger = newValue.truncatingRemainder(dividingBy: 1) == 0
            display.text = isInteger ? String(format: "%.0f", newValue) : String(newValue)
        }
    }
    
    private var variablesDictionary: Dictionary<String, Double>?
        /*
        {
        get{
            self.variablesDictionary!["M"] = displayValue
        }
        set{
            
        }
    }*/
        

    
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
                //brain.setOperand(variable: "25") - test for task 3 - set operand with variable
                userIsInMiddleOfTyping = false
            }
            
            if let mathmaticalSymbol = sender.currentTitle {
                brain.performOperations(mathmaticalSymbol)
            }
            
            // TODO: we should implement it with evaluate - brain.evaluate(variablesDictionary)
            if brain.result != nil{
                //displayValue = result
                //displayDescription.text = brain.getDescription
                displayValueToUpdate = brain.evaluate(using: variablesDictionary)
            }
        }

    }
    
    @IBAction func clear(_ sender: UIButton) {
        brain.clear()
        userIsInMiddleOfTyping = false
        displayValue = 0
        displayDescription.text = " "
        variablesDictionary?.removeAll() // TODO: check if its correct
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // →M
    /*
    @IBAction func getM(_ sender: UIButton) {
        // M: current value of the display
        variablesDictionary?["M"] = displayValue
        var result: (Double?, Bool, String) = brain.evaluate(using: variablesDictionary)
        display.text! = result.0
        // update the display with the result that come back from evaluate
    }
    
    // M
    @IBAction func setM(_ sender: UIButton) {
        brain.setOperand(variable: sender.currentTitle!)
        //displayValue = brain.evaluate(using: variablesDictionary)
        // show the result of calling evaluate in the display.
    }
    */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

