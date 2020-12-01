//
//  AccController.swift
//  MobilApp_LABB3
//
//  Created by Ernst on 2020-11-30.
//

import Foundation
import CoreMotion
public class AccController: ObservableObject
{
    let motion = CMMotionManager()
    @Published var pitch:Double
    @Published var isOn: Bool
    private var timer = Timer()
    init()
    {
        pitch = 0.00
        isOn = false
    }
    /*
     From Apple's developer site
     https://developer.apple.com/documentation/coremotion/getting_raw_accelerometer_events
     */
    func startAccelerometers() {
       // Make sure the accelerometer hardware is available.
       if self.motion.isAccelerometerAvailable {
          self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
          self.motion.startAccelerometerUpdates()
          isOn = true
          // Configure a timer to fetch the data.
          self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                repeats: true, block: { (timer) in
             // Get the accelerometer data.
             if let data = self.motion.accelerometerData {
                let x = data.acceleration.x
                let y = data.acceleration.y
                let z = data.acceleration.z

                // Use the accelerometer data in your app.
                self.pitch = atan((y)/(sqrt(pow(x, 2)+pow(z, 2))))*(180/Double.pi)
             }
          })

          // Add the timer to the current run loop.
        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
       }
    }
    public func stopAccelerometerUpdates() -> Void
    {
        if self.motion.isAccelerometerActive{
            self.motion.stopAccelerometerUpdates()
        }
        isOn = false
    }
    public func getPitch() -> String{
        return String(pitch)
    }
}
