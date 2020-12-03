//
//  DevicesView.swift
//  MobilApp_LABB3
//
//  Created by Ernst on 2020-12-03.
//

import SwiftUI

struct DevicesView: View {
    @ObservedObject var BLE = BLEConnection()
    var body: some View {
        Button("Scan for BLE devices", action: BLE.start).padding()
        ScrollView{
            ForEach(BLE.devices){
                device in
                Text("\(device.name)")
            }
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
