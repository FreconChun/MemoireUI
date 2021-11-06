//
//  Background.swift
//  Memoire
//
//  Created by 李昊堃 on 2021/9/29.
//

import SwiftUI


public struct Background: View {
    public init(){
        
    }
    public var body: some View {
        LinearGradient(colors: [.mYellow2,.mYellow2], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}
