//
//  MobilApp_LABB3App.swift
//  MobilApp_LABB3
//
//  Created by Ernst on 2020-11-30.
//

import SwiftUI

@main
struct MobilApp_LABB3App: App {
    @ObservedObject private var BLE = BLEConnection()
    var body: some Scene {
        WindowGroup {
            ContentView(BLE: BLE).onDisappear(perform: {
                BLE.disconnect()
            })
        }
    }
}
