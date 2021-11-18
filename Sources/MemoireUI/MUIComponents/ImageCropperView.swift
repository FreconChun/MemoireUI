

//
//  CropImageView.swift
//  CropImageView
//
//  Created by Xingfa Zhou on 2020/7/30.
//  Copyright © 2020 Yitesi. All rights reserved.
//
import SwiftUI
import MemoireUI


struct RectHole: Shape {
    let holeSize: CGSize
    func path(in rect: CGRect) -> Path {
        let path = CGMutablePath()
        path.move(to: rect.origin)
        path.addLine(to: .init(x: rect.maxX, y: rect.minY))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.addLine(to: .init(x: rect.minX, y: rect.maxY))
        path.addLine(to: rect.origin)
        path.closeSubpath()
        
        let newRect = CGRect(origin: .init(x: rect.midX - holeSize.width/2.0, y: rect.midY - holeSize.height/2.0), size: holeSize)
        
        path.move(to: newRect.origin)
        path.addLine(to: .init(x: newRect.maxX, y: newRect.minY))
        path.addLine(to: .init(x: newRect.maxX, y: newRect.maxY))
        path.addLine(to: .init(x: newRect.minX, y: newRect.maxY))
        path.addLine(to: newRect.origin)
        path.closeSubpath()
        return Path(path)
    }
}

@available(iOS 13.0, OSX 10.15, *)
public struct CropImageView: View {
    
    @State private var dragAmount = CGSize.zero
    @State private var scale: CGFloat = 1.0
    
    @State private var clipped = false
    var inputImage: UIImage
    // @Binding var resultImage:  UIImage?
    var cropSize: CGSize
    
    @State private var tempResult: UIImage?
    @State private var result: Image?
    @State private var showNoBlackCoverImage: Bool = false
    @GestureState var magnifyBy = CGFloat(1.0)
    @GestureState var offsetBy = CGSize.zero
    @GestureState var rotationState: CGFloat = 0
    @State var rotationDegree: CGFloat = 0
    var cancelAction: () -> Void = {}
    var doneAction: (UIImage) -> Void = {_ in}
    public init(inputImage:UIImage ,cropSize:CGSize,cancelAction: @escaping () -> Void = {},doneAction: @escaping (UIImage) -> Void = {_ in} ){
        self.inputImage = inputImage
        //_resultImage = resultImage
        self.cropSize = cropSize
        self.doneAction = doneAction
        self.cancelAction = cancelAction
    }
    
    func removeBlackCoverImage() {
        if !showNoBlackCoverImage{
            
            Task(priority:.high){
                await MainActor.run {
                    showNoBlackCoverImage = true
                }
                
            }
        }
    }
    var magnificationGesture: some Gesture{
        MagnificationGesture()
        
            .updating($magnifyBy){ currentState, gestureState, transaction in
                removeBlackCoverImage()
                gestureState = currentState
            }
            .onEnded { newValue in
                showNoBlackCoverImage = false
                scale *= newValue.magnitude
            }
    }
    
    var doubleTapGesture: some Gesture{
        TapGesture(count: 2).onEnded {
            withAnimation(){
                dragAmount = CGSize.zero
                scale = 1.0
                
                clipped = false
            }
        }
    }
    var rotationGesture: some Gesture {
        RotationGesture()
            .updating($rotationState, body: { value, state, transaction in
                state = value.degrees
                removeBlackCoverImage()
                
            }
            )
            .onEnded { newAngle in
                
                showNoBlackCoverImage = false
                let angle = Angle.degrees(rotationDegree + newAngle.degrees).toBetween0to360()
                
                if (Angle.degrees(0) ..<  Angle.degrees(45)).contains(angle) || (Angle.degrees(315) ..<  Angle.degrees(360)).contains(angle) {
                    rotationDegree = 0
                }else if (Angle.degrees(45)..<Angle.degrees(135)).contains(angle){
                    rotationDegree = 90
                }else if (Angle.degrees(135)..<Angle.degrees(225)).contains(angle){
                    rotationDegree = 180
                }else {
                    rotationDegree = 270
                }
                
                
            }
    }
    
    var dragGesture: some Gesture{
        DragGesture()
            .updating($offsetBy) { value, state, transaction in
                removeBlackCoverImage()
                
                
                changeOffsetbyOrientation(offset: &state, update: value.translation, by: orientation)
            }
            .onEnded{ value in
                showNoBlackCoverImage = false
                var offset = CGSize.zero
                changeOffsetbyOrientation(offset: &offset, update: value.translation, by: orientation)
                dragAmount.width += offset.width
                dragAmount.height += offset.height
                
                
            }
    }
    
    func changeOffsetbyOrientation(offset state:inout CGSize,update value: CGSize,by: UIImage.Orientation){
        switch orientation {
            
        case .right:
            state.width = CGFloat(value.height)
            state.height = CGFloat(-value.width)
        case .left:
            state.width = CGFloat(-value.height)
            state.height = CGFloat(value.width)
        case.down:
            state.width = CGFloat(-value.width)
            state.height = CGFloat(-value.height)
        default:
            state.width = CGFloat(value.width)
            state.height = CGFloat(value.height)
        }
    }
    var imageView: some View {
        Image(uiImage: inputImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
        
        
        // 拖拽
        
        
        //        //点击放大
        //            .simultaneousGesture(   TapGesture()
        //                                        .onEnded { _ in
        //                                            self.scale += 0.1
        //                                            print("\(self.scale)")
        //                                        })
        
        
        
    }
    
    public var body: some View {
        GeometryReader { proxy  in
            ZStack(alignment:.top){
                ZStack {
                    if self.clipped {
                        self.result?.resizable().scaledToFit()
                            .frame(width:self.cropSize.width,height: self.cropSize.height)
                            .clipShape(Circle())
                        //  .overlay(Circle().stroke(Color.mBlue,lineWidth: 2))
                        // .rotationEffect(.degrees(rotationDegree))
                    } else {
                        self.imageView
                        
                            .offset(self.dragAmount)
                            .offset(self.offsetBy)
                            .scaleEffect(magnifyBy)
                            .scaleEffect(scale)
                        //.animation(.linear, value: dragAmount)
                            .animation(.linear.speed(10),value: offsetBy)
                        //                            .animation(.linear,value:scale)
                        //                            .animation(.linear,value:magnifyBy)
                        
                            .rotationEffect(.degrees(rotationState + rotationDegree))
                        //                            .shortRotationEffect(.degrees(rotationDegree), id: UUID())
                        //.shortRotationEffect(.degrees(rotationDegree))
                        
                        //                    .scaledToFit()
                    }
                    
                    RectHole(holeSize: self.cropSize)
                        .fill(.black.opacity(showNoBlackCoverImage ? 0.3 : 0.8), style: FillStyle(eoFill: true,antialiased: true))//.ignoresSafeArea()
                        .animation(.spring(), value: showNoBlackCoverImage)
                    
                    //                        .fill(Color(UIColor.black.withAlphaComponent(0.5)),style: FillStyle(eoFill: true,antialiased: true))
                    
                        .allowsHitTesting(false)
                    
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .frame(width:self.cropSize.width,height: self.cropSize.height)
                        .background(Rectangle().stroke(Color.white,lineWidth: 2))
                    
                }
                
                // .frame(width:proxy.size.width,height: proxy.size.height)
                // .mask(RoundedRectangle(cornerRadius: .radiusL)     .padding().padding(.vertical,.iconLarge))
                .ignoresSafeArea()
                Color.clear
                    .contentShape(Rectangle())
                    .simultaneousGesture(magnificationGesture)
                    .simultaneousGesture(dragGesture)
                    .simultaneousGesture(rotationGesture)
                    .simultaneousGesture(doubleTapGesture)
                //                .overlay{
                //                    VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        cancelAction()
                        // presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("取消")
                    }.buttonStyle(of: .destruction)
                    
                    Button {
                        cropTheImageWithImageViewSize(proxy.size)
                        if let tempResult = tempResult {
                            
                            doneAction(tempResult)
                            
                        }
                        
                        cancelAction()
                    } label: {
                        Text("完成")
                    }.buttonStyle(of: .prominence)
                    
                    
                    
                }.padding(10)
                //
                //
                //                        Spacer()
                //
                //
                //                    }
                //
                //                }
                
            }
            .contentShape(Rectangle())
            
        }
        //.zIndex(100)
        
        
    }
    
    func cropTheImageWithImageViewSize(_ size: CGSize) {
        
        let imsize =  inputImage.size
        let scale = max(inputImage.size.width / size.width,
                        inputImage.size.height / size.height)
        
        
        let zoomScale = self.scale
        
        //        print("imageView size:\(size), image size:\(imsize), aspectScale:\(scale),zoomScale:\(zoomScale)，currentPostion:\(dragAmount)")
        
        let currentPositionWidth = self.dragAmount.width * scale
        let currentPositionHeight = self.dragAmount.height * scale
        
        let croppedImsize = CGSize(width: (self.cropSize.width * scale) / zoomScale, height: (self.cropSize.height * scale) / zoomScale)
        
        let xOffset = (( imsize.width - croppedImsize.width) / 2.0) - (currentPositionWidth)
        let yOffset = (( imsize.height - croppedImsize.height) / 2.0) - (currentPositionHeight)
        let croppedImrect: CGRect = CGRect(x: xOffset, y: yOffset, width: croppedImsize.width, height: croppedImsize.height)
        
        //        print("croppedImsize:\(croppedImsize),croppedImrect:\(croppedImrect)")
        // inputImage.imageOrientation
        if let cropped = inputImage.fixOrientation().cgImage?.cropping(to: croppedImrect) {
            let croppedIm = UIImage(cgImage: cropped, scale: 1, orientation: orientation)
            tempResult = croppedIm
            
            result = Image(uiImage: croppedIm)
        }
    }
    var orientation: UIImage.Orientation{
        if rotationDegree.truncatingRemainder(dividingBy: 360) == 0 {
            return .up
        }else if rotationDegree.truncatingRemainder(dividingBy: 360) == 90{
            return .right
        }else if rotationDegree.truncatingRemainder(dividingBy: 360) == 270{
            return .left
        }else{
            return .down
        }
    }
    
}

struct CropImageView_Previews: PreviewProvider {
    @State static var result: UIImage?
    static var previews: some View {
        CropImageView(inputImage: UIImage(named:"CUC1")!,cropSize: .init(width: 200, height: 200))
    }
}

public extension UIImage {
    
    /// Extension to fix orientation of an UIImage without EXIF
    func fixOrientation() -> UIImage {
        
        guard let cgImage = cgImage else { return self }
        
        if imageOrientation == .up { return self }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
            
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi/2)
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
            
        default :
            break
        }
        
        switch imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
            
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        if let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            
            ctx.concatenate(transform)
            
            switch imageOrientation {
                
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
                
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            
            if let finalImage = ctx.makeImage() {
                return (UIImage(cgImage: finalImage))
            }
        }
        
        // something failed -- return original
        return self
    }
}

extension Angle {
    func toBetween0to360() ->Self{
        Angle.degrees( self.asDoubleBetween0and360)
    }
    var asDoubleBetween0and360: Double {
        var result = fmod(self.degrees, 360)
        if result < 0 {
            result += 360.0
        }
        return result
    }
}
