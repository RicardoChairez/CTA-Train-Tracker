//
//  ArrivalModel.swift
//  CTA
//
//  Created by Chip Chairez on 6/21/22.
//

import Foundation

struct ArrivalModel{
    var station: String
    var routes: [String: [String: [Arrival]]] =
    [
        "Red" : [:],
        "Blue" : [:],
        "Brn" : [:],
        "G" : [:],
        "Org" : [:],
        "P" : [:],
        "Pink" : [:],
        "Y" : [:]
    ]
}

struct Arrival{
    var due: Bool 
    var time: String
    var destination: String
}

struct NewArrivalModel{
    var station: String
    var stationID: String
    var arrivals: [String: [String]] = [:]
    lazy var lattitude: Double? = {
        guard let lattitude = StationModel.stationArray[stationID]?.lat else{
            return nil
        }
        return lattitude
    }()
    lazy var longitude: Double? = {
        guard let longitude = StationModel.stationArray[stationID]?.lon else{
            return nil
        }
        return longitude
    }()
}

struct Arivals{
    
    var lines: [String: [String]] = [:]
    
}
