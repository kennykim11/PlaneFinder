//
//  DataCollection.swift
//  Plane Finder
//
//  Created by Kenny Kim on 11/3/18.
//  Copyright © 2018 Kenny Kim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Data{
    public var bb :Double = 3
    
    func setBoundingBox(radius :Double) {
        bb = radius
    }
    
    func getPlanes(la :Double, lo :Double){
        let url = URL(string: "https://opensky-network.org/api/states/all?lamin=\(la-bb)&lomin=\(lo-bb)&lamax=\(la+bb)&lomax=\(lo+bb)")!
        //print(url)
        Alamofire.request(url,
                          method: .get,
                          parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //print(json["states"].array?.count ?? -1)
                    //print("JSON: \(json["states"])")
                    for plane in json["states"].array ?? []{
                        if plane[1] != ""{
                            print(plane[1])
                        }
                        //The following commented code works but does not give enough good information
                        //self.getPlaneData(icao: plane.arrayValue[0].rawString()!)
                    }
                case .failure(let error):
                    print("Failure in getting Response")
                }
        }
    }
    
    
    func getPlaneData(icao:String){
        let time :Int = Int(Date().timeIntervalSince1970.rounded())
        let url = URL(string: "https://opensky-network.org/api/flights/aircraft?icao24=\(icao)&begin=\(String(time-3600))&end=\(String(time+3600))")!
        //print(url)
        Alamofire.request(url,
                          method: .get,
                          parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                case .failure(let error):
                    print("Failure in getting Response")
                }
        }
    }
}

