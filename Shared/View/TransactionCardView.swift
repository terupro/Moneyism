//
//  TransactionCardView.swift
//  Moneyism (iOS)
//
//  Created by Teruya Hasegawa on 22/05/22.
//

import SwiftUI

struct TransactionCardView: View{
    var expense: Expense
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @Environment(\.self) var env
    var body: some View{
        HStack(spacing: 12) {
            if let first = expense.remark?.first{
                Text(String(first).capitalized)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(expense.type == "支出" ? Color("Red") : Color("Green"),in: Circle())
                    .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
            }
            
            Text(expense.remark ?? "タイトル")
                .fontWeight(.semibold)
                .opacity(0.7)
                .frame(maxWidth: .infinity,alignment: .leading)
                .lineLimit(1)
            
            VStack(alignment: .trailing, spacing: 7) {
                let currenyString = expenseViewModel.convertNumberToPrice(value: expense.type == "支出" ? -expense.amount : expense.amount)
                Text(currenyString)
                    .font(.callout)
                    .opacity(0.7)
                    .foregroundColor(expense.type == "支出" ? Color("Red") : Color("Green"))
                Text((expense.date ?? Date()).formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                    .opacity(0.5)
            }
        }
        .padding()
        .background(Color.white,in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .contextMenu{
            Button("削除"){
                env.managedObjectContext.delete(expense)
                try? env.managedObjectContext.save()
            }
        }
    }
}

struct TransactionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
