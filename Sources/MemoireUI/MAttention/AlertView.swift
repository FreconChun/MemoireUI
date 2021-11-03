//
//  AlertView.swift
//  MTest-MemoireUI
//
//  Created by 李昊堃 on 2021/10/31.
//

import SwiftUI


struct AlertView: View {
    @EnvironmentObject var attentionCenter: AttentionCenter
    @Environment(\.colorScheme) var colorScheme
    
    var data = AlertViewData(id: UUID(), title: LocalizedStringKey("隐私政策更新"), content: Text("我们的隐私政策发生变化，请您及时关注!"), controls: [
        Action(title: Text("前往查看"), action: { })])
    
    var body: some View {
        VStack(alignment:.leading,spacing:10){
            Text(data.title)
            
                .kerning(2)
                .mfont(size: .headline, weight: .bold)
                Divider()
            data.content?
                .kerning(1)
                .foregroundStyle(.secondary)
                .mfont(size: .caption2, weight:.regular)
     
       
        }
        .padding(.bottom,data.controls.isEmpty ? 20 : 0)
        .padding([.horizontal,.top
                 ],20)
            .safeAreaInset(edge: .bottom){
                HStack{
                    Spacer(minLength: 0)
                ForEach(data.controls,id:\.id){control in
                    Button {
                        control.action()
                        attentionCenter.removeAlert(data: data)
                    } label: {
                        HStack{
                            Spacer()
                        control.title
                            .foregroundColor(control.tintColor)
                            Spacer()
                        }.contentShape(Rectangle())
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.regular)
                    .padding(10)
                    .onAppear {
                        print(control)
                    }
                    
                    Spacer(minLength: 0)
                    
                }
                }
//                .foregroundColor(.accent.changeMore(colorScheme: colorScheme,amount:0.3))
                .mfont(size: .caption2,weight:.semiBold)
                .background(.quaternary,in:Rectangle())
            }
           
     
            .background(.regularMaterial,in :Rectangle())
            .cornerRadius(10)
            
          
            .shadow(color:.gray.opacity(0.25),radius: 10)
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .foregroundStyle(.background)
                    .opacity(0.8)
                    
            }
            .overlay(alignment:.topTrailing){
                Button {
                    withAnimation(){
                    attentionCenter.removeAlert(data: data)
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.bold())
                        .foregroundColor(.gray.opacity(0.5))
                        //.resizable()
                        .imageScale(.large)
                        
                       // .font(.subheadline)
                        .padding(10)
                       
                      //  .background(.thinMaterial,in:Circle())
                      
                }
                
                .padding(5)
                

            }    .padding(20)
            .onAppear {
                MHaptic.alert()
            }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView().previewLayout(.sizeThatFits)
        
            .background(LinearGradient(colors: [.gray,.blue], startPoint: .topLeading, endPoint: .topTrailing))
            .environmentObject(AttentionCenter())
            .frame(width:440)
            .screenshotStye()
            .screenshot(name: "AlertView")
    }
}


