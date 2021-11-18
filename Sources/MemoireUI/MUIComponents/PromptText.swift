//
//  PromptText.swift
//  
//
//  Created by 李昊堃 on 2021/11/6.
//

import SwiftUI

///如果Text为空，输出Prompt
public func PromptText(prompt: Text?,_ content: String) -> Text{
        if content.isEmpty,let prompt = prompt{
           return prompt
        
        }else{
            return Text(content)
        }
}
