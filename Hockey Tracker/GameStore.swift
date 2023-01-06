// I, Akshpreet Singh Punj, student number 000820040, certify that this material is my original work.
// No other person's work has been used without due acknowledgement and I have not made my work available to anyone else.
//
//  GameStore.swift
//  Hockey Tracker
//
//  Created by Akshpreet Singh Punj on 2022-11-13.
//

import UIKit

class GameStore {
    
    // Creating games array to store all the objects in the game and initialize the array
    var games = [Game]()
    
    // Finding the location of the file named games.plist to persist the game data
    // Creating the file if the file does not exist
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("games.plist")
    }()
    
    // Initializer to unarchive the game data from the file saved in the directory and
    // put them into the array
    init() {
        // Error handling for reading the data from the file
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let decodedGames = try unarchiver.decode([Game].self, from: data)
            games = decodedGames
        } catch {
            print("Error reading in saved games: \(error)")
        }
        
        // observer to call the save changes method on background notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(saveChanges),
                                       name: UIScene.didEnterBackgroundNotification,
                                       object: nil)
    }
    
    /// This function is used for creating a new game and adding it to the game array. The function is discardable result
    /// so that we can ignore the return value when we do not need it
    /// - Returns: new game
    @discardableResult func create() -> Game {
        let newGame = Game()
        
        // appending the new game to the game array
        games.append(newGame)
        
        return newGame
    }
    
    /// This function is used for deleting the game from the game array
    /// - Parameter index: index value (specific position)
    func deleteGame(at index: Int) {
        // delete the game at the specified position
        games.remove(at: index)
    }
    
    /// This function is used to move the game from one position to another in the game array
    /// - Parameters:
    ///   - fromIndex: from index position
    ///   - toIndex: to index position
    func move(from fromIndex: Int, to toIndex: Int) {
        // if the from and to index position is same
        if fromIndex == toIndex {
            return
        }
        
        // Get reference to object being move so you can reinsert it
        let movedItem = games[fromIndex]
        
        // Remove game from array
        games.remove(at: fromIndex)
        
        // Insert game in array at new location
        games.insert(movedItem, at: toIndex)
    }
    
    // This function is used to save all the game to the file by encoding the games array
    @objc func saveChanges() -> Bool {
        print("Saving games to: \(itemArchiveURL)")
        
        // Error handling for saving the game data to the file
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(games)
            try data.write(to: itemArchiveURL, options: [.atomic])
            print("Saved all of the Games")
            return true
        } catch let encodingError {
            print("Error encoding all games: \(encodingError)")
            return false
        }
    }
}
