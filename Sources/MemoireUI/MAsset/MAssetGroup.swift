//
//  MAssetGroup.swift
//  
//
//  Created by 李昊堃 on 2021/11/3.
//

import SwiftUI
import CloudKit


///资源的类型，用来控制如何处理云端的数据
public enum AssetCatagory: Int64,CaseIterable,Codable{
    case image = 0
    case usdz = 1
    
    func fileExtension() -> String{
        switch self {
        case .image:
            return "png"
        case .usdz:
            return "usdz"
        }
    }
}



/// Asset组，对应云端的AssetType
public struct MAssetGroup:Identifiable,Codable{
    
    public var id: Int64
    
    ///组名，对应云端的组名，可以Localized
    var name: String
    
    ///云端的AssetType的RecordID
    var recordName: String
    
    ///版本号，用来判断本地和云端的数据是否一致
    var version: Int64
    
    ///资源类型，会影响资源文件后缀名
    var category: AssetCatagory
    
    ///缩略图路径，保证缩略图和云端同步
    var thumbnailURL: URL?
    
    ///状态，向用户反馈本地资源的情况
    public var status: MAssetGroupStatus?
    
    ///返回可以Localized的组名
    public var groupName: String{
        name
    }
    
    init(from record: CKRecord){
        id = record["index"] as! Int64
        name = record["name"] as! String
        version = record["version"] as! Int64
        category = AssetCatagory(rawValue:  record["category"] as! Int64 )!
        let thumbnailAsset = record["thumbnail"] as! CKAsset
        thumbnailURL = thumbnailAsset.fileURL
        recordName = record.recordID.recordName
    }
    
    /// 删除所有同一类型的资源文件
    /// - Returns: true： 成功删除，false：遇到错误
    public func deleteAsset() -> Bool{
        //创建AssetGroup的路径
        let groupFolderURL = assetsRootURL.appendingPathComponent(.generateFileName(id: recordName, name: name))
        do{
        
            try FileManager.default.removeItem(at: groupFolderURL)
//            print(try? FileManager.default.contentsOfDirectory(atPath: documentRootURL.path))
//            print(try? FileManager.default.contentsOfDirectory(atPath: groupFolderURL.path))
            return true
        }catch let error{
            print(error)
            return false
        }
    }
    
    /// 将提供的数据存储到规定的文件目录中 document/MAssets/AssetGroupRecordIDWITHNAMEOFAssetGropName/assetRecordNameWITHNAMEOFassetName.AssetCategoryExtension
    /// - Parameters:
    ///   - id: asset 的record id
    ///   - name: asset 的名称
    ///   - asset: 数据
    /// - Returns: 存储的目录，存储失败返回nil并且控制台输出原因
    public func storeAsset(id: String, name: String, asset: CKAsset,overwritable: Bool = true) -> URL?{
        //创建AssetGroup的路径
        let groupFolderURL = assetsRootURL.appendingPathComponent(.generateFileName(id: self.recordName, name: self.name))
        if !FileManager.default.fileExists(atPath: groupFolderURL.path){
            do{
                try FileManager.default.createDirectory(at: groupFolderURL, withIntermediateDirectories: false, attributes: nil)
                print("create assetsgroup root url of \(groupFolderURL) successfully")
            }catch let error{
                print("creating assetsgroup root url of \(groupFolderURL) meets error of \(error)")
            }
        }
        
        //创建Asset路径
        let assetStoredURL = groupFolderURL.appendingPathComponent(.generateFileName(id: id, name: name)).appendingPathExtension(category.fileExtension())
        guard let urlRemoteURL = asset.fileURL else{ print("Asset has no valid filepath"); return nil}
        
        if FileManager.default.fileExists(atPath: assetStoredURL.path),!overwritable{
            print("file is existing and no permission to overwrite")
            return nil
        }
        
        //生成asset中包含的数据
        guard let assetdata = try? Data(contentsOf: urlRemoteURL) else{print("init asset data error"); return nil}
        
        //写入数据
        do{
            try assetdata.write(to: assetStoredURL)
            print("write to \(assetStoredURL) successfully")
            print("实际的文件名为： \(String.generateFileName(id: id, name: name).spiltFileName()[1])")
            return assetStoredURL
        }catch let error{
            print("writing to \(assetStoredURL) meets \(error)")
            return nil
        }
    }
 
}

///用来可视化用户当前的资源类型 本地和云端之间的状态
public enum MAssetGroupStatus: Int,CaseIterable,Codable{
    ///只在云端
    case noStored
    ///云端和本地一致
    case synced
    ///云端和本地不一致（版本号不一致）
    case changed
    ///正在同步
    case syncing
    ///正在下载
    case downloading
    ///无法访问云端或其他错误出现，需要用户手动操作才能调整状态
    case error
}
