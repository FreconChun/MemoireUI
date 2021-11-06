//
//  Overlayable.swift
//  
//
//  Created by 李昊堃 on 2021/10/31.
//

import SwiftUI


/// 对于不会中断用户当前操作的提示，在根视图上使用的Modifier，使得提示显示在根视图之上
public struct AttentionalModifier: ViewModifier{
    @StateObject var attentionCenter = AttentionCenter()
    
    //    @State var autoDismissBannerData: [BannerViewData] = []
    //    @State var manuDismissBannerData: [BannerViewData] = []
    //
    ///控制是否将背景进行虚化和相应功能
    var isFullScreenCover: Bool{
        !attentionCenter.alertData.isEmpty || !attentionCenter.dialogData.isEmpty || !attentionCenter.coverViews.isEmpty
    }
    
    var isFullScreenAlert: Bool{
        !attentionCenter.alertData.isEmpty || !attentionCenter.dialogData.isEmpty
    }
    
    public func body(content: Content) -> some View {
        ZStack{
            content
            
                .blur(radius: isFullScreenCover ? 20 : 0)
                .disabled(isFullScreenCover)
      
         
         
            ForEach(   Array(zip(attentionCenter.coverViews.indices, attentionCenter.coverViews)), id: \.0){index,view in
                if isFullScreenCover{
                  Background().opacity(0.5).ignoresSafeArea().transition(.opacity.animation(.spring()))
                  
                }
                view.view()
                    .zIndex(Double(index))
                    .blur(radius: (index < attentionCenter.coverViews.count - 1) ? 20 : 0)
                    
            }
            if isFullScreenAlert{
            Rectangle().foregroundStyle(.thinMaterial).ignoresSafeArea().transition(.opacity.animation(.spring()))
                   // .zIndex(9)
            }
            ForEach(attentionCenter.alertData){alert in
                VStack{
                    Spacer()
                AlertView(data:alert)
                    Spacer()
                }
             
                   // .background(BackgroundClearView())
            }.zIndex(1000)
     
                .transition(.asymmetric(insertion: .scale(scale: 1.5).combined(with: .opacity).animation(.spring()), removal: .opacity.animation(.spring().speed(2))))
          
            
            
            
            ForEach(attentionCenter.dialogData){dialog in
                DialogView(data:dialog)
            }.zIndex(1000)
                .transition(.asymmetric(insertion: .scale(scale: 1.5).combined(with: .opacity).animation(.spring()), removal: .move(edge: .bottom).animation(.spring().speed(2))))
            
            //                .fullScreenCover(item: Binding(get: {
            //                    alertData
            //                }, set: {_ in}), onDismiss: {}) { alert in
            //
            //
            //                }
            VStack{
                HStack(spacing:5){
                    ForEach(attentionCenter.bannerData.filter({$0.autoDismiss})){banner in
                        
                        BannerView(data:banner, bannerStyle: .constant(.medium))
                        
                        
                    }    .transition(.move(edge: .top).animation(.spring().speed(0.5)).combined(with: .opacity.animation(.spring().speed(0.5)).combined(with: .scale(scale: 0.5).animation(.spring()))))
                }
                
                HStack(spacing:5){
                    Spacer(minLength: 0)
                    ForEach(attentionCenter.bannerData.filter({!$0.autoDismiss})) {banner in
                        BannerView( data: banner, bannerStyle: Binding(get: {
                            attentionCenter.largeBannerData?.id == banner.id ? .large : .small
                        }, set: {_ in}))
                            
                            .onTapGesture {
                                withAnimation(){

                                    attentionCenter.changeLargeBanner(data: banner)
                                }
                            }
                    }  .transition(.move(edge: .top).animation(.spring().speed(0.5)).combined(with: .opacity.animation(.spring().speed(0.5))).combined(with: .scale(scale: 0.5).animation(.spring())))
                }
                
                Spacer()
            }
            .padding(5)
            .zIndex(1000)
            
        }
        //        .onChange(of: attentionCenter.bannerData) { newValue in
        //            autoDismissBannerData = newValue.filter({$0.autoDismiss})
        //            manuDismissBannerData = newValue.filter({!$0.autoDismiss})
        //        }
        .environmentObject(attentionCenter)
        
    }
}


extension View{
    public func attentional () -> some View{
        self.modifier(AttentionalModifier())
    }
}

public struct MView: Identifiable,Equatable{
   public init(id: UUID, view: @escaping () -> AnyView) {
        self.id = id
        self.view = view
    }
    
    public static func == (lhs: MView, rhs: MView) -> Bool {
        lhs.id == rhs.id
    }

    public var id: UUID
    var view: () -> AnyView
}

///视图的全局对象，向其中添加值即可显示对应Attention，移除值会使对应attention消失
///除了Banner都不需要代码控制消失
public class AttentionCenter: ObservableObject{
    public init(){
        alertData = []
    }
    @Published public var alertData: [AlertViewData] = []
    @Published public var bannerData: [BannerViewData] = []
    @Published public var dialogData: [DialogData] = []
    @Published public var largeBannerData: BannerViewData? = nil
    @Published public var coverViews: [MView] = []
    public func addAlert(data: AlertViewData) {
        alertData.append(data)
    }
    public func removeAlert(data: AlertViewData){
        
        alertData.removeAll(where: {$0.id == data.id})
        
    }
    
    public func addBanner(data: BannerViewData) {
        withAnimation(.spring().speed(0.8)){
            //当添加项不能自动消失，该项默认是大尺寸
            if !data.autoDismiss{
                largeBannerData = data
            }
            bannerData.uniqueAppend(element: data)
        }
        
    }
    
    private func addOverlay<T: View>(_ content: @escaping () -> T){
        coverViews.append(MView(id: UUID(), view: {content().eraseToAnyView()}))
    }
    
    ///注意：调用此函数需要自行控制MView的ID，用ID来关闭视图
    public func addOverlay(_ content: MView){
        withAnimation(){
        coverViews.append(content)
        }
    }
    public func removeOverlay(id: UUID){
        withAnimation(){
        coverViews.removeAll(where: {$0.id
             == id
        })
        }
    }
    
    public func removeBanner(data: BannerViewData){
        withAnimation(.spring().speed(0.6)){
            bannerData.removeAll(where: {$0.id == data.id})
        }
    }
    public  func addAlert(title: LocalizedStringKey, content: Text? = nil, controls: [Action] = []){
        alertData.uniqueAppend(element: AlertViewData(title: title, content: content, controls: controls))
    }
    
    public func removeAlert(id: UUID){
        alertData.removeAll(where: {$0.id == id})
    }
    
//    public func removeOverlay(id: UUID){
//        dialogData.removeAll{$0.id == id}
//    }
    public func addDialog(data: DialogData){
        dialogData.uniqueAppend(element: data)
    }
    
    public func removeDialog(data: DialogData){
        withAnimation(){
        dialogData.removeAll(where: {$0.id == data.id})
        }
    }
    
    public func changeLargeBanner(data: BannerViewData){
        withAnimation(.spring().speed(0.8)){
            if data.id == largeBannerData?.id{
                largeBannerData = nil
            }else{
                largeBannerData = data
            }
        }
    }
}
