//
//  ModelManager.swift
//  ML_TFLITE
//
//  Created by Michael Murray on 2022-04-13.
//



//https://www.tensorflow.org/lite/guide/inference

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
//from https://stackoverflow.com/questions/36812583/how-to-convert-a-float-value-to-byte-array-in-swift
extension Float {
   var bytes: [UInt8] {
       withUnsafeBytes(of: self, Array.init)
   }
}

extension Int {
    static func parse(from string: String) -> Int? {
    return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}


import Foundation
import TensorFlowLite



public class MLModelHandler {
    let MAXLENGTH: Int = 146

    var lst: [String] = []

    var tildaString = "~"

    var difficultyLevel = "3" //DONT SET IT HERE
    func initML() {
        print("Starting...")
        // Getting model path
        guard
          let modelPath = Bundle.main.path(forResource: "LSTM", ofType: "tflite")
        else {
          // Error handling...
            print("Fail")
            return
        }

        do {
          // Initialize an interpreter with the model.
          let interpreter = try Interpreter(modelPath: modelPath)
            let inputTensor = Tensor.Shape([1,1])
            //let outputTensor = Tensor.Shape([1,1,35])
            

          // Allocate memory for the model's input `Tensor`s.
          try interpreter.allocateTensors()
            
            difficultyLevel = "5"  //input the difficulty from 1-5, SET IT HERE
            var tokenD = tokenizer.translator().char_to_float32(input: difficultyLevel)
            //[1 1] inputs
            //[ 1  1 35] outputs
            

            var inputData: Data = Data()
            
            //data needs bytes
            
            var bytesTest = tokenD.bytes
            let revertTest = bytesTest.withUnsafeBytes {
                $0.load(fromByteOffset: 0, as: Float32.self)
            }
            print(tokenD)
            for byte in bytesTest {
                print(byte)
            }
            
            print(revertTest)
            
            inputData.append(contentsOf: bytesTest)
            
          // input data preparation...

          // Copy the input data to the input `Tensor`.
          try interpreter.copy(inputData, toInputAt: 0)
            
          try interpreter.resizeInput(at: 0, to: inputTensor)
            //added
          // Run inference by invoking the `Interpreter`.
          try interpreter.invoke()

          // Get the output `Tensor`
          let outputTensor = try interpreter.output(at: 0)

          // Copy output to `Data` to process the inference results.
          let outputSize = outputTensor.shape.dimensions.reduce(1, {x, y in x * y}) //not sure if required
          let outputData =
                UnsafeMutableBufferPointer<Float32>.allocate(capacity: outputSize)
          outputTensor.data.copyBytes(to: outputData)
            
            var maxIndex = 0
            
            for i in 0...34 {
                //print(i)
                if(outputData[i] > outputData[maxIndex]) {
                    maxIndex = i
                }
            }
            
            
            
            var first = tokenizer.translator().int_to_char(input: maxIndex)
            
            tildaString = first
            
            for i in 0...MAXLENGTH {
                tokenD = tokenizer.translator().char_to_float32(input: first)
                bytesTest = tokenD.bytes
                inputData.removeAll()
                inputData.append(contentsOf: bytesTest)
                
                try interpreter.copy(inputData, toInputAt: 0)
                  
                try interpreter.resizeInput(at: 0, to: inputTensor)
                  //added
                // Run inference by invoking the `Interpreter`.
                try interpreter.invoke()

                // Get the output `Tensor`
                let outputTensor = try interpreter.output(at: 0)

                // Copy output to `Data` to process the inference results.
                let outputSize = outputTensor.shape.dimensions.reduce(1, {x, y in x * y})
                let outputData =
                      UnsafeMutableBufferPointer<Float32>.allocate(capacity: outputSize)
                outputTensor.data.copyBytes(to: outputData)
                  
                maxIndex = 0
                  
                  for i in 0...34 {
                      //print(i)
                      if(outputData[i] > outputData[maxIndex]) {
                          maxIndex = i
                      }
                  }
                
                first = tokenizer.translator().int_to_char(input: maxIndex)
                lst.append(first)
                print(i)
            }
            
            
        } catch {
          // Error handling...
        }
    
        print("Success")
        print("----Outputs----")

        
        print(difficultyLevel + tildaString, terminator: "")
        for char in lst {
            if(char == "\\n") {
                print("\n")
            }
            else {
                print(char, terminator: "")
            }
            
        }
        print("") //terminator for the end sequences
        
        print("----ON DEVICE TRAINING(MOCK)----")
        
        //alter duration
        
        //modelAltercato().alterSpecificActionDifficulty(action: "pushup", slider: 8)
        //modelAltercato().alterSpecificActionDifficulty(action: "pushup", slider: 3)
        let OBJ = modelX()
        //OBJ.alterDuration(slider: 2)
        //OBJ.alterSpecificActionDifficulty(action: "pushup", slider: 4)
        //OBJ.alterSpecificActionDifficulty(action: "pushup", slider: 10)
        //OBJ.alterSpecificActionFrequency(action: "pushup", slider: 2)
        OBJ.alterSpecificActionFrequency(action: "pushup", slider: 3)
        OBJ.alterSpecificActionFrequency(action: "pushup", slider: 3)
        OBJ.alterSpecificActionFrequency(action: "pushup", slider: 6)
        OBJ.alterSpecificActionFrequency(action: "pushup", slider: 7)
        
        
    }

    
}

// on device training tut:
// https://www.tensorflow.org/lite/examples/on_device_training/overview

class tokenizer {
    class translator {
        var vocab: [Int : String] = [1: " ", 2: "s", 3: "o", 4: "e", 5: "t", 6: "r", 7: "c", 8: "n", 9: "d", 10: "\\n", 11: "u", 12: "h", 13: "i", 14: "p", 15: "f", 16: ",", 17: "w", 18: "5", 19: "0", 20: "1", 21: "2", 22: "3", 23: "4", 24: "6", 25: "\u{2423}", 26: "~", 27: "D", 28: "L", 29: ":", 30: "q", 31: "a", 32: "7", 33: "8", 34: "9"]
        func char_to_float32(input: String) -> Float32 {
            
            if let key = vocab.someKey(forValue: input) {
                return Float32(key)
            }
            else {
                print("failed, not found in dict")
                return -1.0
            }
        }
        
        func int_to_char(input: Int) -> String {
            //dont worry about handling errors for now
            //just allow 1 int to be passed at once
            return vocab[input]!
        }
        
    }
}

class modelX { //values here are probably wayy to extreme but they really should just increment by some small fraction each time instead of being set values as such (they need to stack regardless so this current solution is just temp)
    var durationMultiplier: Double = 1.0 //1.0 is no change (we wont have a max value), but min should be 0.0 flat
    var pushUpDiffMultiplier: Double = 1.0
    var sitUpDiffMultiplier: Double = 1.0
    var squatDiffMultiplier: Double = 1.0
    var pushUpFreq: Double = 10.0
    var workoutComponents: [String] = []
    
    func alterDuration(slider : Int) { //slider value
        if(slider == 5) {
            //do nothing, no changed needed, this is a perfect duration
        }
        else if(slider < 5) {
            //ex its 4 --> 0.8 - 0.9
            //map 4 --> 0.875 - 1
            //    3 --> 0.625 - 0.75
            //    2 --> 0.375 - 0.5
            //    1 --> 0.125 - 0.25
            let max = Double(slider) / 4.0
            let min = max - 0.125
            let val = Double.random(in: min...max)
            durationMultiplier -= ((1 - val) / 3.0)
            print(durationMultiplier)
        }
        else if(slider > 5) {
            //let value = slider - 5
            let max = (Double(slider - 5) / 4.0)
            let min = (max - 0.125)
            let val = Double.random(in: min...max)
            durationMultiplier += (val/3.0)
            print(durationMultiplier)
        }
        else {
            //fail
            print("UNKNOWN DURATIONALTERCATO FAIL")
            return
        }
    }
    
    func alterSpecificActionDifficulty(action: String, slider: Int) { //later make it an enum object
        if(action == "pushup") {
            if(slider == 5) {
                //do nothing
            }
            else if(slider < 5){
                let max = Double(slider) / 4.0
                let min = max - 0.125
                let val = Double.random(in: min...max)
                pushUpDiffMultiplier -= ((1 - val) / 3.0)
                print(pushUpDiffMultiplier)
            }
            else if(slider > 5){
                let max = (Double(slider - 5) / 4.0)
                let min = (max - 0.125)
                let val = Double.random(in: min...max)
                pushUpDiffMultiplier += (val/3.0)
                print(pushUpDiffMultiplier)
            }
            else {
                print("Fail")
                return
            }
        }
        else if(action == "situp") {
            
        }
        else if(action == "squat") {
            
        }
        else {
            print("unhandled")
            return
        }
    }
    
    func alterSpecificActionFrequency(action: String, slider: Int) {
        if(action == "pushup") {
            if(slider == 5) {
                //nothing
            }
            else if(slider < 5) {
                //5 -> -1
                //4 -> -2
                //3 -> -3
                //2 -> -4
                //1 -> -5
                pushUpFreq -= (6.0-Double(slider)) / 1.5
                print(pushUpFreq)
            }
            else if(slider > 5) {
                pushUpFreq += Double((slider-5)) / 1.5
                print(pushUpFreq)
            }
            else {
                print("error")
                return
            }
        }
    }
    
    func predict(DL: Int) {
        
        let MAXLENGTH: Int = 146

        var lst: [String] = []

        let difficultyLevel = String(DL)
        //use multipliers
        //get input
        print("Starting...")
        // Getting model path
        guard
          let modelPath = Bundle.main.path(forResource: "LSTM", ofType: "tflite")
        else {
          // Error handling...
            print("Fail")
            return
        }

        do {
          // Initialize an interpreter with the model.
          let interpreter = try Interpreter(modelPath: modelPath)
            let inputTensor = Tensor.Shape([1,1])
            //let outputTensor = Tensor.Shape([1,1,35])
            

          // Allocate memory for the model's input `Tensor`s.
          try interpreter.allocateTensors()
            //difficultyLevel = "5"  //input the difficulty from 1-5, SET IT HERE
            var tokenD = tokenizer.translator().char_to_float32(input: difficultyLevel)
            //[1 1] inputs
            //[ 1  1 35] outputs
            

            var inputData: Data = Data()
            
            //data needs bytes
            
            var bytesTest = tokenD.bytes
            let revertTest = bytesTest.withUnsafeBytes {
                $0.load(fromByteOffset: 0, as: Float32.self)
            }
            print(tokenD)
            for byte in bytesTest {
                print(byte)
            }
            
            print(revertTest)
            
            inputData.append(contentsOf: bytesTest)
            
          // input data preparation...

          // Copy the input data to the input `Tensor`.
          try interpreter.copy(inputData, toInputAt: 0)
            
          try interpreter.resizeInput(at: 0, to: inputTensor)
            //added
          // Run inference by invoking the `Interpreter`.
          try interpreter.invoke()

          // Get the output `Tensor`
          let outputTensor = try interpreter.output(at: 0)
            

          // Copy output to `Data` to process the inference results.
          let outputSize = outputTensor.shape.dimensions.reduce(1, {x, y in x * y}) //not sure if required
          let outputData =
                UnsafeMutableBufferPointer<Float32>.allocate(capacity: outputSize)
          outputTensor.data.copyBytes(to: outputData)
            
            var maxIndex = 0
            
            
            for i in 0...34 {
                //print(i)
                if(outputData[i] > outputData[maxIndex]) {
                    maxIndex = i
                }
            }
            
            
            
            var first = tokenizer.translator().int_to_char(input: maxIndex)
            
            
            for i in 0...MAXLENGTH {
                tokenD = tokenizer.translator().char_to_float32(input: first)
                bytesTest = tokenD.bytes
                inputData.removeAll()
                inputData.append(contentsOf: bytesTest)
                
                try interpreter.copy(inputData, toInputAt: 0)
                  
                try interpreter.resizeInput(at: 0, to: inputTensor)
                  //added
                // Run inference by invoking the `Interpreter`.
                try interpreter.invoke()

                // Get the output `Tensor`
                let outputTensor = try interpreter.output(at: 0)

                // Copy output to `Data` to process the inference results.
                let outputSize = outputTensor.shape.dimensions.reduce(1, {x, y in x * y})
                let outputData =
                      UnsafeMutableBufferPointer<Float32>.allocate(capacity: outputSize)
                outputTensor.data.copyBytes(to: outputData)
                  
                maxIndex = 0
                  
                  for i in 0...34 {
                      //print(i)
                      if(outputData[i] > outputData[maxIndex]) {
                          maxIndex = i
                      }
                  }
                
                first = tokenizer.translator().int_to_char(input: maxIndex)
                lst.append(first)
                print(i)
            }
            
            
        } catch {
          // Error handling...
        }
    
        print("Success")
        print("----Outputs----")
        
        var numberList: [Int?] = []
        var refinedStringList : [String] = []

        
        print(difficultyLevel + "~", terminator: "")
        for i in 0...lst.count-1 {
            if(lst[i] == "\\n") {
                print("\n")
            }
            else {
                numberList.append(Int(lst[i]))
                print(lst[i], terminator: "")
            }
            
        }
        var newList: [String] = []
        print("") //terminator for the end sequences
        for i in 0...numberList.count-2 {
            if(numberList[i + 1] != nil && numberList[i] != nil) {
                refinedStringList.append(String(numberList[i]!))
            }
            else if(numberList[i] != nil){
                refinedStringList.append(String(numberList[i]!))
            }
            else {
                refinedStringList.append("~")
                
            }
        }
        
        for i in 0...refinedStringList.count-1 {
            if(i > 1 && refinedStringList[i] == "~" && refinedStringList[i-1] == "~") {
                //none
            }
            else {
                newList.append(refinedStringList[i])
            }
        }
        var outputStr = newList.joined()
        outputStr = String(outputStr.dropFirst().dropLast().dropFirst())
        workoutComponents = outputStr.components(separatedBy: "~")
    
        //altercations
        //pushups
        print(Double(workoutComponents[0])!)
        //pushUpDiffMultiplier
        workoutComponents[0] = String(pushUpDiffMultiplier * Double(workoutComponents[0])!)
        
        print(workoutComponents[1])
        
    }
    
    
}

//end goal is make a model class that incorporates the actual model and this modelAltercato stuff
