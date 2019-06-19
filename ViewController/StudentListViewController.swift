//
//  StudentListViewController.swift
//  On the map
//
//  Created by Mac User on 4/30/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class StudentListViewController: UITableViewController {
    var students = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentLocationData()
    }

    func loadStudentLocationData(){
        if let students = ClientData.studentInformations{
            self.students = students
            self.tableView.reloadData()
        }
    }
//    @IBOutlet weak var postLocation: UIBarButtonItem!
//    @IBOutlet weak var reloadButton: UIBarButtonItem!
//    @IBOutlet weak var logoutButton: UIBarButtonItem!

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentListViewCell", for: indexPath)
        if let cell = cell as? StudentListViewCell {
            let studentLocation = self.students[indexPath.row]
            cell.studentName.text = studentLocation.firstName + " " + studentLocation.lastName
            cell.studentLink.text = studentLocation.mediaURL
        }
        return cell
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

        func showAlert(message: String) {
            let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
    
}
