//
//  ContentView.swift
//  AccelRecorder
//
//  Created by Khateeb Hussain on 10/17/22.
//

import SwiftUI
import CoreMotion

struct AccelRecordingView: View {
    @ObservedObject var motion: MotionManager
    @State var isInitialState = true
    var body: some View {
        VStack {
            Button("Start") {
                self.isInitialState = false
                self.motion.startRecording()
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    self.motion.stopRecordingAndSave()
                    self.isInitialState = true
                }
            }
            .opacity(isInitialState ? 1 : 0)
            Text("X: \(motion.x), Y: \(motion.y), Z: \(motion.z)")
                .opacity(isInitialState ? 0 : 1)
        }
    }
}
