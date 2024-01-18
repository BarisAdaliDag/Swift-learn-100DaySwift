//
//  ViewController.swift
//  Project2
//
//  Created by Ada on 17.01.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionIndex = 0
    let howMantgame = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
        
        
        
        //        countries.append("estonia")
        //        countries.append("france")  yerine
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        
        
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        
        
        askQuestion()
       
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + " --> Score = \(score) "
        
    }
    
 
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title : String
        
      

        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        if questionIndex < howMantgame - 8 {
            questionIndex += 1
           
            showScore()

        }else {
            print("buraya girdi")
            
            questionIndex = 0
            score = 0
            let ac1 = UIAlertController(title: "You Finished Game ",message: "Final score is \(score).",preferredStyle: .alert)
            ac1.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac1, animated: true)
        }
        
        
       
    }
    @objc func showScore() {
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
        
        
    }
    
    
    
    
    
}
