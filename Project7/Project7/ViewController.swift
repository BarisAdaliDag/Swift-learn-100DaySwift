//
//  ViewController.swift
//  Project7
//
//  Created by Ada on 24.01.2024.
//

import UIKit


class ViewController: UITableViewController {

    var petitions = [Petition]()
    
    var filterPetitions = [Petition]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString: String
//MARK: - Tabbbar menu select control
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else if navigationController?.tabBarItem.tag == 1 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        } else
        {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            
            let ac = UIAlertController(title: "Data Coming From Api", message: urlString, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
               present(ac, animated: true)
            
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "filter", style: .plain, target: self, action: #selector(filteredCases))
            
        }
        
        
    
        
//hocanin kod async mor uyari veriyor
//        if let url = URL(string: urlString) {
//            
//            if let data = try? Data(contentsOf: url) {
//               parse(json: data)
//            }
//        }
        downloadData(from: urlString)
        
        
    }
    //MARK: - Dowland data
    
    func downloadData(from url: String) {
            guard let url = URL(string: url) else { return }

            Task {
                let dataLoader = DataLoader()
                let receviedData = await dataLoader.downloadData(url: url)
                if let data = receviedData {
                    parse(json: data)
                } else {
                    
                    showError()
                }
            }
        }
    func showError(){
        let ac = UIAlertController(title: "Loading Error ", message: "There was a problem the feed; check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
           present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
         filterPetitions = petitions
            
            
            tableView.reloadData()
        }
    }
    
    //MARK: - Search function
    @objc func filteredCases() {
            let ac = UIAlertController(title: "placeholder", message: "placeholder", preferredStyle: .alert)
            ac.addTextField()
            
            // from Project 5
            let submitAction = UIAlertAction(title: "Submit", style: .default) {
                [weak self, weak ac] _ in
                guard let answer = ac?.textFields?[0].text else { return }
                self?.submit(answer)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        
        func submit(_ answer: String) {
            
            print("Oncesi" + String(filterPetitions.count))
            
            if answer == ""{
                filterPetitions = petitions
            }else{
                filterPetitions = petitions.filter{
                            $0.body.contains(answer) ? true : false
            }
        
                    }
     
            print("Sonrasi" + String(filterPetitions.count))
            
            
                    tableView.reloadData()
        }
//MARK: - Sourcetreee
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPetitions.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filterPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        var content = cell.defaultContentConfiguration()
                content.textProperties.numberOfLines = 1
                content.secondaryTextProperties.numberOfLines = 1
                content.text = petition.title
                content.secondaryText = petition.body
                
                cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailVC()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}



//MARK: -  Fecht Data


struct DataLoader {
    func downloadData(url: URL) async -> Data? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch let error {
            print(error)
        }
        return nil
    }
}
