//
//  Home.swift
//  Moneyism (iOS)
//
//  Created by Teruya Hasegawa on 22/05/22.
//

import SwiftUI

struct Home: View{
    @StateObject var expenseViewModel: ExpenseViewModel = .init()
    @AppStorage("user_name") var userName: String = "Username"
    // MARK: Face/Touch ID Properties
    @EnvironmentObject var lockModel: LockViewModel
    @AppStorage("lock_content") var lockContent: Bool = false
    // MARK: Environment Values
    @Environment(\.self) var env
    var body: some View{
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack(spacing: 12){
                HStack(spacing: 15){
                            Text("Moneyism")
                                .font(.custom("Lato-BlackItalic", size: 28))
                                .lineLimit(1)
                                .foregroundColor(.black.opacity(0.7))
                    .frame(maxWidth: .infinity,alignment: .leading)
                    HStack(spacing: 23){
                        if lockModel.isAvailable{
                            Button {
                                lockContent.toggle()
                                if lockContent{
                                    lockModel.authenticateUser()
                                }
                            } label: {
                                Image(systemName: !lockContent ? "lock.open" : "lock")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black.opacity(0.7))
                                    .frame(width: 25, height: 25)
                                 
                                   
                            }
                        }
                        
                        NavigationLink {
                            StatisticsGraphView()
                                .environmentObject(expenseViewModel)
                        } label: {
                            Image(systemName: "chart.bar.xaxis")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.black.opacity(0.7))
                                .frame(width: 25, height: 25)
                        }
                        
                        NavigationLink {
                            FilterableTransactionView()
                                .environmentObject(expenseViewModel)
                        } label: {
                            Image(systemName: "hexagon.fill")
                                .resizable()
                                         .scaledToFit()
                                .foregroundColor(.black.opacity(0.7))
                                .overlay(content: {
                                    Circle()
                                        .stroke(.white,lineWidth: 2)
                                        .padding(7)
                                })
                                .frame(width: 25, height: 25)
                               
                        }
                    };
                    
                    
                    
                }
                
                DynamicFilteredView(startDate: expenseViewModel.currentMonthStartDate, endDate: Date(), type: "ALL") { (expenses: FetchedResults<Expense>) in
                    ExpenseCard(expenses: expenses)
                        .environmentObject(expenseViewModel)
                    Transactions(expenses: expenses)
                }
            }
            .padding()
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background{
            Color("BG")
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottomTrailing) {
            AddButton()
                .padding()
        }
        .overlay {
            if expenseViewModel.addNewExpense{
                NewExpense()
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: expenseViewModel.addNewExpense)
    }
    
    // MARK: Current Month Transactions View
    @ViewBuilder
    func Transactions(expenses: FetchedResults<Expense>)->some View{
        VStack{
            Text("最近の取引")
                .font(.title2.bold())
                .foregroundColor(.black.opacity(0.7))
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.bottom)
            
            ForEach(expenses){expense in
                TransactionCardView(expense: expense)
                    .environmentObject(expenseViewModel)
            }
        }
        .padding(.vertical)
    }
    
    
    // MARK: Add Expense/Income Button
    @ViewBuilder
    func AddButton()->some View{
        Button {
            expenseViewModel.addNewExpense.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 55, height: 55)
                .background{
                    Circle()
                        .fill(
                            .linearGradient(colors: [
                                Color("Gradient1"),
                                Color("Gradient2"),
                                
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                }
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
        }
    }
    
    // MARK: New Expense View
    @ViewBuilder
    func NewExpense()->some View{
        VStack{
            VStack(spacing: 15){
                Text("取引を追加する")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.5))
                if let symbol = expenseViewModel.convertNumberToPrice(value: 0).first{
                    HStack(alignment: .center, spacing: 6) {
                        TextField("0", text: $expenseViewModel.amount)
                            .font(.system(size: 35))
                            .foregroundColor(Color("Blue"))
                            .multilineTextAlignment(.center)
                            .textSelection(.disabled)
                            .keyboardType(.numberPad)
                            .background {
                                Text(expenseViewModel.amount == "" ? "0" : expenseViewModel.amount)
                                    .font(.system(size: 35))
                                    .opacity(0)
                                    .overlay(alignment: .leading) {
                                        Text(String(symbol))
                                            .opacity(0.5)
                                            .offset(x: -15,y: 5)
                                    }
                            }
                        
                    }
                    .padding(.vertical,10)
                    .frame(maxWidth: .infinity)
                    .background{
                        Capsule()
                            .fill(.white)
                    }
                    .padding(.horizontal,20)
                    .padding(.top,15)
                }
                
                Label {
                    TextField("タイトル", text: $expenseViewModel.remark)
                        .padding(.leading,10)
                } icon: {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                        .font(.title3)
                        .foregroundColor(.black.opacity(0.5))
                }
                .padding(.vertical,20)
                .padding(.horizontal,15)
                .frame(maxWidth: .infinity)
                .background{
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.white)
                }
                .padding(.top,25)
                
                Label {
                    CheckBoxToggle()
                } icon: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.title3)
                        .foregroundColor(.black.opacity(0.5))
                }
                .padding(.vertical,20)
                .padding(.horizontal,15)
                .frame(maxWidth: .infinity)
                .background{
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.white)
                }
                .padding(.top,5)

                Label {
                    DatePicker("", selection: $expenseViewModel.expenseDate ,in: Date.distantPast...Date(),displayedComponents: [.date])
                        .datePickerStyle(.automatic)
                        .labelsHidden()
                        .padding(.leading,10)
                        .frame(maxWidth: .infinity,alignment: .leading)
                } icon: {
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundColor(.black.opacity(0.5))
                }
                .padding(.vertical,20)
                .padding(.horizontal,15)
                .frame(maxWidth: .infinity)
                .background{
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.white)
                }
                .padding(.top,5)
            }
            .frame(maxHeight: .infinity,alignment: .center)
            
            Button {
                expenseViewModel.addExpense(env: env)
            } label: {
                Text("保存")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical,15)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background{
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(colors: [
                                    Color("Gradient1"),
                                    Color("Gradient2"),
                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                    }
            }
            .disabled(expenseViewModel.remark == "" || expenseViewModel.amount == "" || expenseViewModel.type == "")
            .opacity(expenseViewModel.remark == "" || expenseViewModel.amount == "" || expenseViewModel.type == "" ? 0.6 : 1)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            Color("BG")
                .ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing) {
            Button {
                expenseViewModel.addNewExpense = false
                expenseViewModel.clearData()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black.opacity(0.5))
                    .frame(width: 20, height: 20)
            }
            .padding()
        }
    }
    
    // MARK: CheckBox Toggle
    @ViewBuilder
    func CheckBoxToggle()->some View{
        HStack(spacing: 10){
            ForEach(["収入","支出"],id: \.self){type in
                ZStack{
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(.black,lineWidth: 2)
                        .frame(width: 20, height: 20)
                        .opacity(0.5)
                    
                    if expenseViewModel.type == type{
                        Image(systemName: "checkmark")
                            .font(.caption.bold())
                            .foregroundColor(Color("Green"))
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    expenseViewModel.type = type
                }
                
                Text(type)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .opacity(0.6)
                    .padding(.trailing,10)
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.leading,10)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
