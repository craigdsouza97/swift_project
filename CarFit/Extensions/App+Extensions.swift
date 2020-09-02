//
//  App+Extensions.swift
//  Calendar
//
//Test Project

import UIKit

//MARK:- Navigation bar clear
extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
}
//MARK:- Date
extension Date {
    // Returns start date of the month
    func startDateOfMonth() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self))) else {
            return Date()
        }
        return date
    }
    // Returns end date of the month
    func endDateOfMonth() -> Date {
        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfMonth()) else {
            return Date()
        }
        return date
    }
    // Return either next or previous month
    // value = -1 for previous month, 1 or no value for next month
    func nextOrPrevMonth(value: Int = 1) -> Date {
        guard let date = Calendar.current.date(byAdding: .month, value: value, to: self) else {
            return Date()
        }
        return date
    }
    // Compare two dates
    func hasSame(_ components: Calendar.Component..., as date: Date, using calendar: Calendar = .autoupdatingCurrent) -> Bool {
             return components.filter { calendar.component($0, from: date) != calendar.component($0, from: self) }.isEmpty
    }
}
