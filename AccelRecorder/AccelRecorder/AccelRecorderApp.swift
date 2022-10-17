//
//  AccelRecorderApp.swift
//  AccelRecorder
//
//  Created by Khateeb Hussain on 10/17/22.
//

import SwiftUI

@main
struct AccelRecorderApp: App {
    var body: some Scene {
        WindowGroup {
            AccelRecordingView(motion: AccelMotionManager())
        }
    }
}
