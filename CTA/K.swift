//
//  Constants.swift
//  CTA
//
//  Created by Chip Chairez on 6/19/22.
//

import Foundation
import MapKit

struct K{
    static let defaultCoordinates = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298), latitudinalMeters: 10000, longitudinalMeters: 10000)
    
    static let routes: [String: String] =
    [
        "Red" : "Red",
        "Blue" : "Blue",
        "Brn" : "Brown",
        "G" : "Green",
        "Org" : "Orange",
        "P" : "Purple",
        "Pink" : "Pink",
        "Y" : "Yellow"
    ]
    
    static let color: [String: UIColor] =
    [
        "Red" : .systemRed,
        "Blue" : .systemBlue,
        "Brn" : .systemBrown,
        "G" : .systemGreen,
        "Org" : .systemOrange,
        "P" : .systemPurple,
        "Pink" : .systemPink,
        "Y" : .systemYellow
    ]
    
    static let routesArr: [String] =
    [
        "Red",
        "Blue",
        "Brn",
        "G",
        "Org",
        "P",
        "Pink",
        "Y"
    ]
    
}
