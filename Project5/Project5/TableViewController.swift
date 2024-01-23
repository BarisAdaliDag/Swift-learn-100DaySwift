//
//  TableViewController.swift
//  Project5
//
//  Created by Ada on 19.01.2024.
//

import UIKit

class TableViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        // dosyadaki string verileri cekmek icin
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }

        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
        
        
    }
    
    @objc  func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
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
        let lowerAnswer = answer.lowercased()

//        let errorTitle: String
//        let errorMessage: String
        if !isPossible(word: lowerAnswer) {
            guard let title = title?.lowercased() else { return }
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title)")
            return
        }
        if !isOriginal(word: lowerAnswer) {
            showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
                return
            }

            if !isReal(word: lowerAnswer) {
                showErrorMessage(errorTitle: "Word not recognised", errorMessage: "You can't just make them up, you know!")
                return
            }

            usedWords.insert(answer, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        

//        if isPossible(word: lowerAnswer) {
//            if isOriginal(word: lowerAnswer) {
//                if isReal(word: lowerAnswer) {
//                    usedWords.insert(answer, at: 0)
//
//                    let indexPath = IndexPath(row: 0, section: 0)
//                    tableView.insertRows(at: [indexPath], with: .automatic)
//
//                    return
//                } else {
//                    errorTitle = "Word not recognised"
//                    errorMessage = "You can't just make them up, you know!"
//                }
//            } else {
//                errorTitle = "Word used already"
//                errorMessage = "Be more original!"
//            }
//        } else {
//            
//            errorTitle = "Word not possible"
//            errorMessage = "You can't spell that word from \(title)"
//        }
//
//        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
    }
    
    
    func showErrorMessage( errorTitle:String , errorMessage:String ) {
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
        
    }
    func isOriginal(word: String) -> Bool {
        guard let titleWord = title?.lowercased() else {return false} // Navigation title - appbar title
             return !usedWords.contains(where: {str in str.lowercased().contains(word)}) && !word.contains(titleWord)
    }
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }

        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }

        return true
    }
   
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker() // ios kutuphanesi kelime gercek olma ihtimali kontrol
        let range = NSRange(location: 0, length: word.utf16.count)//utf16 emojiler ıcın
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        
        
        return  word.count > 3 && misspelledRange.location == NSNotFound
    }

   
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return usedWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

  
   

}
