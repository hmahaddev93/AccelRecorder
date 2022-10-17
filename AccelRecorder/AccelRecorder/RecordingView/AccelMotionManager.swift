//
//  AccelMotionManager.swift
//  AccelRecorder
//
//  Created by Khateeb Hussain on 10/17/22.
//

import Combine
import CoreMotion

class AccelMotionManager: ObservableObject {

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
        let fileName = "AccRecoding_\(Date().timeIntervalSince1970)"
        MyFileManager.shared.saveToDocumentDirectory(text: dataText, withFileName: fileName)
        self.accDataList.removeAll()
    }
}
