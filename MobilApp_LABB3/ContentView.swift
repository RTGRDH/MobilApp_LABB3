//
//  ContentView.swift
//  MobilApp_LABB3
//
//  Created by Ernst on 2020-11-30.
//

import SwiftUI
import ExternalAccessory
struct ContentView: View {
    @State var controller = Controller()
    @ObservedObject var ac = AccController()
    @ObservedObject var gyro = GyroController()
    @ObservedObject var BLE = BLEConnection()
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
                Button("Start Accelerometer", action: ac.startAcc).padding()
            }
            HStack{
                Text("Gyro: \(gyro.cPitch, specifier: "%.2f°")")
            }
            if(gyro.isOn){
                Button("Stop Gyro", action:gyro.stopGyros)
                    .padding()
            }else{
                Button("Start Gyro", action: gyro.startGyro)
                    .padding()
            }
            Spacer()
            if(ac.isOn && gyro.isOn){
                Button("Stop Both", action: stopBoth)
            }else if(!ac.isOn && !gyro.isOn){
                Button("Start Both", action: startBoth)
            }
            /*
            Button("Scan for BLE devices", action: BLE.start).padding()*/
            Button("Scan for BLE devices", action: BLE.start).padding()
            ScrollView{
                ForEach(BLE.devices){
                    device in
                    Text("\(device.name)")
                        .onTapGesture {
                            BLE.connect(name: device.name)
                        }
                }
            }
        }
    }
    /*
    private func startScan(){
        BLE.start
    }
    */
    private func startBoth(){
        ac.startAcc()
        gyro.startGyro()
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
