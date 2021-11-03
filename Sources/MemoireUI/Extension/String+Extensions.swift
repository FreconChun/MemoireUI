//
//  String+Extensions.swift
//  
//
//  Created by 李昊堃 on 2021/11/3.
//

import SwiftUI

extension String{
    ///输出idWITHNAMEOFname
    public static func generateFileName(id: String,name: String) -> Self{
        return id + "WITHNAMEOF" + name
    }
    
    ///将generateFileName的字符串解开
    public func spiltFileName() -> [String]{
        self.components(separatedBy: "WITHNAMEOF")
    }
}
