//
//  MHaptic.swift
//  
//
//  Created by 李昊堃 on 2021/11/3.
//

import SwiftUI

///震动组件。直接调函数即可
public final class MHaptic{
    
    static let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    public static func alert(){
        impactMed.impactOccurred(intensity: 1)
    }
    
    public static func confirmTap(){
        impactMed.impactOccurred(intensity: 0.5)
    }
    
    public static func lightNotice(){
        impactMed.impactOccurred(intensity: 0.5)
    }
}


