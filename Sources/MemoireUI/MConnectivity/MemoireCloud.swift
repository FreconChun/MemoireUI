//
//  MemoireCloud.swift
//  
//
//  Created by 李昊堃 on 2021/11/3.
//

import SwiftUI
import CloudKit


public struct ImageInfo: Codable,Identifiable{
    public let urls: Urls
    public let id = UUID()
}

public struct Urls:Codable{
    let regular: String
    let small: String
    let  thumb: String
    public var smallUrl:URL?{
        return URL(string: small)
    }
    public var regularUrl: URL?{
        return URL(string: regular)
    }
    public var thumbUrl: URL?{
        return URL(string: thumb)
    }
}


///处理和云端共有数据库通信
public class MemoireCloud{
    ///数据源
    public let dataBase = CKContainer(identifier: "iCloud.com.frecon.memoire").publicCloudDatabase
    
    ///单一入口
    public static var shared = MemoireCloud()
    
    
    public func unsplashImageInfos() async throws -> [ImageInfo]{
        let apiPath = "https://api.unsplash.com/photos/?client_id=ceDbW_i73HeeNBpbcqpFb05_r_QINCrCZX3Au591lvY&order_by=popular&page=1&per_page=9"
        let (data,_) = try await  URLSession.shared.data(from: URL(string: apiPath )!, delegate: nil)

            do{
                return try JSONDecoder().decode([ImageInfo].self, from: data)
            }catch let error{
                throw error
            }
    }
    
public    func unsplashImageURLSmall() async throws -> [URL]{
    let apiPath = "https://api.unsplash.com/photos/?client_id=ceDbW_i73HeeNBpbcqpFb05_r_QINCrCZX3Au591lvY&order_by=popular&page=1&per_page=9"
//        var request = URLRequest(url: URL(string: "https://api.unsplash.com/photos/?client_id=ceDbW_i73HeeNBpbcqpFb05_r_QINCrCZX3Au591lvY")!)
//           // request.addValue("ceDbW_i73HeeNBpbcqpFb05_r_QINCrCZX3Au591lvY", forHTTPHeaderField: "client_id")
//            request.addValue("popular", forHTTPHeaderField: "order_by")
//            request.addValue("1", forHTTPHeaderField: "page")
//            request.addValue("10", forHTTPHeaderField: "per_page")
    
    let (data,_) = try await  URLSession.shared.data(from: URL(string: apiPath )!, delegate: nil)
    
    // if let response = urlResponse as? HTTPURLResponse{
        do{
            //try data.write(to: URL(string: screenshotDirectory)!.appendingPathComponent("unsplashData.txt"))
            let picInfo = try JSONDecoder().decode([ImageInfo].self, from: data)
            return picInfo.compactMap{$0.urls.smallUrl}
        }catch let error{
            throw error
        }
        
    }
//    else{
//        return []
//    }
    

//        URLSession.shared.dataTask(with: request) { data, response, error in
//            print("here")
//            print("\(String(describing: error))")
//            print("\(String(describing: data))")
//            print("\(String(describing: response))")
//        }
   //     URLSession.shared.data
    
    
    
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
