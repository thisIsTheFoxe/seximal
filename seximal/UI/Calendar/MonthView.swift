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
            
            #if !os(watchOS)
            .border(Color(UIColor.label), width: 1)
            #else
            .border(.white, width: 1)
            #endif
        }
        .scaledToFill()
    }
}

struct DayText: View {
    let text: String
    let isCurrentDay: Bool
    
    var body: some View {
        GeometryReader { g in
        Text(text)
                .font(.system(size: idealFontSize(for: g.size)))
                .fontWeight(idealFontWeight(for: g.size))
            .lineLimit(1)
            .padding(.top, (g.size.height) * 0.25)
            .padding(.trailing, 2)
            .frame(maxWidth: .infinity, alignment: .topTrailing)
        }
#if !os(watchOS)
        .foregroundColor(isCurrentDay ? Color(UIColor.systemBackground) : Color(UIColor.label))
        .background(isCurrentDay ? Color(UIColor.label):  Color(UIColor.systemBackground))
#else
        .foregroundColor(isCurrentDay ? .black : .white)
        .background(isCurrentDay ? .white:  .black)
#endif
    }
    
    func idealFontWeight(for size: CGSize) -> Font.Weight {
        if isCurrentDay { return .heavy }
        else if min(size.height, size.width) <= 20 {
            return .bold
        } else {
            return .regular
        }
    }
    
    func idealFontSize(for size: CGSize) -> CGFloat {
        let s = size.height > size.width ?
        size.width * 0.4 : size.height * 0.4
        return max(s, 7)
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        
        MonthView(title:Text("February").font(.subheadline), currentDay: 36, isLast: false)
            .frame(width: 120, height: 100)
            .background(Color.red)
    }
}
