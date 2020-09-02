//
//  CarwashVisit.swift
//  CarFit
//
//  Created by Craig on 29/08/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
struct CarwashVisit: Codable{
    let visitId: String
    let homeBobEmployeeId: String
    let houseOwnerId: String
    let isBlocked: Bool
    let startTimeUtc: Date
    let endTimeUtc: Date
    let title: String
    let isReviewed: Bool
    let isFirstVisit: Bool
    let isManual: Bool
    let visitTimeUsed: Double
    let rememberToday: String?
    let houseOwnerFirstName: String
    let houseOwnerLastName: String
    let houseOwnerMobilePhone: String
    let houseOwnerAddress: String
    let houseOwnerZip: String
    let houseOwnerCity: String
    let houseOwnerLatitude: Double
    let houseOwnerLongitude: Double
    let isSubscriber: Bool
    let rememberAlways: String?
    let professional: String
    let visitState: String
    let stateOrder: Int
    let expectedTime: String?
    let tasks: [Task]
    let houseOwnerAssets: [String]
    let visitAssets: [String]
    let visitMessages: [String]
}

struct Task: Codable {
    let taskId: String
    let title: String
    let isTemplate: Bool
    let timesInMinutes: Double
    let price: Double
    let paymentTypeId: String
    let createDateUtc: Date?
    let lastUpdateDateUtc: Date?
    let paymentTypes: String?
}
