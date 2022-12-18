////
////  dummyarrivalmanager.swift
////  CTA
////
////  Created by Chip Chairez on 6/21/22.
////
//
//import Foundation
////
////  ServiceManager.swift
////  CTA
////
////  Created by Chip Chairez on 6/20/22.
////
//
//import Foundation
//
//struct ArrivalManager{
//    let urlTemplate = "https://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=81655662d02448cea9cc9f567926199e&max=1&outputType=JSON"
//
//    func fetchArrival(stopIDArr: [String]){
//        var urlArray: [String] = []
//        for stopID in stopIDArr{
//            urlArray.append(urlTemplate + "&stpid=" + stopID)
//        }
//
//        dispatchRequest(urlArray: urlArray)
//
//    }
//
//    func dispatchRequest(urlArray: [String]){
//        let group = DispatchGroup()
//
//        for urlString in urlArray{
//            print(urlString)
//            guard let url = URL(string: urlString) else{
//                continue
//            }
//            group.enter()
//            let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
//                defer{
//                    group.leave()
//                }
//                guard let data = data else{
//                    return
//                }
//                print(data)
//
//            }
//            task.resume()
//        }
//
//        group.notify(queue: .main) {
//            print("-------")
//        }
//
//    }
//
//
//
//
//}
