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
    
    // listener to the buttons
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInMiddleOfTyping {
            let currentText = display.text!
            display.text = currentText + digit
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
    @IBAction func performOperation(_ sender: UIButton) {
        
        userIsInMiddleOfTyping = false
        if let mathmaticalSymbol = sender.currentTitle {
            switch mathmaticalSymbol {
                
            case "pi":
                displayValue = Double.pi
            case "^":
                displayValue = sqrt(displayValue)
            default:
                break
            }
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

