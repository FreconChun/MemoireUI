//
//  MImage.swift
//  
//
//  Created by 李昊堃 on 2021/11/2.
//

import SwiftUI
import CloudKit

///文件根目录 /document
public let documentRootURL: URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)

///MAsset根目录 /document/MAssets
public var assetsRootURL: URL{
    let assetsURL = documentRootURL.appendingPathComponent("MAssets")
    if !FileManager.default.fileExists(atPath: assetsURL.path){
        do{
            try FileManager.default.createDirectory(at: assetsURL, withIntermediateDirectories: false, attributes: nil)
            print("create assets root url successfully")
        }catch let error{
            print("creating assets root url meets error of \(error)")
        }
    }
    return assetsURL
}

///MUser根目录 /document/MUser
public var mUserRootURL: URL{
    let userURL = documentRootURL.appendingPathComponent("MUser")
    if !FileManager.default.fileExists(atPath: userURL.path){
        do{
            try FileManager.default.createDirectory(at: userURL, withIntermediateDirectories: false, attributes: nil)
            print("create assets root url successfully")
        }catch let error{
            print("creating assets root url meets error of \(error)")
        }
    }
    return userURL
}

///MUser根目录 /document/MUser/Icons
public var muserIconsRootURL: URL{
    let userIconsURL = mUserRootURL.appendingPathComponent("Icons")
    if !FileManager.default.fileExists(atPath: userIconsURL.path){
        do{
            try FileManager.default.createDirectory(at: userIconsURL, withIntermediateDirectories: false, attributes: nil)
            print("create assets root url successfully")
        }catch let error{
            print("creating assets root url meets error of \(error)")
        }
    }
    return userIconsURL
}


public class MLocalFileCenter{
    
    enum MFileError: Error{
        case noData
    }
    
    ///返回Masset目录下的资源总大小
       public static func totalStorage() -> Text {
           do{
               let storage = try muserIconsRootURL.directoryTotalAllocatedSize(includingAllSubfolders: true)
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
    
    ///将uiimage保存到  /document/MUser/Icons/currentdate.png中
    public  static func saveIcon(of image:UIImage) throws {
        let imageURL = muserIconsRootURL.appendingPathComponent(Date().toFileNameString()).appendingPathExtension("png")
        guard let data = image.pngData() else{
            throw MFileError.noData
        }
        try data.write(to: imageURL)
        print("icon save to \(imageURL)")
    }
    
    ///删除icon目录 
    public static func removeIconHistory() {
        muserIconsRootURL.allSubDirectories().forEach { url in
           try? FileManager.default.removeItem(at: url)
        }
    }
    
    public static func allIconHistoryURLs() -> [(createTime:Date,data:URL)]{
        
        return muserIconsRootURL.allSubDirectories()
            .filter {$0.pathExtension == "png"}
            .compactMap {
                let date = $0.lastPathComponent.fileNameToDate() ?? Date()
                guard let data = try? Data(contentsOf: $0) else{return nil}

                return (createTime:date,data:$0)
            }.sorted{$0.createTime < $1.createTime}
            
        
    }
    
    
    public static func allIconHistory() -> [(createTime:Date,data:UIImage)]{
        
        return muserIconsRootURL.allSubDirectories()
            .filter {$0.pathExtension == "png"}
            .compactMap {
                let date = $0.lastPathComponent.fileNameToDate() ?? Date()
                guard let data = try? Data(contentsOf: $0) else{return nil}
                guard let image = UIImage(data: data) else {return nil}
                return (createTime:date,data:image)
            }.sorted{$0.createTime < $1.createTime}
            
        
    }
}
