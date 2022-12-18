//
//  MapViewModel.swift
//  CTA
//
//  Created by Chip Chairez on 6/19/22.
//

import Foundation
import MapKit

protocol MapViewModelDelegate{
    
    func didFindLocation(region: MKCoordinateRegion)
    
}

class UserLocationModel: NSObject{
    var region = K.defaultCoordinates
    let locationManager = CLLocationManager()
    var delegate : MapViewModelDelegate?
    
    func findLocation(){
        if(locationManager.location != nil){
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            delegate?.didFindLocation(region: region)
        }
        else if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
        else{
            print("Location is disabled")
        }
    }
    
}


extension UserLocationModel: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedAlways:
            print("authorized always")
        case .notDetermined:
            print("not determined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedWhenInUse:
            print("authorized when in use")
            if(locationManager.location != nil){
                region = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                delegate?.didFindLocation(region: region)
            }
        default:
            print("error")
        }
    }
}
