//
//  CTAData.swift
//  CTA
//
//  Created by Chip Chairez on 6/20/22.
//

import Foundation

struct StationData: Codable{
    let STATION_NAME: String
    let STATION_DESCRIPTIVE_NAME: String
    let MAP_ID: Int
    let STOP_ID: Int
    let STOP_NAME: String
    let Location: String
    
    let RED: Bool
    let BLUE: Bool
    let G: Bool
    let BRN: Bool
    let P: Bool
    let Pexp: Bool
    let Y: Bool
    let Pnk: Bool
    let O: Bool

}
