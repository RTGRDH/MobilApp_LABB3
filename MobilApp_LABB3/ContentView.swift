//
//  ContentView.swift
//  MobilApp_LABB3
//
//  Created by Ernst on 2020-11-30.
//

import SwiftUI

struct ContentView: View {
    @State var controller = Controller()
    @ObservedObject var ac = AccController()
    @ObservedObject var gyro = GyroController()
    var body: some View {
        VStack(){
            HStack {
                Text("Acc: \(ac.accPitch, specifier: "%.2f°")")
                    .padding()
            }
            if(ac.isOn){
                Button("Stop Accelerometer", action: ac.stopAccelerometerUpdates)
                    .padding()
            }else{
                Button("Start Accelerometer", action: ac.startAccelerometers).padding()
            }
            HStack{
                Text("Gyro: \(gyro.cPitch, specifier: "%.2f°")")
            }
            if(gyro.isOn){
                Button("Stop Gyro", action:gyro.stopGyros)
                    .padding()
            }else{
                Button("Start Gyro", action: gyro.startGyros)
                    .padding()
            }
            Spacer()
            if(ac.isOn && gyro.isOn){
                Button("Stop Both", action: stopBoth)
            }else if(!ac.isOn && !gyro.isOn){
                Button("Start Both", action: startBoth)
            }
        }
    }
    private func startBoth(){
        ac.startAccelerometers()
        gyro.startGyros()
    }
    
    private func stopBoth(){
        ac.stopAccelerometerUpdates()
        gyro.stopGyros()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
