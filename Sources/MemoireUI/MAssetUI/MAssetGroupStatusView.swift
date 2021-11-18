//
//  MAssetGroupStatusView.swift
//  MTest-MemoireUI
//
//  Created by 李昊堃 on 2021/11/2.
//

import SwiftUI
import MemoireFoundation

///MAssetGroup的状态，是一个有背景的Image
public struct MAssetGroupStatusView: View{
    @Binding var status: MAssetGroupStatus
    
    public init(status: Binding<MAssetGroupStatus>){
        self._status = status
    }
    public var body: some View{
        VStack{
        switch status {
        case .noStored:
            Image(systemName: "icloud.and.arrow.down").foregroundStyle(Color.mGrey3, Color.mBlue)
                .statusIconStyle(color: .mBlue)
            
        case .synced:
            Image(systemName: "checkmark")
                .foregroundColor(.mGreen4)
                .statusIconStyle(color: .mGreen)
        case .changed:
            Image.arrow2circle
                .foregroundStyle(Color.mOrage, Color.mYellow)
                .statusIconStyle(color: .mYellow)
        case .syncing:
            ProgressView()
                .statusIconStyle(color: .mGrey3)
              
        case .downloading:
            ProgressView()
                .statusIconStyle(color: .mGrey3)
        case .error:
            Image(systemName: "exclamationmark")
                .foregroundStyle(Color.mRed, Color.mOrage)
                .statusIconStyle(color: .mRed)
        }
        }.mfont(size: .caption2, type: .NotoSerifSC, weight: .bold)
           
    }
}

extension View{
    
    /// 用来指示状态的小图标 （尤其MemoireAssetGroup）
    /// - Parameter color: 图标颜色
    public func statusIconStyle(color: Color) -> some View{
        self.frame(width: .iconSmall, height: .iconSmall, alignment: .center)
        .padding(4)
        .background(.thickMaterial)
        .background(color)
        .cornerRadius(100)
        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 0)
    }
}

struct MAssetGroupStatusView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns:[GridItem(),GridItem()]){
            ForEach(MAssetGroupStatus.allCases,id:\.self){status in
                MAssetGroupStatusView(status: .constant(status))
            }
        }
        .preferredColorScheme(.dark)
    
    }
}
