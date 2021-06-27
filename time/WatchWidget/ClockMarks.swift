//
//  ClockMarks.swift
//  seximal
//
//  Created by Henrik Storch on 24.06.21.
//

import SwiftUI

struct ClockMarks: View {
    let count: Int
    let longDivider: Int
    let longTickHeight: CGFloat
    let tickHeight: CGFloat
    let tickWidth: CGFloat
    let highlightedColorDivider: Int
    let highlightedColor: Color
    let normalColor: Color
    
    var body: some View {
        ZStack {
            ForEach(0..<self.count) { index in
                let height = (index % self.longDivider == 0) ? self.longTickHeight : self.tickHeight
                let color = (index % self.highlightedColorDivider == 0) ? self.highlightedColor : self.normalColor
                let degree: Double = Double.pi * 2 / Double(self.count)
                TickShape(tickHeight: height)
                    .stroke(lineWidth: self.tickWidth)
                    .rotationEffect(.radians(degree * Double(index)))
                    .foregroundColor(color)
            }
        }
    }
}

struct TickShape: Shape {
    
    let tickHeight: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + self.tickHeight))
        return path
    }
    
}

struct NumberView: View {
    
    let numbers: [Int]
    let textColor: Color
    let font: Font
    
    var body: some View {
        ZStack {
            ForEach(0..<self.numbers.count) { index in
                let degree: Double = Double.pi * 2 / Double(self.numbers.count)
                let itemDegree = degree * Double(index)
                VStack {
                    Text("\(self.numbers[index])")
                        .rotationEffect(.radians(-itemDegree))
                        .foregroundColor(self.textColor)
                        .font(self.font)
                        .foregroundColor(.red)
                    Spacer()
                }
                .rotationEffect(.radians(itemDegree))
            }
        }
    }
    
}

struct ClockHand: Shape {
    let angle: CGFloat
    let length: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length = (rect.width / 2) * self.length
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        path.move(to: center)
        
        let hoursAngle = CGFloat.pi / 2 - .pi * 2 * angle
        
        path.addLine(to: CGPoint(
            x: rect.midX + cos(hoursAngle) * length,
            y: rect.midY - sin(hoursAngle) * length))
        return path
    }
}



struct Clock_Previews: PreviewProvider {
    static var previews: some View {
        ClockMarks(count: 36, longDivider: 6, longTickHeight: 10, tickHeight: 5, tickWidth: 2, highlightedColorDivider: 6, highlightedColor: .red, normalColor: .blue)
            .frame(width: 250, height: 250)
    }
}
