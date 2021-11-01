//
//  File.swift
//  
//
//  Created by 李昊堃 on 2021/10/31.
//

import SwiftUI

/// 字体类型名称
public enum MFont: String,CaseIterable{
    case NotoSerifSC = "NotoSerifSC"
    
    func name(weight: MFontWeight = .regular) -> String{
        self.rawValue + "-" + weight.rawValue
    }
}

///字重类型
public enum MFontWeight: String,CaseIterable{
    case bold = "Bold"
    case semiBold = "SemiBold"
    case regular = "Regular"
}

///字体尺寸
public enum MFontSize: CGFloat{
    /// The font style for large titles.
    case largeTitle = 44

    /// The font used for first level hierarchical headings.
    case title = 38

    /// The font used for second level hierarchical headings.
    case title2 = 34

    /// The font used for third level hierarchical headings.
    case title3 = 31

    /// The font used for headings.
    case headline = 28

    /// The font used for subheadings.
    case subheadline = 24

    /// The font used for body text.
    case body = 27

    /// The font used for callouts.
    case callout = 26

    /// The font used in footnotes.
    case footnote = 23

    /// The font used for standard captions.
    case caption = 22

    /// The font used for alternate captions.
    case caption2 = 20
    
    /// 18
    case bannerTitle = 18
    
    /// 14
    case bannerBody = 14
    
    ///对应尺寸的关联自重，headline尺寸默认为semibold
    func relativeWeight() -> MFontWeight{
        switch self {
        case .headline:
            return .semiBold
        default:
            return .regular
        }
    }
    
    ///对应尺寸的关联系统字体，用来动态调节字体大小
    func relativeSize() -> Font.TextStyle{
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .subheadline:
            return .subheadline
        case .body:
            return .body
        case .callout:
            return .callout
        case .footnote:
            return .footnote
        case .caption:
            return .caption
        case .caption2,.bannerBody,.bannerTitle:
            return .caption2
        }
    }
    
}

extension View{
    /// 设置字体为自定义字体
    public func mfont(size fontSize: MFontSize,type fontType: MFont = .NotoSerifSC, weight fontWeight: MFontWeight? = nil) -> some View{
        self.font(MFontController.shared.font(fontSize, fontType, fontWeight))
    }
}

extension Text{
    /// 设置字体为自定义字体
    public func mfont(size fontSize: MFontSize,type fontType: MFont = .NotoSerifSC, weight fontWeight: MFontWeight? = nil) -> Text{
        self.font(MFontController.shared.font(fontSize, fontType, fontWeight))
    }
}

///字体控制器，保证使用第三方字体时已经完成注册，务必使用MFontController.shared来访问实例
public class MFontController{
    ///统一入口，避免重复初始化
    static var shared = MFontController()
    
    init(){
        let fontBundle = Bundle.module
        //将资源文件夹中的字体注册到UIFont中
        MFont.allCases.forEach { fontType in
            MFontWeight.allCases.forEach { fontWeight in
                _ = UIFont.registerFont(bundle: fontBundle, fontName: fontType.name(weight:fontWeight), fontExtension: "otf")
            }
        }
    }
    
    ///根据参数提供SwiftUI字体
    func font(_ fontSize: MFontSize,_ fontType: MFont = .NotoSerifSC, _ fontWeight: MFontWeight? = nil) -> Font{
        //未提供初始值，根据关联字重初始化
        let weight = fontWeight ?? fontSize.relativeWeight()
        
        return  .custom(fontType.name(weight: weight), size: fontSize.rawValue, relativeTo: fontSize.relativeSize())
    }
}

// This extension is taken from this SO answer https://stackoverflow.com/a/36871032/5508175
extension UIFont {
    
    ///将MFont/Resources文件夹中的字体注册到CTFontManager
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName)")
        }
        
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(fontName)")
        }
        
        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            print("Error registering font: maybe it was already registered.")
            return false
        }
        print("success to register \(fontName)")
        return true
    }
}
