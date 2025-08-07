//
//  dataModels.swift
//  tableTracker
//
//  Created by vic bender on 8/7/25.
//

import Foundation

struct Player { // all player info with starting values
    var name: String
    var primaryPoints: Int = 0
    var secondaryPoints: Int = 0
    var commandPoints: Int = 1

    var totalPoints: Int {
        primaryPoints + secondaryPoints
    }
}
