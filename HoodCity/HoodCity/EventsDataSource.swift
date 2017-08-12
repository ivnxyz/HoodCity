//
//  EventsDataSource.swift
//  HoodCity
//
//  Created by Iván Martínez on 12/08/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

class EventsDataSource: NSObject, UITableViewDataSource {

    var events = [Event]()
    let controller: EventsController
    let tableView: UITableView
    
    init(eventsController: EventsController) {
        self.tableView = eventsController.tableView
        self.controller = eventsController
    }
    
    //MARK: - Helper
    
    func update(with event: Event) {
        events.append(event)
        
        tableView.reloadData()
    }
    
    //MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier, for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
        
        let event = events[indexPath.row]
        cell.configure(with: event)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event = events[indexPath.row]
            
            controller.remove(event, completionHandler: { (error) in
                guard error == nil else {
                    print(error!)
                    return
                }
                
                self.events.remove(at: indexPath.row)
                self.controller.getEventsForCurrentUser()
            })
        }
    }
    
}
