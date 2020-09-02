//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol CalendarDelegate: class {
    func getSelectedDate(_ date: Date)
}

class CalendarView: UIView {

    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    var calendarViewModel: CalendarViewModel!
    
    private let cellID = "DayCell"
    weak var delegate: CalendarDelegate?

    //MARK:- Initialize calendar
    private func initialize() {
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: self.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
        monthAndYear.text = calendarViewModel.monthAndYear
    }
    
    //MARK:- Change month when left and right arrow button tapped
    @IBAction func arrowTapped(_ sender: UIButton) {
        if sender == leftBtn {
            calendarViewModel.getPreviousMonth()
        } else {
            calendarViewModel.getNextMonth()
        }
        delegate?.getSelectedDate(calendarViewModel.selectedDate)
        monthAndYear.text = calendarViewModel.monthAndYear
        daysCollectionView.reloadData()
        moveToSelectedDate()
    }
    
    // Selected date scroll to center position
    private func moveToSelectedDate() {
        if let index = calendarViewModel.daysOfMonth.firstIndex(where: {Calendar.current.isDate($0.date, inSameDayAs: calendarViewModel.selectedDate)}) {
            daysCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: true)
        } else {
            daysCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        }
    }
}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarViewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! DayCell
        
       configureCell(cell: cell, cellForRowAt: indexPath)
            
        return cell
    }
        
    func configureCell(cell: DayCell, cellForRowAt indexPath: IndexPath) {
        let calendarModel: CalendarModel = calendarViewModel.getItemAtIndexPath(indexPath: indexPath.row)
        cell.day.text = calendarModel.day
        cell.weekday.text = calendarModel.weekday
        cell.dayView.backgroundColor = UIColor.getDateBackgroundColor(date: calendarModel.date, selectedDate: calendarViewModel.selectedDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
            if calendarViewModel.daysOfMonth.indices.contains(indexPath.row) {
                let selectedDate = calendarViewModel.daysOfMonth[indexPath.row]
                calendarViewModel.selectDate(date: selectedDate.date)
                daysCollectionView.reloadData()
                cell.dayView.backgroundColor = UIColor.daySelected
                delegate?.getSelectedDate(selectedDate.date)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
            cell.dayView.backgroundColor = .clear
        }
    }
    
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView, calendarViewModel: CalendarViewModel) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calendarView?.calendarViewModel = calendarViewModel
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
}
