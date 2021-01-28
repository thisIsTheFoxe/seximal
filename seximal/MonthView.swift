//
//  MonthView.swift
//  seximal
//
//  Created by Henrik Storch on 26.01.21.
//

import SwiftUI

struct MonthView: View {
    var title: String
    var currentDay: Int? = nil
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .trailing), count: 6)
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            
            LazyVGrid(columns: columns, alignment: .trailing, spacing: 2, content: {
                ForEach(1...36, id: \.self) { day in
                    Text(day.asSex())
                        .font(.footnote)
                        .fontWeight(day == currentDay ? .bold: nil)
                        .padding(1)
                        .frame(width: 28, height: 25, alignment: .trailing)
                        .foregroundColor(day == currentDay ? Color(UIColor.systemBackground) : Color(UIColor.label))
                        .background(day != currentDay ? Color(UIColor.systemBackground) : Color(UIColor.label))
                }
            })
            .border(Color.black, width: 1)

        }
        .padding(3)

    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        
        LazyVGrid(columns: [GridItem(), GridItem()], content: {
            ForEach(["January", "February"], id: \.self) { month in
                MonthView(title: month, currentDay: 36)
            }
        })
    }
    
}
