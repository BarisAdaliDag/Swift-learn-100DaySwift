//
//  TableViewController.swift
//  challangeDay32
//
//  Created by Ada on 24.01.2024.
//

import UIKit

class TableViewController: UITableViewController {
    
    var shoppingList : [String] = ["marul","patlican"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    @IBAction func rightBarButonAction(_ sender: Any) {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit(_ answer: String) {
        shoppingList.insert(answer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    
        
    }
    
    
    @IBAction func leftBarButtonAction(_ sender: UIBarButtonItem) {
        // text to share
        let text = shoppingList.joined(separator: "\n")
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
       activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.airDrop ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingList.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }



}
