//
//  JSONFetcher.swift
//  CarFit
//
//  Created by Craig on 02/09/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

// Load Carwash Response from provided JSON
class CarFitClient: NSObject {
    func fetchDataFromJSON() -> CarwashResponse {
        guard let fileURL = Bundle.main.url(forResource: CarFitConstants.JSON_PATH, withExtension: "json") else {
            print("Couldn't find the file")
            return CarwashResponse.init(success: false, message: "Unable to find JSON file", carwashVisits: [], statusCode: 406)
        }
        do {
            let content = try Data(contentsOf: fileURL)
            let carwashResponse = try decode(data: content)
            return carwashResponse
        } catch let error {
            print(error)
        }
        return CarwashResponse.init(success: false, message: "Unable to parse JSON", carwashVisits: [], statusCode: 406)
    }

    // Decode the JSON to and iniatialize carwashResponse Model
    func decode(data: Data) throws -> CarwashResponse {
        do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)

                // Handling both date formats
                dateFormatter.dateFormat = CarFitConstants.DateFormats.DATE_FORMAT
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
                dateFormatter.dateFormat = CarFitConstants.DateFormats.DATE_FORMAT_SSS
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
                
                throw DecodingError.dataCorruptedError(in: container,
                    debugDescription: "Unable to decode Date String \(dateString)")
            }
            let carwashResponse = try decoder.decode(CarwashResponse.self, from: data)
            return carwashResponse
        } catch let error {
            print(error)
            return CarwashResponse.init(success: false, message: "Unable to parse JSON", carwashVisits: [], statusCode: 406)
        }
    }
}

