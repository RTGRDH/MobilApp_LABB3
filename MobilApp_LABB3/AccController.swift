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
    @Published var roll:Double
    @Published var isOn: Bool
    private var magnitude:Double //Known as F
    private var gravity:Double //Known as g
    private var alpha:Double
    @Published var filteredVal:Double
    private var filteredValOld:Double
    private var timer = Timer()
    init()
    {
        roll = 0.00
        magnitude = 0.00
        gravity = 1
        alpha = 0.01
        filteredVal = 0.00
        isOn = false
        filteredValOld = 0.00
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
                             repeats: true, block: { [self] (timer) in
             // Get the accelerometer data.
             if let data = self.motion.accelerometerData {
                let x = data.acceleration.x
                let y = data.acceleration.y
                let z = data.acceleration.z

                // Use the accelerometer data in your app.
                self.roll = atan((y)/(sqrt(pow(x, 2)+pow(z, 2))))*(180/Double.pi) //Raw
                //EWMA Filter
                let xPow = pow(x, 2)
                let yPow = pow(y, 2)
                let zPow = pow(z, 2)
                let root = sqrt(xPow + yPow + zPow)
                //self.magnitude = sqrt(pow(x, 2)+pow(y, 2)+pow(z, 2))-self.gravity //Calc F
                self.magnitude = root - gravity
                filteredVal = (1-self.alpha)*(self.filteredValOld) + (self.alpha * self.magnitude)
                self.filteredValOld = self.filteredVal
                
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
    public func getRoll() -> String{
        return String(roll)
    }
}
