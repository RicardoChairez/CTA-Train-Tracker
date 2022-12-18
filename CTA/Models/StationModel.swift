//
//  StationModel.swift
//  CTA
//
//  Created by Chip Chairez on 6/20/22.
//

import Foundation

struct StationModel{
    
    static var stationArray: [String: Station] = {
        return [:]
    }()
    
    
    
}

struct Station{
    var name: String
    var lines: [String: Bool] = [
        "red": false,
        "blue": false,
        "green": false,
        "brown": false,
        "purple": false,
        "yellow": false,
        "pink": false,
        "orange": false
    ]
    var coordinateString: String
    var lat: Double?{
        var coordinateStringCopy = coordinateString
        coordinateStringCopy.removeFirst()
        coordinateStringCopy.removeLast()
        let coordinateArray = coordinateStringCopy.components(separatedBy: ",")
        if let lat = Double(coordinateArray[0])
        {
            return lat
        }
        return nil
    }
    var lon: Double?{
        var coordinateStringCopy = coordinateString
        coordinateStringCopy.removeFirst()
        coordinateStringCopy.removeLast()
        coordinateStringCopy = coordinateStringCopy.filter { !$0.isWhitespace }
        let coordinateArray = coordinateStringCopy.components(separatedBy: ",")
        if let lon = Double(coordinateArray[1])
        {
            return lon
        }
        return nil
    }
//    var stops: [Int: Stop] = {
//        return [:]
//    }()
}

//struct Stop{
//    var name: String
//    //var line: String
//    var arrivalTimes: [Int] = {
//        return []
//    }()
//}
