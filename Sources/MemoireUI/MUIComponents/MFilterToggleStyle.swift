//
// MToggle.swift
//  
//
//  Created by 李昊堃 on 2021/11/16.
//

import SwiftUI


extension ToggleStyle where Self == MFilterToggleStyle {

    public static func mFilter(color: Color,weight: MFontWeight = .regular) -> MFilterToggleStyle {
   
            MFilterToggleStyle(color: color,weight: weight)
        
        
    }
}

public struct MFilterToggleStyle: ToggleStyle{
    var color: Color = .mBlue
    var weight: MFontWeight = .regular
    public func makeBody(configuration: Configuration) -> some View {
        HStack{
            ZStack{
            RoundedRectangle(cornerRadius: 7).stroke(lineWidth: 2).frame(width: 25, height: 25, alignment: .center)
                    .foregroundColor(configuration.isOn ? color : .mGrey3.opacity(0.5))
                if configuration.isOn{
                    RoundedRectangle(cornerRadius: 7).frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(color)
                    Image(systemName: "checkmark")
                        .mfont(size: .bannerTitle,weight: .bold)
                        .foregroundStyle(.white)
                        
                }
            }
            configuration.label.mfont(size: .bannerTitle,weight: weight)
                .foregroundColor(configuration.isOn ? .primary : .mGrey3)
            Spacer()
         
        }.onTapGesture {
            withAnimation(){
                configuration.isOn.toggle()
            }
        }
    }
}


struct MToggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
        Toggle("Memoire资源库", isOn: .constant(true))
        Toggle("Memoire资源库", isOn: .constant(false))
        }.toggleStyle(.mFilter(color: .mBlue))
    }
}
