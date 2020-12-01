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
            Text("\(Double(ac.pitch))")
                .padding()
            if(ac.isOn){
                Button("Stop", action: ac.startAccelerometers)
            }else{
            Button("Start", action: ac.startAccelerometers)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
