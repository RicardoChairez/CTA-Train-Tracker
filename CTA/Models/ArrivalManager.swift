//
//  ServiceManager.swift
//  CTA
//
//  Created by Chip Chairez on 6/20/22.
//

import Foundation

protocol ArrivalManagerDelegate{
    func didFetchArrival(arrivalModel: NewArrivalModel)
}

struct ArrivalManager{
    let urlTemplate = "https://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=81655662d02448cea9cc9f567926199e&outputType=JSON"
    var delegate: ArrivalManagerDelegate?
    
    func fetchArrival(mapID: String){
        let url = urlTemplate + "&mapid=" + String(mapID)
        performRequest(url)
    }

    func performRequest(_ urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, urlResponse, error in
                if(error != nil){
                    return
                }
                guard let safeData = data else{
                    return
                }
                guard let arrival = parseJSON(safeData) else{
                    return
                }
                DispatchQueue.main.async {
                    self.delegate?.didFetchArrival(arrivalModel: arrival)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> NewArrivalModel?{

        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(ArrivalData.self, from: data)
            let eta = decodedData.ctatt.eta
            
//            var lat: String?
//            var lon: String?
//            for stop in eta{
//                if lat == nil{
//                    lat = stop.lat
//                    lon = stop.lon
//                }
//            }
//
//            guard let lat = lat, let lon = lon else{
//                return nil
//            }
            var arrivalModel = NewArrivalModel(station: eta[0].staNm, stationID: eta[0].staId)
            for stop in decodedData.ctatt.eta{
                if(arrivalModel.arrivals[stop.rt] == nil){
                    arrivalModel.arrivals[stop.rt] = []
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                if let date = dateFormatter.date(from: stop.arrT){
                    dateFormatter.dateFormat = "hh:mm a"
                    var timeString = dateFormatter.string(from: date)
                    //S  REMOVES 0 IN SINGLE DIGIT HOUR. THIS IS REALLY BAD CODE FIX THIS
                    if(timeString[timeString.startIndex] == "0"){
                        timeString.removeFirst()
                    }
                    arrivalModel.arrivals[stop.rt]?.append(stop.destNm + "$" + timeString + " to " + stop.destNm)
                }
            }
            for (key, value) in arrivalModel.arrivals{
                arrivalModel.arrivals[key]?.sort()
            }
            
//            for each in decodedData.ctatt.eta{
//                for route in arrivalModel.routes{
//                    print(route)
//                    if each.rt == route.key{
//                        if(arrivalModel.routes[each.rt]?[each.stpDe] == nil){
//                            arrivalModel.routes[each.rt]?[each.stpDe] = []
//                        }
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//                        if let date = dateFormatter.date(from: each.arrT){
//                            dateFormatter.dateFormat = "hh:mm a"
//                            var timeString = dateFormatter.string(from: date)
//                            //S  REMOVES 0 IN SINGLE DIGIT HOUR. THIS IS REALLY BAD CODE FIX THIS
//                            if(timeString[timeString.startIndex] == "0"){
//                                timeString.removeFirst()
//                            }
//                            //E
//
//                            //S checks if due. sets arrival time
//                            if each.isApp == "1"{
//                                arrivalModel.routes[each.rt]?[each.stpDe]?.append(Arrival(due: true, time: timeString, destination: each.destNm))
//                            }
//                            else{
//                                arrivalModel.routes[each.rt]?[each.stpDe]?.append(Arrival(due: false, time: timeString, destination: each.destNm))
//                            }
//                            //E
//                        }
//                    }
//                }
//            }
            return arrivalModel
        }
        catch{
            print(error)
            return nil
        }
    }
}
