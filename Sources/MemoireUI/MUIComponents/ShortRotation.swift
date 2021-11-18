//
//  File.swift
//  
//
//  Created by 李昊堃 on 2021/11/4.
//

import SwiftUI
extension View {
    
    /// Like RotationEffect - but when animated, the rotation moves in the shortest direction.
    /// - Parameters:
    ///   - angle: new angle
    ///   - anchor: anchor point
    ///   - id: unique id for the item being displayed. This is used as a key to maintain the rotation history and figure out the right direction to move
   public func shortRotationEffect(_ angle: Angle,anchor: UnitPoint = .center, id:UUID) -> some View {
        modifier(ShortRotation(angle: angle,anchor:anchor, id:id))
    }
}

///最近距离的rotation effect 防止套圈
struct ShortRotation: ViewModifier {
    static var storage:[UUID:Angle] = [:]
    
    var angle:Angle
    var anchor:UnitPoint
    var id:UUID
    
func getAngle() -> Angle {
    var newAngle = angle
    
    if let lastAngle = ShortRotation.storage[id] {
        let change:Double = (newAngle.degrees - lastAngle.degrees) %% 360.0
          
        if change < 180 {
            newAngle = lastAngle + Angle.init(degrees: change)
        }
        else {
            newAngle = lastAngle + Angle.init(degrees: change - 360)
        }
    }
    
    ShortRotation.storage[id] = newAngle

    return newAngle
}
    
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(getAngle(),anchor: anchor)
    }
}

infix operator %% : DefaultPrecedence
extension Double {
    
    /// Returns modulus, but forces it to be positive
    /// - Parameters:
    ///   - left: number
    ///   - right: modulus
    /// - Returns: positive modulus
    static  func %% (_ left: Double, _ right: Double) -> Double {
        let truncatingRemainder = left.truncatingRemainder(dividingBy: right)
        return truncatingRemainder >= 0 ? truncatingRemainder : truncatingRemainder+abs(right)
    }
}
