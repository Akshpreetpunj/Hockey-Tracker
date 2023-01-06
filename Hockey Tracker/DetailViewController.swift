// I, Akshpreet Singh Punj, student number 000820040, certify that this material is my original work.
// No other person's work has been used without due acknowledgement and I have not made my work available to anyone else.
//
//  DetailViewController.swift
//  Hockey Tracker
//
//  Created by Akshpreet Singh Punj on 2022-11-15.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    // outlets for the textfield and datepicker to store the input from the user
    @IBOutlet var opponentTextField: UITextField!
    @IBOutlet var goalsTextField: UITextField!
    @IBOutlet var assistsTextField: UITextField!
    @IBOutlet var plusMinusTextField: UITextField!
    @IBOutlet var gameDatePicker: UIDatePicker!
    
    // property for a game instance
    var game: Game! {
        // set the navigation title
        didSet {
            if game.opponent != "" {
                navigationItem.title = game.opponent
            } else {
                navigationItem.title = "New Game"
            }
        }
    }
    
    // This method runs when the application starts
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // datepicker alignment
        gameDatePicker.subviews.first?.semanticContentAttribute = .forceRightToLeft
    }
    
    // This method is used to populate the game data into the textfield and datepicker
    // when the view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // populate the textfield and datepicker with the appropriate game data
        opponentTextField.text = game.opponent
        goalsTextField.text = "\(game.goals)"
        assistsTextField.text = "\(game.assists)"
        plusMinusTextField.text = "\(game.plusMinus)"
        gameDatePicker.date = game.gameDate
    }
    
    // This method is used to save the game data when the view will disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save" changes to game
        game.opponent = opponentTextField.text ?? ""
        
        // if the opponent is not empty
        if opponentTextField.text != "" {
            // storing the values from the textfield and datepicker
            // to the game
            
            if let goalText = goalsTextField.text,
                let value = Int(goalText) {
                game.goals = value
            } else {
                game.goals = 0
            }
            
            if let assistsText = assistsTextField.text,
                let value = Int(assistsText) {
                game.assists = value
            } else {
                game.assists = 0
            }
            
            if let plusMinusText = plusMinusTextField.text,
                let value = Int(plusMinusText) {
                game.plusMinus = value
            } else {
                game.plusMinus = 0
            }
            
            game.gameDate = gameDatePicker.date
        }
    }
    
    // This function is used to dismiss the keyboard when the return key is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // This function is used to dismiss the keyboard when the background is tapped
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // This function is used to dismiss the date picker when the value of the
    // date picker changes
    @IBAction func dismissDatePicker(_ sender: UIDatePicker) {
        self.dismiss(animated: true, completion: nil)
    }
}
