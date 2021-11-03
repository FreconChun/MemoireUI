//
//  MemoireCloud.swift
//  
//
//  Created by 李昊堃 on 2021/11/3.
//

import SwiftUI
import CloudKit

///处理和云端共有数据库通信
public class MemoireCloud{
    ///数据源
    let dataBase = CKContainer(identifier: "iCloud.com.frecon.memoire").publicCloudDatabase
    
    ///单一入口
    static var shared = MemoireCloud()
    
    func loadAssets(of group: MAssetGroup) async throws -> [(id:String,name:String,data:CKAsset)]{
        
        //根据组的信息创建CKReference
        let assetGroupReference = CKRecord.Reference(recordID: CKRecord.ID.init(recordName: group.recordName), action: .deleteSelf)
        
        let predicate = NSPredicate(format: "assetType == %@", assetGroupReference)
        let query = CKQuery(recordType: "Asset", predicate: predicate)
        
        //提升服务速度
        let configuration = CKOperation.Configuration()
        configuration.qualityOfService = .userInitiated
        
        
        do{
            return try await dataBase.configuredWith(configuration: configuration, group: nil) { configuredDatabase in
            return try await configuredDatabase.records(matching: query,inZoneWith: .default).compactMap{ record in
                guard let name = record["name"] as? String else{ return nil}
                guard let data = record["data"] as? CKAsset else{ return nil}
                let id = record.recordID.recordName
                return (id:id,name: name, data: data)
            }
        }
        }catch let error{
            print(error)
            return []
        }
        
//        return try await dataBase.records(matching: query,inZoneWith: .default).compactMap{ record in
//            guard let name = record["name"] as? String else{ return nil}
//            guard let data = record["data"] as? CKAsset else{ return nil}
//            let id = record.recordID.recordName
//            return (id:id,name: name, data: data)
//        }
    }
    

    func loadAssetsType()async throws -> [MAssetGroup]{
        //predicate is all
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "AssetType", predicate: predicate)
        return try await dataBase.records(matching: query, inZoneWith: .default).map{ record in
            MAssetGroup(from: record)
        }.sorted(by: {$0.id < $1.id})
        //        CKQueryOperation
        //MARK: - 之后接入一下阴间API
        //        let (matchResults,cursor) = try await dataBase.records(matching: query)
        //        matchResults.compactMap{ (data, result) in
        //            switch result{
        //            case .success(fetchedData):
        //                return MAssetType(from: fetchedData as CKR)
        //            case .failure(error):
        //                return nil
        //            }
        //
        //        }
    }
}
