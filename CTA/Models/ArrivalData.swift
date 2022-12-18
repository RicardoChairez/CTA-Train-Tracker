//
//  ArrivalData.swift
//  CTA
//
//  Created by Chip Chairez on 6/21/22.
//

import Foundation

struct ArrivalData: Codable{
    
    let ctatt: Swag
}

struct Swag: Codable{
    let tmst: String
    let eta: [Yolo]
}

struct Yolo: Codable{
    let staNm: String
    let staId: String
    let lat: String?
    let lon: String?
    let stpId: String
    let stpDe: String
    let destNm: String
    let rt: String
    let arrT: String
    let isApp: String
}
