
//
//  ??+Extension.swift
//  Flags
//
//  Created by 李昊堃 on 2021/10/10.
//

import SwiftUI


public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
