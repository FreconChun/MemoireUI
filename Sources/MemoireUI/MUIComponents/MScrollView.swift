//
//  MScrollView.swift
//  MTest-MemoireUI
//
//  Created by 李昊堃 on 2021/11/3.
//

import SwiftUI

///传递ScrollView的当前位移
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

///可以获取用户滑动位置进行相应操作的ScrollView
public struct MScrollView<Content: View>: View {
    let axes: Axis.Set
    let showsIndicators: Bool
    let offsetChanged: (CGPoint) -> Void
    let content: Content

    public init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        offsetChanged: @escaping (CGPoint) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.offsetChanged = offsetChanged
        self.content = content()
    }
   public var body: some View {
          SwiftUI.ScrollView(axes, showsIndicators: showsIndicators) {
              GeometryReader { geometry in
                  Color.clear.preference(
                      key: ScrollOffsetPreferenceKey.self,
                      value: geometry.frame(in: .named("scrollView")).origin
                  )
              }.frame(width: 0, height: 0)
              content
          }
          .coordinateSpace(name: "scrollView")
          .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: offsetChanged)
      }
}

