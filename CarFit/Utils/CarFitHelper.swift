//
//  CarFitHelper.swift
//  CarFit
//
//  Created by Craig on 31/08/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

// This function calculates the distance between two points
func calculateDistance(_ prevLat: Double,_ prevLong: Double,_ currLat: Double,_ currLong: Double) -> Double {
    if prevLat == CarFitConstants.MIN_VALUE && prevLong == CarFitConstants.MIN_VALUE {
        return 0
    }
    let dLat = radian(prevLat - currLat)
    let dLong = radian(prevLong - currLong)
    var dist = pow(sin(dLat/2),2) + cos(radian(prevLat)) * cos(radian(currLat)) * pow(sin(dLong/2),2)
    dist = 2 * atan2(sqrt(dist), sqrt(1 - dist))
    return dist * CarFitConstants.EARTH_RADIUS // distance * radius of the Earth in KMs
}

//  This function converts decimal degrees to radians
func radian(_ deg:Double) -> Double {
        return deg * Double.pi / 180
}

// This function formats the time into the 'HH:mm' format
func formatDateTime(_ date: Date, _ format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}
