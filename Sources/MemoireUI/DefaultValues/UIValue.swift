//
//  DefaultUIValue.swift
//  
//
//  Created by 李昊堃 on 2021/11/1.
//

import SwiftUI

extension Image{
    public static var placeholderImage: Self{
        Image(systemName: "photo.fill.on.rectangle.fill").symbolRenderingMode(.hierarchical)
    }
    
    public static var arrow2circle: Image{
        return Image("arrow.2.circle", bundle: .module)
    }
}


extension Text{
    public func humanizedStorageText() -> Self{
        return Text("\(Text("资料库已用空间：").mfont(size: .bannerBody)) \(self.mfont(size: .bannerTitle,weight: .bold))")
    }
}


extension CGFloat{
    public static var buttonBorder: Self{ 7 }
    
    public static var iconSmall: Self{ 30 }
    
    public static var iconMedium: Self {45}
    
    public static var iconLarge: Self {80}
    
    public static var radius: Self{15}
    
    public static var radiusL: Self{20}
    
    #if os(iOS)
    public static var  defaultUISCreenHeight: Self {UIScreen.main.bounds.height}
    public static var  defaultUISCreenWidth:Self { UIScreen.main.bounds.width}
    #endif
}


public let errorPlaceHolder: String = "出现了一些问题"
public let errorPlaceHolderLocalized: LocalizedStringKey = LocalizedStringKey(errorPlaceHolder)
