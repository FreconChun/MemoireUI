//
//  LazyLoading.swift
//  
//
//  Created by 李昊堃 on 2021/11/6.
//

import SwiftUI

public struct LazyLoadingModifier<PlaceHolder: View>:ViewModifier{
    @State var delayTime: Double = 2
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var isDisappearing: Bool
    var placeHolder: () -> PlaceHolder
    public func body(content: Content) -> some View {
   
        if delayTime <= 0 {
            content
                .transition(.scale(scale: 0.8).animation(.spring()).combined(with: .opacity.animation(.spring())))
                .animation(.spring(), value: delayTime)
                .onChange(of: isDisappearing) { newValue in
                    delayTime = 2
                }
        }else{
            placeHolder()
                .transition(.scale(scale: 0.8).animation(.spring()).combined(with: .opacity.animation(.spring())))
                .animation(.spring(), value: delayTime)
                .onReceive(timer) { _ in
                    if delayTime > 0 ,!isDisappearing{
                        delayTime -= 1
                    }
                }
        }
        
    }
}

extension View{
    /// 视图会在延迟时间过后出现
    /// - Parameters: isDisappearing:true 切回placeholder
    public func lazyLoading<PlaceHolder: View>(isDisappearing: Binding<Bool> = .constant(false),delayTime: Double = 2.0,placeHolder: @escaping () -> PlaceHolder) -> some View{
        self.modifier(LazyLoadingModifier(delayTime: delayTime, isDisappearing: isDisappearing, placeHolder: placeHolder))
    }
}
