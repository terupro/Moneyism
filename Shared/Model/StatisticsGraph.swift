//
//  StatisticsGraph.swift
//  Moneyism (iOS)
//
//  Created by Teruya Hasegawa on 22/05/22.
//

import SwiftUI

// MARK: Analytics Graph Model
struct StatisticsGraph: Identifiable{
    var id = UUID().uuidString
    var monthString: String
    var monthDate: Date
    var expenses: [Expense]
}
