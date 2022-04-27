//
//  ViewController.swift
//  ML_TFLITE
//
//  Created by Michael Murray on 2022-04-13.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //old
        let handler = MLModelHandler()
        handler.initML()
        //old
        
        //new
        let model = modelX()
        model.alterSpecificActionDifficulty(action: "pushup", slider: 1)
        model.predict(DL: 3)
        model.predict(DL: 3)
        model.predict(DL: 3)
        model.predict(DL: 3)
        //new
        
    }

}

