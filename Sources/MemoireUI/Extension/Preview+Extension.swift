//
//  Preview+Extension.swift
//  
//
//  Created by 李昊堃 on 2021/11/1.
//

import SwiftUI

extension View{
    ///将组件左侧添加描述标签，适合多组件并列放置时
    public func previewLabel(name: String) -> some View{
        HStack{
            Text(name).mfont(size: .bannerBody,weight: .bold).padding(5)
                .foregroundStyle(.bar)
            Spacer(minLength: 0)
            self
        }
    }
    ///将视图包装成截图的样式
    public func screenshotStye() -> some View{
        self .cornerRadius(20)
            .scaleEffect(0.9)
            .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 0)
            .clipShape(Rectangle())
    }
    
}
