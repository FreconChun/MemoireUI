//
// deprecated.swift
//  
//
//  Created by 李昊堃 on 2021/11/18.
//

import SwiftUI

//MARK: - URL整体迁移到MURL

///文件根目录 /document
@available(*,deprecated,message: "use MURL instead")
public let documentRootURL: URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)

///MAsset根目录 /document/MAssets
@available(*,deprecated,message: "use MURL instead")
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
@available(*,deprecated,message: "use MURL instead")
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
@available(*,deprecated,message: "use MURL instead")
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

///MUser根目录 /document/MUser/Assets
@available(*,deprecated,message: "use MURL instead")
public var muserAssetsRootURL: URL{
    let userAssetsURL = mUserRootURL.appendingPathComponent("Assets")
    if !FileManager.default.fileExists(atPath: userAssetsURL.path){
        do{
            try FileManager.default.createDirectory(at: userAssetsURL, withIntermediateDirectories: false, attributes: nil)
            print("create assets root url successfully")
        }catch let error{
            print("creating assets root url meets error of \(error)")
        }
    }
    return userAssetsURL
}
