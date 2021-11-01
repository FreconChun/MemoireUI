
//  AverageColor.swift
//  Flags
//
//  Created by 李昊堃 on 2021/10/13.
//

import SwiftUI



// MARK: - 获取图片的平均颜色

#if os(iOS)
/// 获得图片的平均颜色
public  func imageAverageColor(of data: UIImage) -> Color?{
    if let ciImage = CIImage(image: data){
        return averageColor(of: ciImage)
    }else{
        return nil
    }
   
}
#endif

#if os(macOS)
/// 获得图片的平均颜色
public  func imageAverageColor(of data: NSImage) -> Color?{
    averageColor(of: data.ciImage())
}
#endif

/// 获得图片的平均颜色
/// - Parameter data: ci
/// - Returns:处理后的平均颜色
public  func averageColor(of data: CIImage?) -> Color?{
    guard let inputImage = data else { return nil }

    // Create an extent vector (a frame with width and height of our current input image)
    let extentVector = CIVector(x: inputImage.extent.origin.x,
                                y: inputImage.extent.origin.y,
                                z: inputImage.extent.size.width,
                                w: inputImage.extent.size.height)

    // create a CIAreaAverage filter, this will allow us to pull the average color from the image later on
    guard let filter = CIFilter(name: "CIAreaAverage",
                              parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
    guard let outputImage = filter.outputImage else { return nil }

    // A bitmap consisting of (r, g, b, a) value
    var bitmap = [UInt8](repeating: 0, count: 4)
    let context = CIContext(options: [.workingColorSpace: kCFNull!])

    // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
    context.render(outputImage,
                   toBitmap: &bitmap,
                   rowBytes: 4,
                   bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                   format: .RGBA8,
                   colorSpace: nil)

    // Convert our bitmap images of r, g, b, a to a UIColor

    return Color(red: CGFloat(bitmap[0]) / 255,
                   green: CGFloat(bitmap[1]) / 255,
                   blue: CGFloat(bitmap[2]) / 255,
                   opacity: CGFloat(bitmap[3]) / 255)
    //return Color.primary

}


// MARK: - 颜色设计规范
extension Color{
   
    
    
    #if os(iOS)
    
    /// 将颜色变亮
    /// - Parameter amount: [0,1]，反映和白色混合的比例，数越大越亮
    /// - Returns: 变亮后的颜色
    public func lighter(by amount: CGFloat = 0.2) -> Self { Self(UIColor(self).lighter(by: amount)) }
    
    /// 将颜色变暗
    /// - Parameter amount:  [0,1]，反映和黑色混合的比例，数越大越暗
    /// - Returns: 变暗后的颜色
    public func darker(by amount: CGFloat = 0.2) -> Self { Self(UIColor(self).darker(by: amount)) }
    #endif
    
    #if os(macOS)
    /// 将颜色变亮
    /// - Parameter amount:  [0,1]，反映和白色混合的比例，数越大越亮
    /// - Returns: 变亮后的颜色
    public func lighter(by amount: CGFloat = 0.2) -> Self { Self(NSColor(self).lighter(by: amount)) }
    
    /// 将颜色变暗
    /// - Parameter amount:  [0,1]，反映和黑色混合的比例，数越大越暗
    /// - Returns: 变暗后的颜色
    public func darker(by amount: CGFloat = 0.2) -> Self { Self(NSColor(self).darker(by: amount)) }
    #endif
    
    public func value() -> CGFloat{
        #if os(iOS)
        return UIColor(self).value()
        #else
        return NSColor(self).value()
        #endif
    }
    /// 根据当前的颜色主题动态变化颜色，白天模式变量，黑色模式变暗
    /// - Parameter colorScheme: 当前的颜色主题
    /// - Parameter amount:[0,1]，反映变化的程度，数字越大变化越明显
    /// - Returns: 变化后的颜色
    public func changeMore(colorScheme: ColorScheme,amount: CGFloat = 0.2) -> Self{
        
        if colorScheme == .light{
            return self.darker(by: amount)
        }else{
           return self.lighter(by: amount)
        }
    }
    
    public func autoChangeMore(colorScheme: ColorScheme) -> Self{
        let value = self.value()
        if colorScheme == .light{
            if value < 0.3{
                return self.darker(by: 0.2)
            }else if value < 0.5{
                return self.darker(by: 0.5)
            }else{
                return self.darker(by: 0.6)
            }
        }else{
            if value < 0.2{
                return self.lighter(by: 0.8)
            }else if value < 0.5{
                return self.lighter(by: 0.6)
            }else{
                return self.lighter(by: 0.2)
            }
        }
    }
}




#if os(macOS)
extension NSColor {
    func mix(with color: NSColor, amount: CGFloat) -> Self {
        var red1: CGFloat = 0
        var green1: CGFloat = 0
        var blue1: CGFloat = 0
        var alpha1: CGFloat = 0

        var red2: CGFloat = 0
        var green2: CGFloat = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat = 0

        getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

        return Self(
            red: red1 * CGFloat(1.0 - amount) + red2 * amount,
            green: green1 * CGFloat(1.0 - amount) + green2 * amount,
            blue: blue1 * CGFloat(1.0 - amount) + blue2 * amount,
            alpha: alpha1
        )
    }
    
    func value() -> CGFloat{
        var red1: CGFloat = 0
        var green1: CGFloat = 0
        var blue1: CGFloat = 0
        var alpha1: CGFloat = 0
        //获取uicolor中的rgba值
        getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        return max(red1, green1,blue1)
    }

    func lighter(by amount: CGFloat = 0.2) -> Self { mix(with: .white, amount: amount) }
    func darker(by amount: CGFloat = 0.2) -> Self { mix(with: .black, amount: amount) }
}
#endif

#if os(iOS)
extension UIColor {
    func mix(with color: UIColor, amount: CGFloat) -> Self {
        var red1: CGFloat = 0
        var green1: CGFloat = 0
        var blue1: CGFloat = 0
        var alpha1: CGFloat = 0

        var red2: CGFloat = 0
        var green2: CGFloat = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat = 0
        
        //获取uicolor中的rgba值
        getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        //获取with颜色的rgba值
        color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

        return Self(
            red: red1 * CGFloat(1.0 - amount) + red2 * amount,
            green: green1 * CGFloat(1.0 - amount) + green2 * amount,
            blue: blue1 * CGFloat(1.0 - amount) + blue2 * amount,
            alpha: alpha1
        )
    }
    
    func value() -> CGFloat{
        var red1: CGFloat = 0
        var green1: CGFloat = 0
        var blue1: CGFloat = 0
        var alpha1: CGFloat = 0
        //获取uicolor中的rgba值
        getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        return max(red1, green1,blue1)
    }
    
    func lighter(by amount: CGFloat = 0.2) -> Self { mix(with: .white, amount: amount) }
    func darker(by amount: CGFloat = 0.2) -> Self { mix(with: .black, amount: amount) }
}
#endif
