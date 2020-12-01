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
                Text("Acc: \(Double(ac.roll))")
                    .padding()
                Text("Filter: \(Double(ac.filteredVal))")
                    .padding()
            }
            if(ac.isOn){
                Button("Stop Accelerometer", action: ac.stopAccelerometerUpdates)
            }else{
                Button("Start Accelerometer", action: ac.startAccelerometers).padding()
            }
            HStack{
                Text("Gyro: \(Double(gyro.value))")
            }
            if(gyro.isOn){
                Button("Stop Gyro", action:gyro.stopGyros)
            }else{
                Button("Start Gyro", action: gyro.startGyros)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
