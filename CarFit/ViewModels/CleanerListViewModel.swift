//
//  CarwashVisitViewModel.swift
//  CarFit
//
//  Created by Craig on 30/08/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
import UIKit
class CleanerListViewModel: NSObject {
    var cleanerList: [CarwashVisitViewModel] = []
    var message: String = ""
    var displayErrorMessage: Bool = false
    @IBOutlet private var carFitClient: CarFitClient!
    private var carwashVisits: [CarwashVisit] = []
    
    // Fetching data from JSON
    func fetchCleanerList(completion: () -> ()) {
        let carwashResponse: CarwashResponse = carFitClient.fetchDataFromJSON()
        self.displayErrorMessage = carwashResponse.statusCode != 200 || !carwashResponse.success ? true : false
        self.message = carwashResponse.message
        self.carwashVisits = carwashResponse.carwashVisits
        completion()
    }
    
    // Fetch Data from the model for a particular date
    func fetchCleanerListsByDate(selectedDate: Date) {
        self.cleanerList = []
        let filterCarwashVisits: [CarwashVisit] = self.carwashVisits.filter {(carwashVisit) -> Bool in return
            selectedDate.hasSame(.month,.day,.year, as: carwashVisit.startTimeUtc)
        }
        
        for i in filterCarwashVisits.indices {
            if(i == 0) {
                self.cleanerList.append(CarwashVisitViewModel(filterCarwashVisits[i]))
            } else {
                self.cleanerList.append(CarwashVisitViewModel.init(filterCarwashVisits[i], filterCarwashVisits[filterCarwashVisits.index(before: i)]))
            }
        }
    }
    
    func numberOfItemsInSection(section: Int) -> Int{
        return cleanerList.count
    }
    
    func getItemAtIndexPath(indexPath: Int) -> CarwashVisitViewModel {
        return cleanerList[indexPath]
    }
}

struct CarwashVisitViewModel {
    let customer: String
    let distance: String
    let timeRequired: String
    let status: String
    let tasks: String
    let destination: String
    let color: UIColor
    let arrivalTime: String
    
    init(_ currCarwashVisit: CarwashVisit, _ prevCarwashVisit: CarwashVisit? = nil) {
        self.customer = currCarwashVisit.houseOwnerFirstName + " " + currCarwashVisit.houseOwnerLastName
        self.status = currCarwashVisit.visitState
        var totalTaskTime: Double = 0
        var tasks: String = ""
        
        for task in currCarwashVisit.tasks {
            totalTaskTime += task.timesInMinutes
            tasks += (tasks == "" ? "": ", ") + task.title
        }
        self.timeRequired = String(Int(totalTaskTime))
        self.tasks = tasks
        let distance = calculateDistance(prevCarwashVisit?.houseOwnerLatitude ?? CarFitConstants.MIN_VALUE, prevCarwashVisit?.houseOwnerLongitude ?? CarFitConstants.MIN_VALUE, currCarwashVisit.houseOwnerLatitude, currCarwashVisit.houseOwnerLongitude)
        self.distance =  distance == 0 ? "0 Km" : String(format: "%.2f Km", distance)
        self.destination = currCarwashVisit.houseOwnerAddress + " " + currCarwashVisit.houseOwnerZip + " " + currCarwashVisit.houseOwnerCity
        self.color = UIColor.getStatusColor(status: self.status)
        self.arrivalTime =  formatDateTime(currCarwashVisit.startTimeUtc, CarFitConstants.DateFormats.TIME_FORMAT) + " " + ( currCarwashVisit.expectedTime ?? "" )
    }
}
