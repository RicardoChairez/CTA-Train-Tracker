//
//  ViewController.swift
//  CTA
//
//  Created by Chip Chairez on 6/19/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapViewModelDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    var userLocationModel = UserLocationModel()
    var stationManager = StationManager()
    var arrivalManager = ArrivalManager()
    var selectedAnnotation: MKAnnotationView?
    
    lazy var arrivalsVC: ArrivalsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArrivalsVC") as! ArrivalsVC

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setRegion(K.defaultCoordinates, animated: false)
        mapView.delegate = self
        
        userLocationModel.delegate = self
        userLocationModel.findLocation()
        
        stationManager.delegate = self
        stationManager.createStationModel()
        
        arrivalManager.delegate = self
        
        arrivalsVC.delegate = self
        
    }
    
    func didFindLocation(region: MKCoordinateRegion){
        mapView.setRegion(region, animated: false)
    }
}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        
        guard let mapID = annotation.title! else{
            return annotationView
        }
        
        annotationView.frame = CGRect(x: 35, y: 35, width: 35, height: 35)
        let annotationLabel = UILabel(frame: CGRect(x: -35, y: 20, width: 105, height: 30))
        annotationLabel.numberOfLines = 0
        annotationLabel.textAlignment = .center
        annotationLabel.font = UIFont(name: "Avenir", size: 10)
        annotationLabel.alpha = 0.5
        annotationLabel.textColor = .systemGray
        annotationLabel.text = StationModel.stationArray[mapID]?.name
        annotationView.addSubview(annotationLabel)
        annotationView.contentMode = UIView.ContentMode.scaleAspectFit
        //annotationView.backgroundColor = .red
        let annotationImage = UIImageView(frame: annotationView.frame)
        annotationView.addSubview(annotationImage)
        annotationImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        let xConstraint = NSLayoutConstraint(item: annotationImage, attribute: .centerX, relatedBy: .equal, toItem: annotationView, attribute: .centerX, multiplier: 1, constant: 0)

        let yConstraint = NSLayoutConstraint(item: annotationImage, attribute: .centerY, relatedBy: .equal, toItem: annotationView, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        
        annotationImage.image = UIImage(systemName: "tram.fill")
        
       // annotationView.image = UIImage(systemName: "tram.fill")
        
        annotationView.alpha = 0.8
        
        if(StationModel.stationArray[mapID]?.lines["red"] == true){
            annotationImage.tintColor = .systemRed
        } 
        else if(StationModel.stationArray[mapID]?.lines["blue"] == true){
            annotationImage.tintColor = .systemBlue
        }
        else if(StationModel.stationArray[mapID]?.lines["green"] == true){
            annotationImage.tintColor = .systemGreen
        }
        else if(StationModel.stationArray[mapID]?.lines["brown"] == true){
            annotationImage.tintColor = .systemBrown
        }
        else if(StationModel.stationArray[mapID]?.lines["purple"] == true){
            annotationImage.tintColor = .systemPurple
        }
        else if(StationModel.stationArray[mapID]?.lines["yellow"] == true){
            annotationImage.tintColor = .systemYellow
        }
        else if(StationModel.stationArray[mapID]?.lines["pink"] == true){
            annotationImage.tintColor = .systemPink
        }
        else if(StationModel.stationArray[mapID]?.lines["orange"] == true){
            annotationImage.tintColor = .systemOrange
        }
        
        
        return annotationView
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation, let mapID = view.annotation?.title{
            selectedAnnotation = view
            
            var coordinate = annotation.coordinate
            coordinate.latitude -= mapView.region.span.latitudeDelta * 0.30;
            mapView.setCenter(coordinate, animated: true)
            
            
            UIView.animate(withDuration: 0.2) {
                view.alpha = 1.0
                view.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
            }
            //mapView.deselectAnnotation(annotation, animated: true)
            arrivalManager.fetchArrival(mapID: mapID!)
        }
    }
}

//MARK: - StationManagerDelegate

extension MapViewController: StationManagerDelegate{
    
    func didCreateStationModel() {
        for station in StationModel.stationArray{
            if let lat = station.value.lat, let lon = station.value.lon{
                let anno = MKPointAnnotation()
                anno.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                anno.title = String(station.key)
                mapView.addAnnotation(anno)
            }
        }
    }
}

//MARK: - ArrivalManagerDelegate

extension MapViewController: ArrivalManagerDelegate{
    func didFetchArrival(arrivalModel: NewArrivalModel) {
        
        //THIS DID NOT WORK
        if(!arrivalsVC.isBeingPresented){
            preparePresent(arrivalModel: arrivalModel)
            self.present(arrivalsVC, animated: true, completion: nil)
        }
        
        
    }
    
    func preparePresent(arrivalModel: NewArrivalModel){
        arrivalsVC.arrivalModel = arrivalModel
        arrivalsVC.initKeys()
        if(arrivalsVC.tableView != nil && arrivalsVC.stationLabel != nil){
            arrivalsVC.stationLabel.text = arrivalsVC.arrivalModel?.station
            arrivalsVC.tableView.reloadData()
        }
        if let sheet = arrivalsVC.sheetPresentationController{
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersGrabberVisible = true
        }
    }
}

//MARK: - ArrivalVCDelegate
extension MapViewController: ArrivalVCDelegate{
    func arrivalVCDidClose() {
        
        UIView.animate(withDuration: 0.2) {
            self.selectedAnnotation?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.selectedAnnotation?.alpha = 0.8
        }
        mapView.deselectAnnotation(selectedAnnotation?.annotation, animated: false)
    }
    
}
