//
//  diffController.swift
//  testgi2
//
//  Created by Michael Murray on 2022-04-24.
//

import UIKit

var currentOverallDiffValue = 3

var currentPuDiffValue = 3

var disabled = false


class diffController: UIViewController {
    
    
    @IBOutlet weak var overallSlider: UISlider!
    
    @IBOutlet weak var pushupSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overallSlider.value = Float(currentOverallDiffValue)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func overallDiffChanged(_ sender: UISlider) {
        currentOverallDiffValue = Int(Double(sender.value).rounded())
        print(currentOverallDiffValue)
    }
    
    @IBAction func puDiffChanged(_ sender: UISlider) {
        currentPuDiffValue = Int(Double(sender.value).rounded())
        print(currentPuDiffValue)
    }
    
    @IBAction func onDone(_ sender: Any) {
        if(currentPuDiffValue > 3) { //for now just generally make it more difficult
            //upTrain
            
            var str = ""
            
            let url = URL(string: "https://michael8952.pythonanywhere.com/upTrain")!

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    str = String(decoding: data, as: UTF8.self)
                    print(str) //str is the output
                } else if let error = error {
                    print("HTTP Request Failed \(error)")
                }
            }
            
            task.resume()
            
            
        
            disabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 100.0) { // Change `2.0` to the desired number of seconds.
                let url2 = URL(string: "https://michael8952.pythonanywhere.com/reload")!

                let task2 = URLSession.shared.dataTask(with: url2) { data, response, error in
                    if let data = data {
                        let str2 = String(decoding: data, as: UTF8.self)
                        print(str2) //str is the output
                    } else if let error = error {
                        print("HTTP Request Failed \(error)")
                    }
                }
                task2.resume()
                disabled = false
            }
        
        }
        else if(currentPuDiffValue==3){
            //do nothing
        }
        else {
            //dnTrain
            
            var str = ""
            
            let url = URL(string: "https://michael8952.pythonanywhere.com/dnTrain")!

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    str = String(decoding: data, as: UTF8.self)
                    print(str) //str is the output
                } else if let error = error {
                    print("HTTP Request Failed \(error)")
                }
            }
            task.resume()
            
            
            //while(str == "") {
            //    print("loading...")
            //}
            
            disabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 100.0) { // Change `2.0` to the desired number of seconds.
                let url2 = URL(string: "https://michael8952.pythonanywhere.com/reload")!

                let task2 = URLSession.shared.dataTask(with: url2) { data, response, error in
                    if let data = data {
                        let str2 = String(decoding: data, as: UTF8.self)
                        print(str2) //str is the output
                    } else if let error = error {
                        print("HTTP Request Failed \(error)")
                    }
                }
                task2.resume()
                disabled = false
            }
            
            
        }
        
        if(currentOverallDiffValue > 3) {
            //change diff level up to the currentOverallDiffValue
        }
        else if(currentOverallDiffValue==3){
            //do nothing
        }
        else {
            //change diff level dn to the currentOverallDiffValue
        }
        
        /*
        
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
         */
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
