//
//  ViewController.swift
//  testgi2
//
//  Created by Michael Murray on 2022-04-09.
//

import UIKit

var dlLevel = 3

class ViewController: UIViewController {
    
    //red is actions
    //green is time
    //blue is rest after
    
    //var suffix = "3"
    
    @IBOutlet weak var slider: UIProgressView!
    //let diff5 = "5-DL:~36~40~40~14~15~37~29~30~21~71~75~1~␣"
    //let diff4 = "4-DL:~59~80~0~56~70~5~23~30~18~␣"
    //let diff3 = "3-DL:~22~40~10~33~60~18~35~65~0~22~40~23~␣"
    //let diff2 = "2-DL:~7~20~31~11~35~5~23~60~13~8~20~43~␣"
    //let diff1 = "1-DL:~5~30~25~2~10~69~14~70~6~6~40~0~␣"
    
    @IBOutlet weak var puActions: UITextField!
    
    @IBOutlet weak var puTime: UITextField!
    
    
    @IBOutlet weak var puRest: UITextField!
    
    @IBOutlet weak var suActions: UITextField!
    
    @IBOutlet weak var suTime: UITextField!
    
    @IBOutlet weak var suRest: UITextField!
    
    @IBOutlet weak var sqActions: UITextField!
    
    
    @IBOutlet weak var sqTime: UITextField!
    
    @IBOutlet weak var sqRest: UITextField!
    
    @IBOutlet weak var setDL: UITextField!
    
    @IBOutlet weak var genButton: UIButton!
    
    @IBAction func generateButton(_ sender: Any) {
        
        if(disabled) {
            genButton.backgroundColor = .red
            return
        }
        
        //var c = diff3.components(separatedBy: "~")
        
        
        if(currentOverallDiffValue == 1) {
            //c = diff1.components(separatedBy: "~")
            //suffix = "1"
            slider.setProgress(0.2, animated: true)
        }
        else if(currentOverallDiffValue == 2) {
            //suffix = "2"
            // c = diff2.components(separatedBy: "~")
            slider.setProgress(0.4, animated: true)
        }
        else if(currentOverallDiffValue == 3) {
            //suffix = "3"
            //   c = diff3.components(separatedBy: "~")
            slider.setProgress(0.6, animated: true)
        }
        else if(currentOverallDiffValue == 4) {
            //suffix = "4"
            // c = diff4.components(separatedBy: "~")
            slider.setProgress(0.8, animated: true)
        }
        else if(currentOverallDiffValue == 5) {
            //suffix = "5"
            //  c = diff5.components(separatedBy: "~")
            slider.setProgress(1.0, animated: true)
        }
        
        
        let url = URL(string: "https://michael8952.pythonanywhere.com/pred\(String(currentOverallDiffValue))")!
        
        var workoutString = ""
        
        let task4 = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                workoutString = String(decoding: data, as: UTF8.self)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task4.resume()
        
        while(workoutString == "") {
            print("waiting")
        }
        
        print(workoutString)
        
        let c = workoutString.components(separatedBy: "~")
        
        print(c.count)
        
        puActions.text = c[1]
        puTime.text = c[2]
        puRest.text = c[3]
        suActions.text = c[4]
        suTime.text = c[5]
        suRest.text = c[6]
        sqActions.text = c[7]
        sqTime.text = c[8]
        sqRest.text = c[9]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //let tapGesture = UITapGestureRecognizer(target: self, action: //#selector(self.dismissKeyboard (_:)))
     //   self.view.addGestureRecognizer(tapGesture)
        
        let url = URL(string: "https://michael8952.pythonanywhere.com/pred1")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                print(str) //str is the output
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
    
   // @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
    //    setDL.resignFirstResponder()
    //}


}

