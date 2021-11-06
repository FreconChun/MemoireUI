//
//  MOverlayData.swift
//  
//
//  Created by 李昊堃 on 2021/11/1.
//

import SwiftUI

let ids = [UUID(),UUID(),UUID(),UUID(),UUID(),UUID(),UUID(),UUID(),UUID(),UUID()]
let updateStoredAssetsID = UUID()
let deleteStoredAssetsID = UUID()
let errorDownloadFromWebBannerID = UUID()

extension AlertViewData{
    
    
    ///隐私政策更改
    public static func deleteCache(action:@escaping () -> Void) -> Self {  AlertViewData(id: ids[0], title: LocalizedStringKey("确认删除应用缓存？"), content: Text("这可能会导致部分功能发生变化"), controls: [
        Action(title: Text("确认"), action: action)])
    }
    
    ///隐私政策更改
    public static var changePolicyAlertData:Self {  AlertViewData(id: ids[0], title: LocalizedStringKey("隐私政策更新"), content: Text("我们的隐私政策发生变化，请您及时关注!"), controls: [
        Action(title: Text("前往查看"), action: { })])
    }
    
    ///删除资料库通知
    public static func deleteStoredAssetsAlertData(content: String,deleteAction:@escaping () -> Void) -> Self {  AlertViewData(id: deleteStoredAssetsID, title: LocalizedStringKey("确认删除？"), content: Text("删除《\(Text(LocalizedStringKey(content)).bold())》资源文件，此操作不影响您的Memoire Book"), controls: [
        Action(title: Text("确认删除"),type:.destruction, action: deleteAction)])
    }
    
    ///更新资料库通知
    public static func updateStoredAssets(content: String,resumeAction: @escaping() -> Void) -> Self{
        AlertViewData(id: updateStoredAssetsID, title: LocalizedStringKey("确认与云端同步？"), content: Text("同步《\(Text(LocalizedStringKey(content)).bold())》资源文件，此操作保持您本地资料库和云端一致，不影响您的Memoire Book"), controls: [
            Action(title: Text("确认同步"),type:.prominence, action: resumeAction)])
    }
}

extension BannerViewData{
    
    ///从云端下载出现问题
    public static var errorDownloadFromWeb: Self { BannerViewData(id: errorDownloadFromWebBannerID, title: LocalizedStringKey("下载失败"),autoDismiss:false, subTitle: LocalizedStringKey("从云端下载资源失败"), icon: Image(systemName: "exclamationmark"))}
    
    
    ///从云端下载数据
    public static var loadFromCloudBannerData: Self { BannerViewData(id: ids[1], title: LocalizedStringKey("正在下载"),autoDismiss:false, subTitle: LocalizedStringKey("从云端下载资源库"), icon: Image(systemName: "icloud.fill"))}
    
    ///创建云端存储
    public static var createCloudPersistence: Self{ BannerViewData(id: ids[2], title: LocalizedStringKey("正在链接"),autoDismiss:false, subTitle: LocalizedStringKey("创建云端资源库"), icon: Image(systemName: "icloud.and.arrow.up.fill"))}
    
    ///上传至云端
    public static var uploadCloudPersistence: Self{ BannerViewData(id: ids[3], title: LocalizedStringKey("正在同步"),autoDismiss:false, subTitle: LocalizedStringKey("上传至云端资源库"), icon: Image(systemName: "icloud.and.arrow.up.fill"))}
    
    ///异步渲染2D场景
    public static var init2DView: Self{ BannerViewData(id: ids[4], title: LocalizedStringKey("正在渲染界面"),autoDismiss:true, subTitle: LocalizedStringKey(""), icon: Image(systemName: "view.2d"))}
    ///异步渲染3D场景或模型
    public static var init3DView: Self{ BannerViewData(id: ids[5], title: LocalizedStringKey("正在渲染界面"),autoDismiss:true, subTitle: LocalizedStringKey(""), icon: Image(systemName: "view.2d"))}
}

extension DialogData{
    ///登出的提示内容
    public static var singOutDialog: Self{
        DialogData(id: ids[6], content:logoutDialog , controls: [Action(title: Text("Log Out"),type: .destruction, action: {})])
    }
}

///登出的文本提示
let logoutDialog: Text = Text(
"""
\(Text("Are you sure to ").mfont(size: .subheadline, weight: .semiBold).foregroundColor(.primary)) \(Text("Log Out").mfont(size: .subheadline, weight: .bold).foregroundColor(.mRed)) \(Text("?").mfont(size: .subheadline, weight: .semiBold).foregroundColor(.primary))

**Logging out will:**

    1.**Delete** all this app's downloading assets(not the assets in Memoire Book).

    2.You **can not upload** to the online Assets Store any more, but downloading is permitted.

    3.You **can not access shared Memoire Book** no matter who created it.

\(Text("**You can still visit your private MemoireBook.**").mfont(size: .bannerBody, weight: .semiBold))

""").mfont(size: .bannerBody)



//public let changePolicyAlertDataT =  AlertViewData(id: UUID(), title: LocalizedStringKey("隐私政策更新"), content: Text("我们的隐私政策发生变化，请您及时关注!"), controls: [
//    Action(title: Text("前往查看"), action: { })])
//
//public let loadFromCloudBannerDataT = BannerViewData(id: UUID(), title: LocalizedStringKey("正在下载"),autoDismiss:false, subTitle: LocalizedStringKey("从云端下载资源库"), icon: Image(systemName: "icloud.fill"))
//
//public let createCloudPersistenceT = BannerViewData(id: UUID(), title: LocalizedStringKey("正在链接"),autoDismiss:false, subTitle: LocalizedStringKey("创建云端资源库"), icon: Image(systemName: "icloud.and.arrow.up.fill"))
//
//public let uploadCloudPersistenceT = BannerViewData(id: UUID(), title: LocalizedStringKey("正在同步"),autoDismiss:false, subTitle: LocalizedStringKey("上传至云端资源库"), icon: Image(systemName: "icloud.and.arrow.up.fill"))
//
//public let init2DViewT = BannerViewData(id: UUID(), title: LocalizedStringKey("正在渲染界面"),autoDismiss:false, subTitle: LocalizedStringKey(""), icon: Image(systemName: "view.2d"))
//
//public let init3DViewT = BannerViewData(id: UUID(), title: LocalizedStringKey("正在渲染界面"),autoDismiss:false, subTitle: LocalizedStringKey(""), icon: Image(systemName: "view.2d"))
