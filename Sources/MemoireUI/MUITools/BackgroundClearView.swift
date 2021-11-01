//
//  File.swift
//  
//
//  Created by 李昊堃 on 2021/11/1.
//

import SwiftUI
///使用UIView强制使父视图背景为透明
public struct BackgroundClearView: UIViewRepresentable {
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.backgroundColor = .clear
        }
        return view
    }
    
   public func updateUIView(_ uiView: UIView, context: Context) {}
}
