//
//  File.swift
//  
//
//  Created by 李昊堃 on 2021/10/31.
//

import Foundation
#if DEBUG
import SwiftUI

private let screenshotDirectory = "/Users/lihaokun/Desktop"

struct PreviewScreenshot: ViewModifier {
    struct LocatorView: UIViewRepresentable {
        let tag: Int

        func makeUIView(context: Context) -> UIView {
            return UIView()
        }

        func updateUIView(_ uiView: UIView, context: Context) {
            uiView.tag = tag
        }
    }

    @Environment(\.colorScheme) var colorScheme

    private let tag = Int.random(in: 0..<Int.max)
    let screenshotName: String

    private var screenshotPath: String {
        let colorSchemeName = colorScheme == .dark ? "dark" : "light"
        let deviceName = UIDevice.current.name

        let actualName = "\(screenshotName)-\(colorSchemeName).png"

        return "\(screenshotDirectory)/\(deviceName)/\(actualName)"
    }

    private func createDirectory() {
        let deviceName = UIDevice.current.name
        let screenshotDir = "\(screenshotDirectory)/\(deviceName)/"

        var isDir: ObjCBool = false

        if !FileManager.default.fileExists(atPath: screenshotDir, isDirectory: &isDir) {
            try! FileManager.default.createDirectory(
                atPath: screenshotDir,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } else if !isDir.boolValue {
            fatalError()
        }
    }

    func body(content: Content) -> some View {
       VStack(spacing: 0) {
//            LocatorView(tag: tag).frame(width: 0, height: 0)
            ScreenShotView(contextView: content)
         //  Spacer()
            //content//.background(BackgroundClearView())
        }
        .onAppear {
//            guard let view = UIHostingController(rootView: content).view else{
//                print("find no view")
//                fatalError("error to find view")
//                return
//            }
//
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//                guard let view = UIApplication.shared.windows.first?.viewWithTag(100038)
//                else{
//                    print("find no view")
//                    return
//                }
            
                UIApplication.shared.windows.forEach { window in
                    guard let view = window.viewWithTag(100038) else { return }

                    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
                    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
                    let image = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()

                    self.createDirectory()

                    try? image.pngData()?.write(to: URL(fileURLWithPath: self.screenshotPath))
                }
            }
        }
    }
}

extension View {
    ///在Preview界面生成截图
    ///  Usage:
    /// 1. Use .screenshot(name:) on your view
    /// 2. Turn on Live Preview (the play icon in the Canvas)
    /// => Screenshot will appear in a few seconds
    public func screenshot(name: String) -> some View {
        self.modifier(PreviewScreenshot(screenshotName: name))
    }
}

struct PreviewScreenshot_Previews: PreviewProvider {
    static var previews: some View {
        // Usage:
        // 1. Use .screenshot(name:) on your view
        // 2. Turn on Live Preview (the play icon in the Canvas)
        // => Screenshot will appear in a few seconds
        VStack{
        Text("Screenshot!")
        .background(.bar,in:RoundedRectangle(cornerRadius: 20))
           
            Spacer()
        }   .screenshot(name: "Test9")
            //.colorScheme(.dark) // colorScheme should come after .screenshot(name:) to affect the screenshot name
    }
}
#endif
//extension UIApplication {
//
//    var keyWindow: UIWindow? {
//        // Get connected scenes
//        return UIApplication.shared.connectedScenes
//            // Keep only active scenes, onscreen and visible to the user
//            .filter { $0.activationState == .foregroundActive }
//            // Keep only the first `UIWindowScene`
//            .first(where: { $0 is UIWindowScene })
//            // Get its associated windows
//            .flatMap({ $0 as? UIWindowScene })?.windows
//            // Finally, keep only the key window
//            .first(where: \.isKeyWindow)
//    }
//
//}
//
//extension UIApplication {
//
//    var keyWindowPresentedController: UIViewController? {
//        var viewController = self.keyWindow?.rootViewController
//
//        // If root `UIViewController` is a `UITabBarController`
//        if let presentedController = viewController as? UITabBarController {
//            // Move to selected `UIViewController`
//            viewController = presentedController.selectedViewController
//        }
//
//        // Go deeper to find the last presented `UIViewController`
//        while let presentedController = viewController?.presentedViewController {
//            // If root `UIViewController` is a `UITabBarController`
//            if let presentedController = presentedController as? UITabBarController {
//                // Move to selected `UIViewController`
//                viewController = presentedController.selectedViewController
//            } else {
//                // Otherwise, go deeper
//                viewController = presentedController
//            }
//        }
//
//        return viewController
//    }
//
//}

struct ScreenShotView<T: View>: UIViewRepresentable {
    let contextView : T
    func makeUIView(context: Context) -> UIView {
        let viewController = UIHostingController(rootView: contextView)
    
        guard let view = viewController.view else{
            return UIVisualEffectView(effect: UIBlurEffect(style: .light))
        }
    
        DispatchQueue.main.async {
           // view.backgroundColor = .clear
           // view.superview?.backgroundColor = .red
            view.backgroundColor = .clear
            view.tag = 100038
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
