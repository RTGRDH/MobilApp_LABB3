//
//  GyroController.swift
//  MobilApp_LABB3
//
//  Created by Ernst on 2020-12-01.
//

import Foundation
import CoreMotion

class GyroController:ObservableObject
{
    let motion = CMMotionManager()
    let ac = AccController()
    private var timer = Timer()
    @Published var isOn:Bool
    private var alpha:Double
    private var cPitch:Double
    private var cPitchOld:Double
    init()
    {
        isOn = false
        alpha = 0.1
        cPitch = 0.00
        cPitchOld = 0.00
    }
    
    func startGyros() {
       if motion.isGyroAvailable {
          self.motion.gyroUpdateInterval = 1.0 / 60.0
          self.motion.startGyroUpdates()

          // Configure a timer to fetch the accelerometer data.
          self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                 repeats: true, block: { (timer) in
             // Get the gyro data.
             if let data = self.motion.gyroData {
                let x = data.rotationRate.x
                let y = data.rotationRate.y
                let z = data.rotationRate.z

                // Use the gyroscope data in your app.
                self.cPitch = self.alpha*(self.cPitchOld + (self.motion.gyroUpdateInterval * y)) + ((1-alpha)*ac.getaccPitch())
                self.cPitchOld = self.cPitch
             }
          })

          // Add the timer to the current run loop.
        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
       }
    }

    func stopGyros() {
       if self.timer != nil {
          self.timer.invalidate()
          self.motion.stopGyroUpdates()
       }
    }
}
