//
//  MImage.swift
//  
//
//  Created by 李昊堃 on 2021/11/2.
//

import SwiftUI
import CloudKit

///文件根目录 /document
let documentRootURL: URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)

///MAsset根目录 /document/MAssets
var assetsRootURL: URL{
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


