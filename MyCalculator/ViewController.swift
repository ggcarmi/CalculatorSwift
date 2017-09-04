//
//  ViewController.swift
//  MyCalculator
//
//  Created by Gai Carmi on 8/30/17.
//  Copyright © 2017 Gai Carmi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userIsInMiddleOfTyping:Bool = false

    // outlet is a property and not an action
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayDescription: UILabel! 
    
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
            display.text = digit // maybe add zero
            userIsInMiddleOfTyping = true
        }
        
    }

    var displayValue: Double {
        get{
            return Double(display.text!)!
        }set{
            display.text = String(newValue)
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
            
            if let result = brain.result{
                displayValue = result
                displayDescription.text = brain.getDescription
            }
        }

    }
    
    @IBAction func clear(_ sender: UIButton) {
        brain.clear()
        userIsInMiddleOfTyping = false
        displayValue = 0
        displayDescription.text = " "
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

