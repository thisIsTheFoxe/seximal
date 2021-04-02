//
//  Optional+Ternary.swift
//  seximal
//
//  Created by Henrik Storch on 27.01.21.
//

precedencegroup Group { associativity: right }

infix operator ??: Group
func ?? <I, O>(_ input: I?, _ handler: (lhs: (I) -> O, rhs: () -> O)) -> O {
    guard let input = input else {
        return handler.rhs()
    }
    return handler.lhs(input)
}

infix operator |: Group
func | <I, O>(_ lhs: @escaping (I) -> O,
              _ rhs: @autoclosure @escaping () -> O) -> ((I) -> O, () -> O) {
    return (lhs, rhs)
}
