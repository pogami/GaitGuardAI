import Foundation
import CoreMotion
import WatchKit
import SwiftUI
import Combine

class MotionDetector: ObservableObject {
    private let motionManager = CMMotionManager()
    
    func startMonitoring() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 1.0 / 50.0 // 50Hz
        
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let data = data else { return }
            
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            let magnitude = sqrt(x*x + y*y + z*z)
            
            // If tremor/stutter magnitude hits threshold, trigger vibration
            if magnitude > 1.3 {
                self?.triggerRescue()
            }
        }
    }
    
    func stopMonitoring() {
        motionManager.stopAccelerometerUpdates()
    }
    
    private func triggerRescue() {
        // High-intensity haptic to break the gait freeze
        WKInterfaceDevice.current().play(.directionUp)
    }
}
