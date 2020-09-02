//
//  CarwashResponse.swift
//  CarFit
//
//  Created by Craig on 01/09/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

struct CarwashResponse: Codable {
    let success: Bool
    let message: String
    let carwashVisits: [CarwashVisit]
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case carwashVisits = "data"
        case statusCode = "code"
    }
}
