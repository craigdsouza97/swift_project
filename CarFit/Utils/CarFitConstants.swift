//
//  CarFitConstants.swift
//  CarFit
//
//  Created by Craig on 31/08/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

struct CarFitConstants {
    static let EARTH_RADIUS:Double = 6378.16
    static let MIN_VALUE:Double = Double.leastNormalMagnitude
    static let JSON_PATH:String = "carfit"
    static let TODAY:String = "I DAG"
    
    struct DateFormats {
        static let TIME_FORMAT:String = "HH:mm"
        static let DATE_FORMAT:String = "yyyy-MM-dd'T'HH:mm:ss"
        static let DATE_FORMAT_SSS:String = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        static let MONTH_AND_YEAR:String = "MMMM yyyy"
        static let ONLY_DATE:String = "yyyy-MM-dd"
        static let ONLY_DAY:String = "d"
        static let ONLY_DAY_OF_WEEK = "EEE"
    }
}
