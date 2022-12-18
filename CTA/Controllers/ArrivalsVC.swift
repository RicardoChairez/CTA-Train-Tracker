//
//  ArrivalsVC.swift
//  CTA
//
//  Created by Chip Chairez on 7/8/22.
//

import UIKit
import MapKit

class ArrivalsVC: UIViewController {
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    var delegate: ArrivalVCDelegate?
    
    var arrivalModel: NewArrivalModel?
    var keys: [String] = []
    
//    var station: String?
//    var tableModel: [String: [String]] = [:]
//    var stationID: String?
    
    var arrivalManager = ArrivalManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrivalManager.delegate = self
        initKeys()
        tableView.dataSource = self
        stationLabel.text = arrivalModel?.station
        

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.arrivalVCDidClose()
    }
    
    func initKeys(){
        keys = []
        for route in K.routesArr{
            if(arrivalModel?.arrivals[route] != nil){
                keys.append(route)
            }
        }
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        guard let latDouble = arrivalModel?.lattitude, let lonDouble = arrivalModel?.longitude else{
            print("No Coordinates")
            return
        }
        
        let latitude: CLLocationDegrees = latDouble
        let longitude: CLLocationDegrees = lonDouble
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = arrivalModel?.station
        mapItem.openInMaps(launchOptions: options)
    }

    
    @IBAction func refreshPressed(_ sender: UIButton) {
        if let stationID = arrivalModel?.stationID {
            refreshButton.isHidden = true
            arrivalManager.fetchArrival(mapID: stationID)
        }
        
    }
    
}

//MARK: - UITableViewDataSource
extension ArrivalsVC: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrivalModel?.arrivals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrivalModel?.arrivals[keys[section]]!.count ?? 0
        

    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let route = K.routes[keys[section]]{
            return route + " Line"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
        }
        //REALLY BAD CODE PLEASE DONT DO THIS
        cell.textLabel?.text = arrivalModel?.arrivals[keys[indexPath.section]]![indexPath.row].components(separatedBy: "$")[1]
        cell.backgroundColor = K.color[keys[indexPath.section]]
        return cell
    }
    
}

//MARK: - ArrivalManagerDelegate
extension ArrivalsVC: ArrivalManagerDelegate{
    func didFetchArrival(arrivalModel: NewArrivalModel) {
        self.arrivalModel = arrivalModel
        tableView.reloadData()
        refreshButton.isHidden = false
    }
    
    
}

//MARK: - ArrivalVCProtocol
protocol ArrivalVCDelegate{
    func arrivalVCDidClose()
}
