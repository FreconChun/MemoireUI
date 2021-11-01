# MAttention

Memoire的用户提醒UI

## Overview

MAttention中包含了Alert,Banner以及Dialog三种常用的用户提醒方式，包含了设计规范和API实现

### 使用方法

**准备工作：**

使用MAttention时需要在根视图上使用``AttentionalModifier``修饰符，使用此修饰符可以保证所有的提示内容会显示在最上层
```swift
import SwiftUI
import MemoireUI

@main
struct MTest_MemoireUIApp: App {
    var body: some Scene {
        WindowGroup {
            MAttentionView()
                .attentional()
        }
    }
}

```

**添加提醒：**

使用EnvironmentObject来获得环境中的``AttentionCenter``,向其中注入对应的数据即可，常用数据应该提前作为计算属性加入到对应结构体中。（注意，计算属性中使用UUID()可能会造成一些麻烦）

```swift

public struct MAttentionView: View {
 
    @EnvironmentObject var attentionCenter: AttentionCenter
    public var body: some View {
        Button {
            attentionCenter.addAlert(data: .changePolicyAlertData)
        } label: {...}
    }
}

```


## Topics

### 设计规范

- <doc:MAttentionDesign>



### 行为
行为用来控制Button的渲染和回调函数
- ``Action``
- ``ActionType``

### 数据类型
- ``AlertViewData``
- ``BannerViewData``
- ``DialogData``


### 实现原理
- ``AttentionCenter``
- ``AttentionalModifier``

### 测试页面
- ``MAttentionView``

*【✅2021.11.01】*
