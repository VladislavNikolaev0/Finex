//
//  MonthChartView.swift
//  Finex
//
//  Created by Ангел предохранитель on 07.01.2024.
//

import SwiftUI

struct MonthChartView: View {
    
    var monthDataCost: [(Double, Color)] = [
        (500.0, Color("corn")),
            (740.0, Color("indianRed")),
            (1000.0, Color("royalBlue")),
            (700.0, Color("magicMint")),
            (860.0, Color("amaranthPick")),
            (730.0, Color("royalPurple")),
        ]
    var monthDataIncome: [(Double, Color)] = [
            (1000.0, Color("dollarBill")),
            (700.0, Color("antiqueBrass")),
            (860.0, Color("royalPurple")),
        ]
    
    var body: some View {
        ZStack{
            Pie(slices: monthDataIncome)
                .frame(width: UIScreen.main.bounds.width - 130)
        }
    }
}

struct Piee: View {
    
    @State var slices: [(Double, Color)]
    
    var body: some View {
        Canvas { context, size in
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            var startAngle = Angle.zero
            for (value, color) in slices {
                let angle = Angle(degrees: 360 * (value / total))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(color))
                
                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    MonthChartView()
}

//struct MonthChartView_Previews: PreviewProvider {
//    static let income = Income()
//    static let cost = Cost()
//    
//    static var previews: some View {
//        MonthChartView().environmentObject(income).environmentObject(cost)
//    }
//}
