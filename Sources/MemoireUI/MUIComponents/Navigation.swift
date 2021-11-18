//
//  Navigation.swift
//  
//
//  Created by 李昊堃 on 2021/11/5.
//

import SwiftUI

/// 返回按钮的类型，包括返回和确认
public enum NavigationControlType: Int{
    case back,check
    
    func accentColor() -> Color{
        switch self {
        case .back:
            return .mBlue
        case .check:
            return .mYellow
        }
    }
    public func icon() -> some View{
        switch self {
        case .back:
            return Image(systemName: "chevron.backward")
                .controlIconStyle(type: self)
                .mfont(size: .headline)
        case .check:
            return Image(systemName: "checkmark")
                .controlIconStyle(type: self)
                .mfont(size: .headline)
        }
   
    }
}

extension View{
    public func controlIconStyle(type:NavigationControlType) -> some View{
        self//.font(.headline.bold())
        .foregroundStyle(.secondary)
        .padding(10)
        .background(.thickMaterial)
        .background(type.accentColor())
        .clipShape(Circle())
        .padding()
    }
}

public struct NavigationBarViewModifier<T: View>: ViewModifier{
    var title: () -> T
    var type :NavigationControlType
    var backAction: () -> Void
    @Binding var isAppear: Bool
    public func body(content: Content) -> some View {
        VStack{
            if isAppear{
            ZStack{
                HStack{
                Button {
                    print(isAppear)
                    withAnimation(){
                        isAppear = false
                    }
                    print(isAppear)
                    
                    backAction()
                } label: {
                    type.icon()
                }
                    Spacer()
                }
                title()
                   
                Spacer()
            } .mfont(size: .headline)
             
                .transition(.move(edge: .top).animation(.spring()).combined(with: .opacity.animation(.spring())))
                .animation(.spring(), value: isAppear)
            }
            content
        }.onAppear{
            print(isAppear)
            withAnimation(){
                isAppear = true
            }
            print(isAppear)
        }

    }
}

extension View{
    func navigationBar<T: View>(isAppear: Binding<Bool>,title: @escaping () -> T,type:NavigationControlType = .back,backAction: @escaping() -> Void) -> some View{
        self.modifier(NavigationBarViewModifier(title: title, type: type, backAction: backAction, isAppear: isAppear))
    }
}


