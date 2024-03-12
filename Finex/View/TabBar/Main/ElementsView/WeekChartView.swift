//
//  WeekChartView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 07.01.2024.
//

import SwiftUI
import Charts

struct WeekChartView: View {
    
    let weekdays = Calendar.current.shortWeekdaySymbols
    let values = [40, 35, 20, 60, 32, 57, 32]
    
    var body: some View {
        Chart {
            ForEach (weekdays.indices, id: \.self) { index in
                BarMark(
                    x: .value("Day", weekdays[index]),
                    y: .value("Value", values[index])
                )
                .foregroundStyle(Color("paleGreen"))
                .cornerRadius(5)
            }
        }.frame(width: UIScreen.main.bounds.width - 50, height: 150)
    }
}

#Preview {
    WeekChartView()
}
