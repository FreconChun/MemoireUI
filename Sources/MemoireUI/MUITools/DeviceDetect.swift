

//
//  DeviceDetect.swift
//  DeviceDetect
//
//  Created by 李昊堃 on 2021/8/13.
//

import SwiftUI

public enum Device {
    //MARK:当前设备类型 iphone ipad mac
    public enum Devicetype{
        case iphone,ipad,mac
    }
    
    public static var deviceType:Devicetype{
 
        if  UIDevice.current.userInterfaceIdiom == .pad {
            return .ipad
        }
        else if UIDevice.current.userInterfaceIdiom == .mac{
            return .mac
            
        }else{
            return .iphone
        }

    }
    
    public static func isNotIphone() -> Bool{
        Device.deviceType != .iphone
    }
}

extension View {
    @ViewBuilder public func ifIsMac<T>( transform: (Self) -> T) -> some View where T: View {
        if Device.deviceType == .mac {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder public func ifIsIPad<T>( transform: (Self) -> T) -> some View where T: View {
        if Device.deviceType == .ipad {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder public func ifIsIPhone<T>( transform: (Self) -> T) -> some View where T: View {
        if Device.deviceType == .iphone {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder public func ifIs<T>(_ condition: Bool, transform: (Self) -> T) -> some View where T: View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder public func ifElse<T:View,V:View>( _ condition:Bool,isTransform:(Self) -> T,elseTransform:(Self) -> V) -> some View {
        if condition {
            isTransform(self)
        } else {
            elseTransform(self)
        }
    }
}
