//
//  EventsController.swift
//  HoodCity
//
//  Created by Iván Martínez on 12/08/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import Firebase

class EventsController: UITableViewController {
    
    // MARK:  UI elements
    
    lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        return loadingView
    }()
    
    // MARK: - Dependencies
    
    let firebaseClient = FirebaseClient()
    let geoFireClient = GeoFireClient()
    
    lazy var dataSource: EventsDataSource = {
        return EventsDataSource(eventsController: self)
    }()
    
    // MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()
        
        getEventsForCurrentUser()
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //MARK: - Events
    
    func getEventsForCurrentUser() {
        startLoadingView()
        
        guard let user = Auth.auth().currentUser else {
            stopLoadingView()
            return
        }
        
        firebaseClient.getEventsFor(user.uid) { (event) in
            guard let event = event else {
                self.tableView.reloadData()
                self.stopLoadingView()
                self.showEmptyTableViewMessage()
                return
            }
            
            self.stopLoadingView()
            self.dataSource.update(with: event)
        }
    }
    
    func showEmptyTableViewMessage() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = NSLocalizedString("EventsController.EmptyTableViewMessage", comment: "")
        label.textColor = UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        tableView.backgroundView = label
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
    }
    
    //MARK: - Loading View
    
    func startLoadingView() {
        view.addSubview(loadingView)
        
        guard let navigationBarHeight = navigationController?.navigationBar.frame.height else { return }
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -navigationBarHeight),
            loadingView.heightAnchor.constraint(equalToConstant: 80),
            loadingView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        loadingView.start()
    }
    
    func stopLoadingView() {
        loadingView.stop()
    }
    
    // MARK: - Delete event
    
    func remove(_ event: Event, completionHandler: @escaping (Error?) -> Void) {
        startLoadingView()
        
        geoFireClient.remove(event) { (error) in
            guard error == nil else {
                completionHandler(error)
                return
            }
            
            completionHandler(nil)
            self.stopLoadingView()
        }
    }

}
