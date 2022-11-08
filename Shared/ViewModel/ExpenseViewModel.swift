//
//  ExpenseViewModel.swift
//  Moneyism (iOS)
//
//  Created by Teruya Hasegawa on 22/05/22.
//

import SwiftUI

class ExpenseViewModel: ObservableObject{
    // MARK: Type
    @Published var currentType: String = "支出"
    // MARK: Filter Properties
    @Published var showFilters: Bool = false
    @Published var currentMonthStartDate: Date = Date()
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    // MARK: Add Expense Properties
    @Published var addNewExpense: Bool = false
    @Published var remark: String = ""
    @Published var expenseDate: Date = Date()
    @Published var type: String = ""
    @Published var amount: String = ""
        
    init(){
        // MARK: Setting Month Starting Date
        let calendar = Calendar.current
        let todayDate = Date()
        let components = calendar.dateComponents([.year,.month], from: todayDate)
        let startOfMonth = calendar.date(from: components)
        self.currentMonthStartDate = startOfMonth!
        self.startDate = startOfMonth!
    }
    
    func convertDateToString()->String{
        return startDate.formatted(date: .abbreviated, time: .omitted) + " - " + endDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    // MARK: Current Month First To Today Date
    func currentMonthString()->String{
        return currentMonthStartDate.formatted(date: .abbreviated, time: .omitted) + " - " + Date().formatted(date: .abbreviated, time: .omitted)
    }
    
    // MARK: Converting Number to Price
    func convertNumberToPrice(value: CGFloat)->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: value)) ?? ""
    }
    
    func convertExpensesToPrice(expenses: FetchedResults<Expense>,type: String = "")->String{
        var value: CGFloat = 0
        if type == ""{
            value = expenses.reduce(0.0) { partialResult, expense in
                return partialResult + (expense.type == "収入" ? expense.amount : -expense.amount)
            }
        }else{
            value = expenses.reduce(0.0) { partialResult, expense in
                return partialResult + (expense.type == type ? expense.amount : 0)
            }
        }
        
        return convertNumberToPrice(value: value)
    }
    
    // MARK: Adding New Expense
    func addExpense(env: EnvironmentValues){
        let colors = ["Red","Green"]
        let expense = Expense(context: env.managedObjectContext)
        expense.amount = (amount as NSString).doubleValue
        expense.remark = remark
        expense.type = type
        expense.date = expenseDate
        expense.color = colors.randomElement()
        
        if let _ = try? env.managedObjectContext.save(){
            addNewExpense = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.clearData()
            }
        }
    }
    
    // MARK: Clearing Data
    func clearData(){
        amount = ""
        remark = ""
        type = ""
        expenseDate = Date()
    }
}
