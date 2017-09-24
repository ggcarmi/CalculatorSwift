//
//  GraphViewController.swift
//  MyCalculator
//
//  Created by Gai Carmi on 9/19/17.
//  Copyright © 2017 Gai Carmi. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    var graphTitle: String?{
        didSet{
            self.navigationItem.title = graphTitle ?? "Graph"
        }
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet{
            addGestures()
        }
    }
    
    var yFunction: ((Double) -> Double?)? {
        didSet{
            _ = self.view // nice trick to force the view populate his hirarchy
            graphView?.yFunction = yFunction
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = graphTitle ?? "Graph"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addGestures(){
        
        graphView.addGestureRecognizer(UIPinchGestureRecognizer( target: graphView, action: #selector(graphView.scale(recognizer:)) ))
        
        graphView.addGestureRecognizer(UIPanGestureRecognizer( target: graphView, action: #selector(graphView.moveOrigin(recognizer:)) ))
        
        let tapRecognizer = UITapGestureRecognizer( target: graphView, action: #selector(graphView.setOriginWithTap(recognizer:)) )
        tapRecognizer.numberOfTapsRequired = 2
        graphView.addGestureRecognizer(tapRecognizer)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
