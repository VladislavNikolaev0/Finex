//
//  CellProfit.swift
//  Finex
//
//  Created by Ангел предохранитель on 27.01.2024.
//

import SwiftUI

struct CellProfit: View {
    
    var user: IncomeItem
    
    var body: some View {
        HStack{
            Text(user.textDate!)
            Spacer()
            Text(user.textDateWeek!)
            Spacer()
            Text("\(user.cat)")
            Spacer()
            Text("\(user.income)")
        }
    }
}

//#Preview {
//    CellProfit()
//}
