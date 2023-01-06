// I, Akshpreet Singh Punj, student number 000820040, certify that this material is my original work.
// No other person's work has been used without due acknowledgement and I have not made my work available to anyone else.
//
//  Game.swift
//  Hockey Tracker
//
//  Created by Akshpreet Singh Punj on 2022-11-13.
//

import UIKit

class Game: Codable {
    
    // Opponent name
    var opponent: String
    
    // Total number of goals
    var goals: Int {
        didSet {
            if goals < 0 {
                goals = 0
            }
        }
    }
    
    // Total number of assists
    var assists: Int {
        didSet {
            if assists < 0 {
                assists = 0
            }
        }
    }
    
    // Total points (points = goals + assists)
    var points: Int {
        return goals + assists
    }
    
    // plus/minus
    var plusMinus: Int
    
    // Game date
    var gameDate: Date
    
    // Initializer to give the default values to the properties
    init() {
        opponent = ""
        goals = 0
        assists = 0
        plusMinus = 0
        gameDate = Date()
    }
}
