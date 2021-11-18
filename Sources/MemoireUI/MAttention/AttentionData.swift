//
//  OverlayData.swift
//  
//
//  Created by 李昊堃 on 2021/11/1.
//

import SwiftUI

///Alert的数据模型
public struct AlertViewData: Identifiable{
    public init(id: UUID = UUID(), title: LocalizedStringKey, content: Text? = nil, controls: [Action]) {
        self.id = id
        self.title = title
        self.content = content
        self.controls = controls
    }
    
    public var id: UUID = UUID()
    public  var title: LocalizedStringKey
    public  var content: Text?
    public  var controls: [Action]
    
}

///Dialog的数据模型
public struct DialogData: Identifiable{
    public init(id: UUID = UUID(), content: Text, controls: [Action]) {
        self.id = id
        self.content = content
        self.controls = controls
    }
    
    public var id = UUID()
    public var content: Text
    public var controls: [Action]
}

///Banner的数据模型
public struct BannerViewData: Identifiable{
    public init(id: UUID = UUID(), title: LocalizedStringKey, autoDismiss: Bool = true,subTitle: LocalizedStringKey? = nil, icon: Image,tintColor:Color = .primary) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.icon = icon
        self.autoDismiss = autoDismiss
        self.tintColor = tintColor
    }
    
    public var id: UUID = UUID()
    public var title: LocalizedStringKey
    public var subTitle: LocalizedStringKey?
    public var icon: Image
    public var autoDismiss: Bool = true
    public var tintColor: Color = .primary
}
