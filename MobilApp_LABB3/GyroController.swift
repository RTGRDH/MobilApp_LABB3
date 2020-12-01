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
    @Published var cPitch:Double
    private var oldY:Double
    private var cPitchOld:Double
    init()
    {
        isOn = false
        alpha = 0.1
        cPitch = 0.00
        cPitchOld = 0.00
        oldY = 0.00
        ac.startAcc()
    }
    
    func startGyros() {
       if motion.isGyroAvailable {
          self.motion.gyroUpdateInterval = 1.0 / 60.0
          self.motion.startGyroUpdates()
        isOn = true
          // Configure a timer to fetch the accelerometer data.
          self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                 repeats: true, block: { (timer) in
             // Get the gyro data.
             if let data = self.motion.gyroData {
                let x = data.rotationRate.x
                let y = data.rotationRate.y
                let z = data.rotationRate.z

                // Use the gyroscope data in your app.
                let fY = self.filterY(y: y, oldY: self.oldY)
                self.oldY = fY
                self.cPitch = self.alpha*(self.cPitchOld + (self.motion.gyroUpdateInterval * fY)) + ((1-self.alpha)*self.ac.getaccPitch())
                self.cPitchOld = self.cPitch
             }
          })

          // Add the timer to the current run loop.
        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
       }
    }
    
    func startGyro(){
        startGyros()
        let timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(stopGyros), userInfo: nil, repeats: false)
    }

    @objc func stopGyros() {
       if self.timer != nil {
          self.timer.invalidate()
          self.motion.stopGyroUpdates()
          ac.stopAccelerometerUpdates()
        isOn = false
       }
    }
    private func filterY(y:Double, oldY:Double)->Double
    {
        return (1-self.alpha)*(oldY) + (self.alpha * y)
    }
    public func getCPitch()-> Double
    {
        return cPitch
    }
}
