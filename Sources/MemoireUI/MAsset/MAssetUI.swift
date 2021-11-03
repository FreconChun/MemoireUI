//
//  MAssetUI.swift
//  
//
//  Created by 李昊堃 on 2021/11/3.
//

import SwiftUI

extension MAssetGroup{
    ///本地化组名
    public func label() -> Text{
        return Text(LocalizedStringKey( name))
    }
    
    ///渲染缩略图
    @ViewBuilder
    public func thumbnailImage() -> some View{
        AsyncImage(url: thumbnailURL, content: { image in
            image.resizable().aspectRatio(contentMode: .fill)
        }, placeholder: {
            Image.placeholderImage.resizable().foregroundStyle(Color.accentColor, .secondary, .tertiary).aspectRatio(contentMode: .fill).padding().padding().background(Color.accentColor.opacity(0.3),in:RoundedRectangle(cornerRadius: 5)).padding()
        })
    }
}

extension MAssetGroupStatus{
    ///对应的文字提醒
    public func description() -> Text{
        switch self {
        case .noStored:
            return Text("暂未下载")
        case .synced:
            return Text("准备就绪")
        case .changed:
            return Text("云端数据更新")
        case .syncing:
            return Text("正在同步")
        case .downloading:
            return Text("正在下载")
        case .error:
            return Text("出现错误")
        }
    }
}
