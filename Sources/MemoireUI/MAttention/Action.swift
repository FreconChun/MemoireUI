//
//  Action.swift
//  
//
//  Created by 李昊堃 on 2021/11/1.
//

import SwiftUI

public enum ActionType: Int,CaseIterable{
    ///默认的推荐选项
    case prominence
    ///取消/返回
    case cancellation
    ///涉及删除等破坏性操作
    case destruction
}

/// 用来控制Button渲染的类型
public struct Action: Identifiable{
    public init(id: UUID = UUID(), title: Text,type: ActionType? = nil, action: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.action = action
        self.type = type
    }
    
    public var id: UUID = UUID()
    ///标题，Text可以复合样式内插
    public var title: Text
    ///回调函数
    public var action: () -> Void
    ///对应回调函数的类型，nil则视为无类型，使用默认的样式进行渲染
    public var type: ActionType?
    
}

extension View{
    ///提供不同类型Action的渲染方式
    @ViewBuilder
    func buttonStyle(of type: ActionType?) -> some View{
        if let type = type {
            switch type {
            case .prominence:
                self.tint(.accentColor).buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: .buttonBorder))
            case .cancellation:
                self.tint(.mOrange4)
                    .buttonStyle(.bordered)
                
                    .buttonBorderShape(.roundedRectangle(radius: .buttonBorder))
                    .background(.bar,in:RoundedRectangle(cornerRadius: .buttonBorder))
            case .destruction:
                self.tint(.mRed4)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: .buttonBorder))
            }
        }else{
            self
                .tint(.mBlue4)
                .buttonStyle(.bordered)
            
                .buttonBorderShape(.roundedRectangle(radius: .buttonBorder))
                .background(.bar,in:RoundedRectangle(cornerRadius: .buttonBorder))
        }
    }
}
