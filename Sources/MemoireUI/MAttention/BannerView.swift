//
//  BannerView.swift
//  MTest-MemoireUI
//
//  Created by 李昊堃 on 2021/10/31.
//

import SwiftUI


enum BannerStyle: Int,CaseIterable{
    case large,medium,small
}

struct BannerView: View {
    @EnvironmentObject var attentionCenter: AttentionCenter
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeRemaining = 5
    var data:BannerViewData = .loadFromCloudBannerData
    @Binding var bannerStyle: BannerStyle

    var body: some View {
        HStack{
            data.icon
                .symbolRenderingMode(.multicolor)
            
                .font(.title.bold())
            
                .frame(width: 30, height: 30, alignment: .center)
            if bannerStyle != .small{
                HStack(){
                    
                    Text(data.title)
                        .mfont(size: .bannerTitle,weight: .bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    if let subTitle = data.subTitle,bannerStyle == .large{
                        Spacer()
                        Text(subTitle)
                            .mfont(size: .bannerBody)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal,5)
                if bannerStyle == .large{
                    Spacer(minLength: 0)
                }
            }
            
            //            Image(systemName: "xmark")
            //                .font(.body.bold())
            //                .foregroundColor(.gray)
            
        }
        
        
        .padding()
        
        .background(.bar,in:Capsule())
        .clipShape(Capsule())
      
        .scaleEffect(bannerStyle == .small ? 0.8 : 1)
        .padding(.horizontal,bannerStyle == .small ? -5 : 0)
        .animation(.spring(), value: bannerStyle)
        .onReceive(timer) { _ in
            if data.autoDismiss{
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }else{
            
                    attentionCenter.removeBanner(data: data)
                    
                }
            }
        }
        
        // .cornerRadius(20)
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            
            BannerView(bannerStyle:.constant(.large))
                .padding(.vertical)
                .previewLabel(name: "大尺寸：")
            BannerView(bannerStyle:.constant(.medium))
                .padding(.vertical)
                .previewLabel(name: "中尺寸：")
            BannerView(bannerStyle:.constant(.small))
                .padding(.vertical)
                .previewLabel(name: "小尺寸：")
        }
        
        .previewLayout(.sizeThatFits)
        .padding(5)
        .background(
            LinearGradient(colors: [.blue,.gray], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .screenshotStye()
        .screenshot(name: "BannerView")
        
        
        
    }
}


