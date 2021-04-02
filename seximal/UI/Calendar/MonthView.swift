//
//  MonthView.swift
//  seximal
//
//  Created by Henrik Storch on 26.01.21.
//

import SwiftUI

struct MonthView: View {
    internal init(title: String, currentDay: Int, isLast: Bool) {
        self.title = title
        self.currentDay = currentDay
        self.isLast = isLast
        self.columns = Array(repeating: GridItem(.flexible(), spacing: 3, alignment: .trailing), count: isLast ? daysInMonth : 6)
    }
    
    var columns: Array<GridItem>!
    var title: String
    var currentDay: Int
    var isLast: Bool
    var daysInMonth: Int {
        isLast ? Calendar.current.daysInYear - 360 : 36
    }
    
   
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            LazyVGrid(columns: columns, alignment: .trailing, spacing: 3, content: {
                ForEach(1...daysInMonth, id: \.self) { day in
                    Text(day.asSex())
                        .font(.footnote)
                        .fontWeight(day == currentDay ? .bold: nil)
                        .padding(2)
                        .frame(maxWidth: .infinity, minHeight: 25, alignment: .trailing)
                        .foregroundColor(day == currentDay ? Color(UIColor.systemBackground) : Color(UIColor.label))
                        .background(day != currentDay ? Color(UIColor.systemBackground) : Color(UIColor.label))
                }
            })
            .border(Color(UIColor.label), width: 1)
        }
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        
        LazyVGrid(columns: [GridItem(), GridItem()], content: {
            MonthView(title: "January", currentDay: 2, isLast: true)
            MonthView(title: "Februray", currentDay: 2, isLast: false)
        })
    }
}
