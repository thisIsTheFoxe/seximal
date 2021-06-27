//
//  MonthView.swift
//  seximal
//
//  Created by Henrik Storch on 26.01.21.
//

import SwiftUI

struct MonthView: View {
    internal init(title: Text, spacing: CGFloat? = nil, currentDay: Int, isLast: Bool) {
        self.title = title
        self.currentDay = currentDay
        self.isLast = isLast
        self.spacing = spacing
        self.columns = Array(repeating: GridItem(.flexible(), spacing: 3, alignment: .trailing), count: isLast ? daysInMonth : 6)
    }
    
    var spacing: CGFloat?
    var columns: Array<GridItem>!
    var title: Text
    var currentDay: Int
    var isLast: Bool
    var daysInMonth: Int {
        isLast ? Calendar.current.daysInYear - 360 : 36
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            title
            LazyVGrid(columns: columns, alignment: .trailing, spacing: 3, content: {
                ForEach(1...daysInMonth, id: \.self) { day in
                    DayText(text: day.asSex(), isCurrentDay: day == currentDay)
                        .scaledToFill()
                }
            })
            .border(Color(UIColor.label), width: 1)
        }
    }
}

struct DayText: View {
    let text: String
    let isCurrentDay: Bool
    
    var body: some View {
        GeometryReader{ g in
        Text(text)
                .font(.system(size:
                                g.size.height > g.size.width ?
                              g.size.width * 0.4 :
                                g.size.height * 0.4))
                .fontWeight(idealFontWeight(for: g.size))
            .lineLimit(1)
            .padding(.top, (g.size.height) * 0.25)
            .padding(.trailing, 2)
            .frame(maxWidth: .infinity, alignment: .topTrailing)
        }
        .foregroundColor(isCurrentDay ? Color(UIColor.systemBackground) : Color(UIColor.label))
        .background(isCurrentDay ? Color(UIColor.label):  Color(UIColor.systemBackground))
    }
    
    func idealFontWeight(for size: CGSize) -> Font.Weight {
        if isCurrentDay { return .heavy }
        else if min(size.height, size.width) <= 20 {
            return .bold
        } else {
            return .regular
        }
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        
        LazyVGrid(columns: [GridItem(), GridItem()], content: {
            MonthView(title: Text("January").font(.headline), currentDay: 2, isLast: true)
            MonthView(title:Text("February").font(.subheadline), currentDay: 36, isLast: false)
                .frame(width: 130, height: 140, alignment: .trailing)
        })
    }
}
