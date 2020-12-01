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
    var body: some View {
        VStack(){
            HStack {
                Text("Acc: \(Double(ac.pitch))")
                    .padding()
                Text("Filter: ")
                    .padding()
            }
            if(ac.isOn){
                Button("Stop Accelerometer", action: ac.stopAccelerometerUpdates)
            }else{
                Button("Start Accelerometer", action: ac.startAccelerometers).padding()
            }
            HStack{
                Text("Gyro: ")
            }
            Button("Start Gyro", action: ac.startAccelerometers)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
