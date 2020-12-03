//
//  AccController.swift
//  MobilApp_LABB3
//
//  Created by Ernst on 2020-11-30.
//From Apple's developer site
//https://developer.apple.com/documentation/coremotion/getting_raw_accelerometer_events

import Foundation
import CoreMotion
public class AccController: ObservableObject
{
    let motion = CMMotionManager()
    @Published var isOn: Bool
    private var alpha:Double
    @Published var accPitch:Double
    private var oldX:Double
    private var oldY:Double
    private var oldZ:Double
    private var totalData = [accData()]
    private var timer = Timer()
    init()
    {
        alpha = 0.01
        isOn = false
        accPitch = 0.00
        oldX = 0.00
        oldY = 0.00
        oldZ = 0.00
    }
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
                //EWMA Filter
                let fX = filterX(x: x, oldX: oldX)
                let fY = filterY(y: y, oldY: oldY)
                let fZ = filterZ(z: z, oldZ: oldZ)
                oldX = fX
                oldY = fY
                oldZ = fZ
                accPitch = atan(fX/(sqrt(pow(fY, 2)+pow(fZ, 2))))*(180/Double.pi)
                var acc = accData()
                acc.value = accPitch
                acc.time = String(NSDate().timeIntervalSince1970)
                totalData.append(acc)
             }
          })

          // Add the timer to the current run loop.
        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
       }
    }
    
    func startAcc(){
        startAccelerometers()
        _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(stopAccelerometerUpdates), userInfo: nil, repeats: false)
    }
    
    private func filterX(x:Double, oldX:Double) -> Double
    {
        return (1-self.alpha)*(oldX) + (self.alpha * x)
    }
    private func filterY(y:Double, oldY:Double) -> Double
    {
        return (1-self.alpha)*(oldY) + (self.alpha * y)
    }
    private func filterZ(z:Double, oldZ:Double)->Double
    {
        return (1-self.alpha)*(oldZ) + (self.alpha * z)
    }
    @objc public func stopAccelerometerUpdates() -> Void
    {
        if self.motion.isAccelerometerActive{
            self.motion.stopAccelerometerUpdates()
        }
        isOn = false
        save(toBeSaved: totalData)
        totalData = [accData()]
    }
    public func getaccPitch() -> Double
    {
        return accPitch
    }
    
    struct accData: Codable{
        var value: Double?
        var time: String?
    }
    private let accKey = "savedAccData"

    private func save(toBeSaved: [accData]){
        print("Saving data to file")
        if let encoded = try? JSONEncoder().encode(toBeSaved) {
            UserDefaults.standard.set(encoded, forKey: accKey)
        }else{
            print("Something went wrong when saving the data")
        }
    }
}
