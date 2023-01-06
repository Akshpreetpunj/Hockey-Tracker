// I, Akshpreet Singh Punj, student number 000820040, certify that this material is my original work.
// No other person's work has been used without due acknowledgement and I have not made my work available to anyone else.
//
//  GamesViewController.swift
//  Hockey Tracker
//
//  Created by Akshpreet Singh Punj on 2022-11-13.
//

import UIKit

class GamesViewController: UITableViewController {
    
    // property for the game store to access the game data
    var gameStore: GameStore! {
        // set the title
        didSet {
            updateTitle()
        }
    }
    
    // dateFormatter is a variable for the date formatter class
    // to format the date correctly
    let dateFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .none
        return formater
    }()
    
    // This method runs when the application starts
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the table cell row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
        // set the left bar button item (Edit)
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    // This method return the number of sections in the table view
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        // return the count of the game in the games array
        return gameStore.games.count
    }
    
    // This method is used to insert the appropriate data in the table view
    // cell for a particular location
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reusing the same table view cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        // Set the text on the cell with the description of the game
        // that is at the nth index of games, where n = row this cell
        // will appear in on the tableview
        let game = gameStore.games[indexPath.row]
        
        // If the game opponent is empty, ask for the game details
        if game.opponent == "" {
            cell.textLabel?.text = "New game, detail required"
            cell.imageView?.image = UIImage.init(named: "blank")
        } else { // if the game opponent is not empty, populate the table view cell with the game data
            var image = "blank"
            var pointText: String
            
            // checking the plus/minus value for the image in the table view cell
            if game.plusMinus < 0 {
                image = "red"
            } else if game.plusMinus == 0 {
                image = "yellow"
            } else {
                image = "green"
            }
            
            // checking the point value for assigning the points word
            if game.points == 1 {
                pointText = "point"
            } else {
                pointText = "points"
            }
            
            // Adding the game details to the table view cell text label
            cell.textLabel?.text = "\(game.opponent) - \(dateFormatter.string(from: game.gameDate)) - \(game.points) \(pointText)"
            
            // Adding the image to the table view cell imageview
            cell.imageView?.image = UIImage.init(named: image)
        }
        
        return cell
    }
    
    
    /// This action method add new game to the game store and table view when the user touch the add bar button
    /// - Parameter sender: Add bar button
    @IBAction func addNewGame(_ sender: UIBarButtonItem) {
        // Create a new game and add it to the store
        gameStore.create()
        
        // Build an index path that reflects that the new game
        // is now the last game in the array
        let lastRow = gameStore.games.count - 1
        let indexPath = IndexPath(row: lastRow, section: 0)
        
        // Insert this new row into the table
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // update the navigation title
        updateTitle()
    }
    
    // This method is used for deleting the games from the game store and from the
    // table view when the user is in the editing style mode
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            // Remove the game from the game store
            gameStore.deleteGame(at: indexPath.row)
            
            // Also remove that row from the table with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // update the navigation title
            updateTitle()
        }
    }
    
    // This method is used to move an item in the game array and the table view
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        // Update the model
        gameStore.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // This method is used to send/pass the game data to detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showGame" segue
        switch segue.identifier {
        case "showGame":
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the game associated with this row and pass it along
                let game = gameStore.games[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.game = game
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // This method is used to reload the table view and update navigation title when
    // the view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // update the navigation title
        updateTitle()
        
        // reload the table view data
        tableView.reloadData()
    }
    
    // This function updates the navigation title
    func updateTitle() {
        var totalPoint = 0
        var pointText: String
        var gameText: String
        
        // Looping through the game array to calculate the total game
        // points in all the games
        for game in gameStore.games {
            totalPoint += game.points
        }
        
        // checking the game count for assigning the games word
        if gameStore.games.count == 1 {
            gameText = "Game"
        } else {
            gameText = "Games"
        }
        
        // checking the total points value for assigning the points word
        if totalPoint == 1 {
            pointText = "Point"
        } else {
            pointText = "Points"
        }
        
        // if there is no games in the game store
        if (gameStore.games.count == 0) {
            // set the navigation title
            navigationItem.title = "No Games"
        } else { // if there are games in the game store
            // set the navigation title
            navigationItem.title = "\(gameStore.games.count) \(gameText) - \(totalPoint) \(pointText)"
            
            // set the navigation back button title
            navigationItem.backButtonTitle = "Back"
        }
    }
}
