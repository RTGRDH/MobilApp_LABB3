//
//  BLEController.swift
//  MobilApp_LABB3
//
//  Created by Ernst on 2020-12-01.
//

import Foundation
import CoreBluetooth
struct Log: TextOutputStream {

    func write(_ string: String) {
        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("logLong.txt")
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? string.data(using: .utf8)?.write(to: log)
        }
    }
}
struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
}

class BLEConnection: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    var centralManager: CBCentralManager!
    var peripheralBLE: CBPeripheral!
    var peripheralBLE2: CBPeripheral!
    var logger = Log()
    var OldGyroOne: Double!
    var OldGyroTwo: Double!
    var FirstSeq: Int!
    var SecondSeq: Int!
    let myNotificationKey = "se.rtgrdh.myBLEnotifyKey"
    
    var charData: CBCharacteristic!
    var sensorPeripheral: CBPeripheral!
    private var bluetoothDevices: [CBPeripheral] = []
    @Published var devices = [Peripheral]()
    
    let GATTService = CBUUID(string: "34802252-7185-4d5d-b431-630e7050e8f0")
    let GATTCommand = CBUUID(string: "34800001-7185-4d5d-b431-630e7050e8f0")
    let GATTData = CBUUID(string: "34800002-7185-4d5d-b431-630e7050e8f0")
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        @unknown default:
            print("unknown")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("didDiscover, ", peripheral.name ?? "Unknown")
        /*
         Appends a list of peripherals into the struct
         */
        let newDevice = Peripheral(id:devices.count, name: peripheral.name ?? "", rssi: RSSI.intValue)
        devices.append(newDevice)
        //print(devices)
        /*
        if (peripheral.identifier.uuidString == GATTService.uuidString)
        {
            print("Found first Movesense")
            NotificationCenter.default.post(name: Notification.Name(rawValue: myNotificationKey), object: nil)
            if peripheralBLE == nil{
                peripheralBLE = peripheral
                peripheralBLE.delegate = self
                centralManager.connect(peripheralBLE)
                
            }
            central.stopScan()
        }
        */
        if let name = peripheral.name, name.contains("Movesense 203130000598"){ //175130000975
            print("Found first Movesense")
            NotificationCenter.default.post(name: Notification.Name(rawValue: myNotificationKey), object: nil)
            if peripheralBLE == nil{
                peripheralBLE = peripheral
                peripheralBLE.delegate = self
                centralManager.connect(peripheralBLE)
                
            }
            central.stopScan()
        }
        
        if let name = peripheral.name, name.contains("Movesense 175030001117"){ //175030001117
            print("Found second Movesense")
            if peripheralBLE2 == nil{
                peripheralBLE2 = peripheral
                peripheralBLE2.delegate = self
                centralManager.connect(peripheralBLE2)
            }
            //central.stopScan()
        }
        
        if peripheralBLE != nil && peripheralBLE2 != nil{
            print("stopScan")
            central.stopScan()
        }
 
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            print("didConnect")
           peripheral.discoverServices([GATTService])
            //peripheral.discoverServices(nil)
           central.scanForPeripherals(withServices: [GATTService], options: nil)
    }
    
  
    
   func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services!{
            print("Service Found")
            peripheral.discoverCharacteristics([GATTData, GATTCommand], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("didDiscoverCharacteristics")
        print(service.characteristics!.first?.uuid)
        guard let characteristics = service.characteristics else { return }

      
        for characteristic in characteristics {
            print(characteristic)
      
            if characteristic.uuid == GATTData {
                print("Data")
                peripheral.setNotifyValue(true, for:characteristic)
            }
      
            if characteristic.uuid == GATTCommand {
                print("Command")
                // Possible sample rates are [13 26 52 104 208 416 833]
                // Link to api https://bitbucket.org/suunto/movesense-device-lib/src/master/
                
    
                
                // The string 190/Meas/Gyro/52 to ascii
                //let parameter:[UInt8]  = [1, 90, 47, 77, 101, 97, 115, 47, 71, 121, 114, 111, 47, 53, 50]
                
                // The string 199/Meas/Acc/52 to ascii
                //let parameter:[UInt8] = [1, 99, 47, 77, 101, 97, 115, 47, 65, 99, 99, 47, 53, 50]
                
                //  IMU6 = 73 77 85 54
                let parameter:[UInt8] = [1, 99, 47, 77, 101, 97, 115, 47, 73, 77, 85, 54, 47, 53, 50]
                
                //let parameter:[UInt8] = [2, 99]
                
              
                let data = NSData(bytes: parameter, length: parameter.count);
        
                peripheral.writeValue(data as Data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                

                print("Command3 \(parameter.count)")
                
            }
        }
    }
    
   
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
    error: Error?) {
        //let time = CFAbsoluteTimeGetCurrent()
        var sensor = 0
       
        if peripheral == peripheralBLE{
            sensor = 1
           // print("1")
        }else if peripheral == peripheralBLE2{
            sensor = 2
            print("2")
        }
        
        switch characteristic.uuid {
                case GATTData:
                    let data = characteristic.value
                    
                    var byteArray: [UInt8] = []
                    for i in data! {
                        let n : UInt8 = i
                        byteArray.append(n)
                    }
                    
                   
                    print(byteArray)
                    
                    
                    let response = byteArray[0];
                    let reference = byteArray[1];
                    
                    
                    if(response == 2 && reference == 99){
                        let array : [UInt8] = [byteArray[2], byteArray[3], byteArray[4], byteArray[5]]
                        var time : UInt32 = 0
                        let data = NSData(bytes: array, length: 4)
                        data.getBytes(&time, length: 4)
                        print(time)
                        
                        
                        let Xacc = bytesToFloat(bytes: [byteArray[9], byteArray[8], byteArray[7], byteArray[6]])
                        let Yacc = bytesToFloat(bytes: [byteArray[13], byteArray[12], byteArray[11], byteArray[10]])
                        let Zacc = bytesToFloat(bytes: [byteArray[17], byteArray[16], byteArray[15], byteArray[14]])
                    
                        print("X:\(Xacc) Y:\(Yacc)  Z:\(Zacc)")
                        
                        
                        
                        
                }
                   
                    

                    
                    
                case GATTCommand:
                    print("Status uppdate")
        
                default:
                    print("Unhandled Characteristic UUID:")
              }
    }
    
    
    func bytesToFloat(bytes b: [UInt8]) -> Float {
        let bigEndianValue = b.withUnsafeBufferPointer {
            $0.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0.pointee }
        }
        let bitPattern = UInt32(bigEndian: bigEndianValue)
      
        return Float(bitPattern: bitPattern)
    }


    
    
    
    
    override init() {
        super.init()
        OldGyroOne = 0.0;
        OldGyroTwo = 0.0;
        FirstSeq = 0;
        SecondSeq = 0;
       
    }
    
    func start(){
        print("centralManager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func stop(){
        if(peripheralBLE2 != nil){
            centralManager.cancelPeripheralConnection(peripheralBLE2)
        }
        if(peripheralBLE != nil){
            centralManager.cancelPeripheralConnection(peripheralBLE)
        }
    }
}
