//
//  DialogView.swift
//  MTest-MemoireUI
//
//  Created by 李昊堃 on 2021/11/1.
//

import SwiftUI





struct DialogView: View {
    @Namespace var dialogNamespace
    var data = DialogData.singOutDialog
    @EnvironmentObject var attentionCenter: AttentionCenter
    @State var remainingTime: CGFloat = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var showControl = false
    var body: some View {
        VStack{
        Spacer()
            data.content
                .padding()
                .foregroundStyle(.secondary)
                .background(.regularMaterial,in: RoundedRectangle(cornerRadius: 20))
              
            
            VStack{
                if showControl{
            ForEach(data.controls){control in
                Button {
                    
                } label: {
                    control.title.frame(maxWidth:300)
                        .mfont(size: .caption2, type: .NotoSerifSC, weight: .semiBold)
                }
                .controlSize(.large)
                .buttonStyle(of: control.type)
                .transition(.move(edge: .bottom).animation(.spring()).combined(with: .opacity.animation(.spring())))
                .matchedGeometryEffect(id: control.id, in: dialogNamespace)
            }
                    
                }else{
                    Button {
                        
                    } label: {
                        Text("Confirm after \(Int(remainingTime))s")
                            .frame(maxWidth:300)
                            .mfont(size: .caption2, type: .NotoSerifSC, weight: .semiBold)
                    }
                    .controlSize(.large)
                    .buttonStyle(of: nil)
                    .disabled(true)
                    .transition(.move(edge: .bottom).animation(.spring()))
                    .matchedGeometryEffect(id: data.controls.first?.id, in: dialogNamespace)
                }
                let control =  Action(title: Text("Cancel"), action: {
                    attentionCenter.removeDialog(data: data)
                })
                Button {
                    control.action()
                } label: {
                    control.title.frame(maxWidth:300)
                        .mfont(size: .caption2, type: .NotoSerifSC, weight: .semiBold)
                }
                .controlSize(.large)
                .buttonStyle(of: control.type)
                .transition(.move(edge: .bottom).animation(.spring()))
               
            }
          
            
            

        
        }.padding()
            .onReceive(timer) { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                }else{
                withAnimation(){
                showControl = true
                }
                }
            }
            
    }
}

struct DialogView_Previews: PreviewProvider {
    static var previews: some View {
       
        DialogView()
                .background(
                    LinearGradient(colors: [.blue,.gray], startPoint: .topLeading, endPoint: .bottomTrailing)
                   // Image("1").resizable().aspectRatio(contentMode: .fill).clipped()
                        .brightness(0.2)
                        .grayscale(0.6)
                                    .blur(radius: 10,opaque: true)
                                  
                                   // .overlay(Color.white.opacity(0.6))
                                  
                                    .ignoresSafeArea())
        
                .screenshotStye()
                .frame(width: 400, height: 648, alignment: .center)
                .screenshot(name: "DialogView")
             
  
    }
}
