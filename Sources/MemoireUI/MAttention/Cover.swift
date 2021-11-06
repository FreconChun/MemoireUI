//
//  Cover.swift
//  
//
//  Created by 李昊堃 on 2021/11/4.
//

import SwiftUI

struct MCoverModifier: ViewModifier{
    @Binding var showOverlay: Bool
    @EnvironmentObject var attentionCenter: AttentionCenter
    let overlayContent: MView
    func body(content: Content) -> some View {
        content.onChange(of: showOverlay) { newValue in
            //withAnimation(){
            print(overlayContent.id)
            if newValue{
                attentionCenter.addOverlay(overlayContent)
            }else{
                attentionCenter.removeOverlay(id: overlayContent.id)
            }
            //}
        }
            
    }
}

extension View{
    /// 全屏覆盖 + 背景虚化
    public func mCover<Content: View>(id: UUID,isPresenting:Binding<Bool>,content:@escaping () -> Content) -> some View{

        return self.modifier(MCoverModifier(showOverlay: isPresenting, overlayContent: MView(id: id, view: {
            content().eraseToAnyView()
        })))
    }
}
