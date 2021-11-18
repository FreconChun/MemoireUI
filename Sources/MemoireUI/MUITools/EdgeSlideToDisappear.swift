//
//  EdgeSlideToDisappear.swift
//  
//
//  Created by 李昊堃 on 2021/11/13.
//

import SwiftUI

/// 使视图支持边缘滑动返回
struct EdgeSlideToDisappearViewModeifier: ViewModifier{
    var movetoBottomTransition: Bool = false
    var dismissAction: () -> Void = {}
    
    @State var hapticable: Bool = true
    
    @State var dismissScale: CGFloat = 1
    @State var dismissOffset: CGFloat = 0

    var dragToDisappearGesture: some Gesture{
        DragGesture().onChanged { value in
            if value.startLocation.x < 50{
                if movetoBottomTransition{
                    dismissOffset = value.translation.width
                }else{
                dismissScale = 1 - value.translation.width / (CGFloat.defaultUISCreenWidth * 2)
                }
            }
            if dismissScale < 0.8 || dismissOffset >= CGFloat.defaultUISCreenWidth / 1.5{
                withAnimation(){
                    if hapticable{
                    MHaptic.alert()
                        hapticable = false
                    }
                    dismissAction()
                }
            }
          
        }
        .onEnded { newValue in
            withAnimation(){
                dismissScale = 1
                dismissOffset = 0
                hapticable = true
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .disabled(dismissScale != 1 || dismissOffset != 0)
            .contentShape(Rectangle())
            .scaleEffect(dismissScale)
            .offset(x: 0, y: dismissOffset)
            .gesture(dragToDisappearGesture)
        
    }
}

extension View{
    
    /// 边缘滑动返回
    /// - Parameters:
    ///   - moveToDisappear: true：退出样式为推出，false：推出样式为缩放
    ///   - dismissAction: 消失的回调函数
    public func edgeSlideToDisappear(moveToDisappear: Bool = false,dismissAction: @escaping () -> Void) -> some View{
        self.modifier(EdgeSlideToDisappearViewModeifier(movetoBottomTransition: moveToDisappear,dismissAction:dismissAction))
    }
}
