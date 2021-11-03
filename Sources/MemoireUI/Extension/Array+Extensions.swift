//
//  Array+Extensions.swift
//  
//
//  Created by 李昊堃 on 2021/11/1.
//

import SwiftUI

extension Array where Element : Identifiable{
    /// 根据是否具有相同id的元素判断是append还是修改当前值
    /// - Parameter element: 添加的元素
    /// - Returns: append成功为true 覆盖为false
   @discardableResult mutating func uniqueAppend(element: Element) -> Bool{
        print(element)
        if !contains(where: {$0.id == element.id}){
            append(element)
            return true
        }else{
            if let index = firstIndex(where: {$0.id == element.id}){
                self[index] = element
                return false
            }
            return false
        }
    }
}
