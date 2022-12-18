//
//  StationManager.swift
//  CTA
//
//  Created by Chip Chairez on 6/20/22.
//

import Foundation

protocol StationManagerDelegate{
    func didCreateStationModel()
    
}

struct StationManager{
    var delegate: StationManagerDelegate?
    
    func createStationModel(){
        if let filePath = Bundle.main.path(forResource: "CTAInfo", ofType: "json")
        {
            do{
                let url = URL(fileURLWithPath: filePath)
                let dataString = try String(contentsOf: url)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([StationData].self, from: Data(dataString.utf8))
                for swag in decodedData{
                    let mapIDString = String(swag.MAP_ID)
                    if StationModel.stationArray[mapIDString] == nil{
                        StationModel.stationArray[mapIDString] = Station(name: swag.STATION_NAME, coordinateString: swag.Location)
                    }
                    if (swag.RED){
                        StationModel.stationArray[mapIDString]!.lines["red"] = true
                    }
                    if (swag.BLUE){
                        StationModel.stationArray[mapIDString]!.lines["blue"] = true
                    }
                    if (swag.G){
                        StationModel.stationArray[mapIDString]!.lines["green"] = true
                    }
                    if (swag.BRN){
                        StationModel.stationArray[mapIDString]!.lines["brown"] = true
                    }
                    if (swag.P || swag.Pexp){
                        StationModel.stationArray[mapIDString]!.lines["purple"] = true
                    }
                    if (swag.Y){
                        StationModel.stationArray[mapIDString]!.lines["yellow"] = true
                    }
                    if (swag.Pnk){
                        StationModel.stationArray[mapIDString]!.lines["pink"] = true
                    }
                    if (swag.O){
                        StationModel.stationArray[mapIDString]!.lines["orange"] = true
                    }
                }
                delegate?.didCreateStationModel()
            }
            catch{
                print(error)
            }
        }
    }
    
}
