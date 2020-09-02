//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    @IBOutlet var workOrderTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var calendarViewHeightConstraint: NSLayoutConstraint!
    
    private let cellID = "HomeTableViewCell"
    
    @IBOutlet weak var cleanerListViewModel: CleanerListViewModel!
    @IBOutlet weak var calendarViewModel: CalendarViewModel!
    private var isCalendarOpen: Bool = false
    private let calendarViewHeight: CGFloat = 200
    private let workOrderTableViewTopSpace: CGFloat = 112
    private var pullToRefreshControl = UIRefreshControl()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarViewModel.setTodaysDate()
        self.setupUI()
        self.loadCleanerListModel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(calendarTappedOutside))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar, calendarViewModel: calendarViewModel) {
            calendar.delegate = self
        }
        // for first time bool true set so not perform animation
        openCloseCalendarView(isFirstTime: true)
    }

    //MARK:- UI setups
    private func setupUI() {
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170
        refreshControllerSetup()
    }
    
    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        isCalendarOpen = !isCalendarOpen
        openCloseCalendarView()
    }
    
    // Load latest data from JSON
    func loadCleanerListModel() {
        cleanerListViewModel.fetchCleanerList {
            if cleanerListViewModel.displayErrorMessage {
                self.displayAlert(with: "An error occured", message: cleanerListViewModel.message)
            }
            getSelectedDate(calendarViewModel.selectedDate)
        }
    }
    
    func refreshScreen() {
        DispatchQueue.main.async {
            self.workOrderTableView.reloadData()
            if self.pullToRefreshControl.isRefreshing {
            self.pullToRefreshControl.endRefreshing()
        }
            self.loadCleanerListModel()
        }
    }
}


//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cleanerListViewModel.numberOfItemsInSection(section: section)
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HomeTableViewCell
        
        configureCell(cell: cell, cellForRowAt: indexPath)
        
        return cell
    }
    
    func configureCell(cell: HomeTableViewCell, cellForRowAt indexPath: IndexPath) {
        let carwashVisitViewModel: CarwashVisitViewModel = cleanerListViewModel.getItemAtIndexPath(indexPath: indexPath.row)
        cell.customer.text = carwashVisitViewModel.customer
        cell.arrivalTime.text = carwashVisitViewModel.arrivalTime
        cell.distance.text = carwashVisitViewModel.distance
        cell.status.text = carwashVisitViewModel.status
        cell.tasks.text = carwashVisitViewModel.tasks
        cell.destination.text = carwashVisitViewModel.destination
        cell.statusView.backgroundColor = carwashVisitViewModel.color
        cell.timeRequired.text = carwashVisitViewModel.timeRequired
    }
    
    private func refreshControllerSetup() {
        pullToRefreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        workOrderTableView.addSubview(pullToRefreshControl)
    }
    
    // Pull to refresh
    @IBAction func pullToRefresh() {
        pullToRefreshControl.beginRefreshing()
        self.refreshScreen()
    }
    
}

//MARK:- Get selected calendar date
extension HomeViewController: UIGestureRecognizerDelegate {
    
    private func openCloseCalendarView(isFirstTime : Bool = false) {
        self.calendarViewHeightConstraint.constant = self.isCalendarOpen ?  self.calendarViewHeight : 0
        self.workOrderTableViewTopConstraint.constant = self.isCalendarOpen ? self.workOrderTableViewTopSpace : 0
        UIView.animate(withDuration: isFirstTime ? 0 : 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    // Calendar out side click to hide view
    @IBAction func calendarTappedOutside() {
        if isCalendarOpen == true {
            isCalendarOpen = !isCalendarOpen
            openCloseCalendarView()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Prevent calendar view click to hide
        if touch.view?.isDescendant(of: self.calendarView) == true {
            return false
        }
        return true
    }
    
}

//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    func getSelectedDate(_ selectedDate: Date) {
        cleanerListViewModel.fetchCleanerListsByDate(selectedDate: selectedDate)
        workOrderTableView.reloadData()
        navBar.topItem?.title = selectedDate.hasSame(.day,.month,.year, as: Date()) ? CarFitConstants.TODAY : calendarViewModel.displayDate
    }
}
