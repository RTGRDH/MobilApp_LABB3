//
//  DevicesView.swift
//  MobilApp_LABB3
//
//  Created by Ernst on 2020-12-03.
//

import SwiftUI

struct DevicesView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var BLE:BLEConnection
    var body: some View {
            VStack{
                Button("Scan for BLE devices", action: BLE.start).padding()
                ScrollView{
                    ForEach(BLE.devices){
                        device in
                        Text("\(device.name)")
                            .onTapGesture {
                                BLE.connect(name: device.name)
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
            }
        /*
        Text("Dismiss").onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
        */
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView(BLE: BLEConnection())
    }
}
