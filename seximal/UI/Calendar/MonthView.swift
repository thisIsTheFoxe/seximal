//
//  MonthView.swift
//  seximal
//
//  Created by Henrik Storch on 26.01.21.
//

import SwiftUI

struct MonthView: View {
    internal init(focusedMonth: FocusState<Int?>.Binding, monthIx: Int, title: Text, spacing: CGFloat? = nil, currentDay: Int, isLast: Bool) {
        self.focusedMonth = focusedMonth
        self.monthIx = monthIx
        self.title = title
        self.currentDay = currentDay
        self.isLast = isLast
        self.spacing = spacing
        self.columns = Array(
            repeating: GridItem(.flexible(), spacing: 3, alignment: .trailing),
            count: isLast ? daysInMonth : 6)
    }

    var focusedMonth: FocusState<Int?>.Binding
    var monthIx: Int
    var isFocused: Bool { monthIx == focusedMonth.wrappedValue }

    var spacing: CGFloat?
    var columns: [GridItem]!
    var title: Text
    var currentDay: Int
    var isLast: Bool
    var daysInMonth: Int {
        isLast ? Calendar.current.daysInYear - 360 : 36
    }

    var borderColor: Color {
        #if !os(watchOS)
        return Color(UIColor.label)
        #else
        return .white
        #endif
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
            .border(isFocused ? .red : borderColor, width: isFocused ? 5 : 1)
        }
    }
}

struct DayText: View {
    let text: String
    let isCurrentDay: Bool

    var foreground: Color {
        #if !os(watchOS) && !os(tvOS) && !os(xrOS)
        return isCurrentDay ? Color(UIColor.systemBackground) : Color(UIColor.label)
        #else
        return isCurrentDay ? .black : .white
        #endif
    }

    var background: Color {
        #if !os(watchOS) && !os(tvOS)
        isCurrentDay ? Color(UIColor.label):  Color(UIColor.systemBackground)
        #else
        isCurrentDay ? Color.white:  Color.black
        #endif
    }

    var body: some View {
        GeometryReader { reader in
            Text(text)
                .font(.forViewSize(reader.size))
                .lineLimit(1)
                .padding(.top, (reader.size.height) * 0.25)
                .padding(.trailing, 2)
                .frame(maxWidth: .infinity, alignment: .topTrailing)
        }
        .foregroundColor(foreground)
        .background(background)
    }
}

/*
struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: [GridItem(), GridItem()], content: {
            MonthView(focusedMonth: <#FocusState<String?>.Binding#>, title: "January", currentDay: 2, isLast: true)
            MonthView(focusedMonth: <#FocusState<String?>.Binding#>, title: "Februray", currentDay: 2, isLast: false)
        })
    }
}
*/
