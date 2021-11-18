//
//  MAttentionView.swift
//  MTest-MemoireUI
//
//  Created by 李昊堃 on 2021/11/1.
//

import SwiftUI

///一个展示MAttention功能的模版视图
public struct MAttentionView: View {
    public init(){
        
    }
    @EnvironmentObject var attentionCenter: AttentionCenter
    public var body: some View {
        VStack{
            
            Button {
                attentionCenter.addAlert(data: .changePolicyAlertData)
            } label: {
                Text("Alert1").mfont(size: .body, weight: .bold)
            }
            
            Divider()
            Button {
                attentionCenter.addBanner(data: .loadFromCloudBannerData)
            } label: {
                Text("Banner1").mfont(size: .body, weight: .bold)
            }
            Button {
                attentionCenter.addBanner(data: .createCloudPersistence)
            } label: {
                Text("Banner2").mfont(size: .body, weight: .bold)
            }
            Button {
                attentionCenter.addBanner(data: .uploadCloudPersistence)
            } label: {
                Text("Banner3").mfont(size: .body, weight: .bold)
            }
            Button {
                attentionCenter.addBanner(data: .init2DView)
            } label: {
                Text("Banner4").mfont(size: .body, weight: .bold)
            }
            Button {
                attentionCenter.addBanner(data: .init3DView)
            } label: {
                Text("Banner5").mfont(size: .body, weight: .bold)
            }
            
            Divider()

            Button {
                attentionCenter.addDialog(data: .signOutDialog(logoutAction: {}))
            } label: {
                Text("Dialog").mfont(size: .body, weight: .bold)
            }
        }
//        .fullScreenCover(isPresented: .constant(true)) {
//            
//        } content: {
//            Button {
//                attentionCenter.addAlert(data: .changePolicyAlertData)
//            } label: {
//                Text("Alert1").mfont(size: .body, weight: .bold)
//            }
//        }

    }
}

struct MOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        MAttentionView()
    }
}
