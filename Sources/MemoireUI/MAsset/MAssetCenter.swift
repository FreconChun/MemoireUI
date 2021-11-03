//
//  File.swift
//  
//
//  Created by 李昊堃 on 2021/11/3.
//

import SwiftUI

/// MAsset组件的ViewModel，是MAsset中集中处理数据返回UI的单元
@MainActor
public class MAssetCenter: ObservableObject{
    ///用户选择需要保留的资源类型
    @AppStorage("localAssetsGroup") public var storedAssetGroup: [MAssetGroup] = []
    
    ///云端获得的所有类型，也是对应的视图状态
    @Published public var allAssetGroup: [MAssetGroup] = []
    
    
    public init(){}
    
 ///返回Masset目录下的资源总大小
    public func totalStorage() -> Text {
        do{
   
            let storage = try assetsRootURL.directoryTotalAllocatedSize(includingAllSubfolders: true)
           //使用MB和GB来描述数据
            let formatter = ByteCountFormatter()
            formatter.countStyle = .file
            formatter.allowsNonnumericFormatting = true
            formatter.allowedUnits = [.useMB,.useGB]
            
            guard let intStorage = storage else{
                return Text(errorPlaceHolderLocalized)
            }
            
            let nsstorage = NSNumber(value: intStorage)
            
            return Text(nsstorage, formatter: formatter)
        }catch let error{
            print(error)
        }
        return Text(errorPlaceHolderLocalized)
    }
    
    /// 将Assettype添加到用户选择的本地数据中，且保证该数据中同一id只有一个，如果新添加的id已经出现，会覆盖该条目
    /// - Parameter assetType: 新添加的group
    public func appendUserAssetGroup(of assetGroup: MAssetGroup) async{
        
        let _ = await MainActor.run {
            storedAssetGroup.uniqueAppend(element: assetGroup)
        }
        
        do{
            print("start downloading")
            try await downloadingRemoteAsset(of: assetGroup)
        }catch let error{
            changeStatus(of: assetGroup, to: .error)
            print(error)
        }
        
    }
    
    ///将状态为error的Group删除并且重新下载
    public func resumeAssetGrop(of assetGroup: MAssetGroup) async{
        guard getStatus(of: assetGroup) == .error else{ return }
        removeUserAssetGroup(of: assetGroup)
        await appendUserAssetGroup(of: assetGroup)
    }
    
    ///根据传入类型的id删除本地Group记录
    public func removeUserAssetGroup(of assetGroup: MAssetGroup){
        changeStatus(of: assetGroup, to: .noStored)
        let deleteStatus = assetGroup.deleteAsset()
        if !deleteStatus{
            changeStatus(of: assetGroup, to: .error)
        }else{
        storedAssetGroup.removeAll(where: {$0.id == assetGroup.id})
        }
    }

    ///下载选中group的Asset
    private func downloadingRemoteAsset(of group: MAssetGroup) async throws{
        changeStatus(of: group, to: .downloading)
        let data = try await MemoireCloud.shared.loadAssets(of: group)
        //print(data)
        data.forEach { id,name,asset in
            let url = group.storeAsset(id: id, name: name, asset: asset)
            print("success store to \(String(describing: url))")
        }
        changeStatus(of: group, to: .synced)
    }
    
    ///将cloud上的MAssets类型同步到Memory中
    public func fetchRemoteAssetGroup()async throws{
        do{
            let remoteAssetsType = try await MemoireCloud.shared.loadAssetsType()
//          //  await MainActor.run {
            allAssetGroup = remoteAssetsType
//            }
            
            //设置当前状态
            allAssetGroup.forEach { remoteVersion in
                //将所有的状态设置为未同步
                changeStatus(of: remoteVersion, to: .noStored)
                if let localVersion = storedAssetGroup.first(where: {$0.id == remoteVersion.id}){
                    //如果云端版本号和本地一致,设置状态为两端同步
                    if remoteVersion.version == localVersion.version{
                        changeStatus(of: localVersion, to: .synced)
                    }else{
                        //如果版本号不同，设置状态为远端改变
                        changeStatus(of: localVersion, to: .changed)
                    }
                }
            }
            
        }catch let error{
            print("error \(error)")
        }
    }
    
    
    ///根据提供的数据，修改用来显示的视图模型
    func changeStatus(of asset: MAssetGroup,to status: MAssetGroupStatus){
        guard let index = allAssetGroup.firstIndex(where: {$0.id == asset.id}) else{ return}
        allAssetGroup[index].status = status
    }
    
    ///返回对应Asset的当前状态
    func getStatus(of asset: MAssetGroup) -> MAssetGroupStatus{
        allAssetGroup.first(where: {$0.id == asset.id})?.status ?? .noStored
    }
    
}
