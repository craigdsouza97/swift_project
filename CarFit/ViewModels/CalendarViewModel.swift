//
//  CalendarViewModel.swift
//  CarFit
//
//  Created by Craig on 02/09/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
class CalendarViewModel: NSObject {
    var monthAndYear: String!
    var daysOfMonth: [CalendarModel] = []
    private var currentDate: Date!
    var selectedDate: Date!
    var displayDate: String!
}

extension CalendarViewModel {
    
    // Initialize the model with todays date
    func setTodaysDate() {
        let date = Date()
        self.currentDate = date
        self.selectedDate = date
        setValuesFromCurrentDate()
    }
    
    // Get previous months days
    func getPreviousMonth() {
        currentDate = currentDate.nextOrPrevMonth(value: -1)
        setValuesFromCurrentDate()
    }
    
    // Get next months days
    func getNextMonth() {
        currentDate = currentDate.nextOrPrevMonth()
        setValuesFromCurrentDate()
    }
    
    // Initialize remianing values based on the current Date
    func setValuesFromCurrentDate() {
        let startDate = currentDate.startDateOfMonth()
        let endDate = currentDate.endDateOfMonth()
        
        getDatesFromCalendar(fromDate: startDate, toDate: endDate) { (listOfDates) in
            self.daysOfMonth = listOfDates
        }
        self.monthAndYear = formatDateTime(currentDate, CarFitConstants.DateFormats.MONTH_AND_YEAR)
        
        self.displayDate = formatDateTime(selectedDate, CarFitConstants.DateFormats.ONLY_DATE)
    }
    
    // Select a date
    func selectDate(date: Date) {
        self.selectedDate = date
        self.displayDate = formatDateTime(date, CarFitConstants.DateFormats.ONLY_DATE)
    }
    
    // Get the days from the calendar for a particular month
    func getDatesFromCalendar(fromDate: Date, toDate: Date, completion: ((_ listOfDates:[CalendarModel]) -> Void)) {
        var listOfDates = [CalendarModel]()
        let calendar = Calendar.current
        

        let firstDate = CalendarModel(day: formatDateTime(fromDate, CarFitConstants.DateFormats.ONLY_DAY), weekday: formatDateTime(fromDate, CarFitConstants.DateFormats.ONLY_DAY_OF_WEEK), date: fromDate)
        listOfDates.append(firstDate)
        
        var date = fromDate
        
        //Generate Days of the month for given month
        while date < toDate {
            guard let newDate = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
            
            let calendarDate = CalendarModel(day: formatDateTime(newDate, CarFitConstants.DateFormats.ONLY_DAY), weekday: formatDateTime(newDate, CarFitConstants.DateFormats.ONLY_DAY_OF_WEEK), date: newDate)
            if date.hasSame(.day, .month, .year, as: Date()) {
                selectDate(date: date)
            }
            listOfDates.append(calendarDate)
        }
        completion(listOfDates)
    }
    
    func numberOfItemsInSection(section: Int) -> Int{
        return daysOfMonth.count
    }
    
    func getItemAtIndexPath(indexPath: Int) -> CalendarModel {
        return daysOfMonth[indexPath]
    }
}
