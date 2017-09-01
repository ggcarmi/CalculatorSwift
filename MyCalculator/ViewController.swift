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
    private var isContainsDot = false
    private var addDigitNextTime = false
    // outlet is a property and not an action
    @IBOutlet weak var display: UILabel!
    
    // listener to the buttons
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." {
            if isContainsDot{
                return
            }
            else{
                isContainsDot = true
                addDigitNextTime = true
            }
        }
        
        if userIsInMiddleOfTyping {
            
            let currentText = display.text!
            
            if addDigitNextTime{
                display.text = currentText + digit
                addDigitNextTime = false
            }else{
                display.text = currentText + digit
            }

        }else{
            display.text = digit
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
        
        if userIsInMiddleOfTyping{
            brain.setOperand(displayValue)
            userIsInMiddleOfTyping = false
        }
        
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperations(mathmaticalSymbol)
        }
        
        if let result = brain.result{
            displayValue = result
            isContainsDot = false
            addDigitNextTime = false
        }
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

