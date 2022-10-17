//
//  MotionManager.swift
//  AccelRecorder
//
//  Created by Khateeb Hussain on 10/17/22.
//

import Combine
import CoreMotion

class MotionManager: ObservableObject {

    private var motionManager: CMMotionManager
    private var accDataList:[CMAcceleration] = []

    @Published
    var x: Double = 0.0
    @Published
    var y: Double = 0.0
    @Published
    var z: Double = 0.0

    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 1/50
    }
    
    func startRecording() {
        self.motionManager.startAccelerometerUpdates(to: .main) { (accData, error) in
            guard error == nil else {
                print(error!)
                return
            }

            if let accData = accData {
                self.x = accData.acceleration.x
                self.y = accData.acceleration.y
                self.z = accData.acceleration.z
                self.accDataList.append(accData.acceleration)
            }
        }
    }
    
    func stopRecordingAndSave() {
        self.motionManager.stopAccelerometerUpdates()
        
        var dataText: String = ""
        for accData in accDataList {
            dataText = dataText + "\(accData.x),\(accData.y),\(accData.z)\n"
        }
        save(text: dataText, toDirectory: self.documentDirectory(), withFileName: "AccRecoding_\(Date().timeIntervalSince1970)")
        self.accDataList.removeAll()
    }
    
    // MARK: File methods
    private func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0]
    }
    
    private func append(toPath path: String,
                        withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        
        return nil
    }
    
    private func save(text: String,
                      toDirectory directory: String,
                      withFileName fileName: String) {
        guard let filePath = self.append(toPath: directory,
                                         withPathComponent: fileName) else {
            return
        }
        
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error", error)
            return
        }
        
        print("\(fileName) saved successful")
    }
    
    private func read(fromDocumentsWithFileName fileName: String) {
        guard let filePath = self.append(toPath: self.documentDirectory(),
                                         withPathComponent: fileName) else {
                                            return
        }
        
        do {
            let savedString = try String(contentsOfFile: filePath)
            
            print(savedString)
        } catch {
            print("Error reading saved file")
        }
    }
}
