//
//  ExpenseCardView.swift
//  Moneyism (iOS)
//
//  Created by Teruya Hasegawa on 22/05/22.
//

import SwiftUI

struct ExpenseCard: View{
    var expenses: FetchedResults<Expense>
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    var isDetail: Bool = false
    var body: some View{
        GeometryReader{proxy in
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    .linearGradient(colors: [
                        Color("Gradient1"),
                        Color("Gradient2"),
                 
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            
            VStack(spacing: 15){
                VStack(spacing: 15){
                    Text(isDetail ? expenseViewModel.convertDateToString() : expenseViewModel.currentMonthString())
                        .font(.callout)
                        .fontWeight(.semibold)
                        
                    Text(expenseViewModel.convertExpensesToPrice(expenses: expenses))
                        .font(.system(size: 35, weight: .bold))
                        .lineLimit(1)
                        .padding(.bottom,5)
                }
                .offset(y: -10)
                
                HStack(spacing: 15){
                    Image(systemName: "arrow.down")
                        .font(.caption.bold())
                        .foregroundColor(Color("Green"))
                        .frame(width: 30, height: 30)
                        .background(Color.white.opacity(0.7),in: Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("収入")
                            .font(.caption)
                            .opacity(0.7)
                        Text(expenseViewModel.convertExpensesToPrice(expenses: expenses,type: "収入"))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize()
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Image(systemName: "arrow.up")
                        .font(.caption.bold())
                        .foregroundColor(Color("Red"))
                        .frame(width: 30, height: 30)
                        .background(Color.white.opacity(0.7),in: Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("支出")
                            .font(.caption)
                            .opacity(0.7)
                        Text(expenseViewModel.convertExpensesToPrice(expenses: expenses,type: "支出"))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize()
                    }
                    .padding(.trailing)
                }
                .padding(.horizontal)
                .offset(y: 15)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .animation(.none, value: expenses.count)
        }
        .frame(height: 220)
        .padding(.top)
    }
}
struct ExpenseCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
