//
//  Array+Extensions.swift
//  
//
//  Created by 李昊堃 on 2021/11/1.
//

import SwiftUI

extension Array where Element : Identifiable{
    ///根据是否具有相同id的元素判断是append还是修改当前值
    mutating func uniqueAppend(element: Element){
        print(element)
        if !contains(where: {$0.id == element.id}){
            print(1)
            append(element)
        }else{
            if let index = firstIndex(where: {$0.id == element.id}){
                print(2)
                self[index] = element
            }
        }
    }
}
