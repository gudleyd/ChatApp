//
//  ViewController.swift
//  ChatApp
//
//  Created by Иван Лебедев on 07/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var stateLogger: StateLogger = StateLogger(initialState: "init()", instanceName: "ViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stateLogger.logState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stateLogger.logState()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        stateLogger.logState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        stateLogger.logState()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stateLogger.logState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stateLogger.logState()
    }
}

