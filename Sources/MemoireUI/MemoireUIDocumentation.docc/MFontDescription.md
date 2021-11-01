# MFont

给自定义字体提供类似SwiftUI的API

## Overview
MFont首先使用``MFontController``初始化在MFont/Resources目录下的字体文件（需要提供字体的名称），之后再使用SwiftUI对于自定义字体的API即可。为了实现多样式的字符串内插，相同的API在View和Text中都有提供


## 使用方法
```swift
    Text("hello, world!")   
        .mfont(size: .caption2, type: .NotoSerifSC, weight: .semiBold)
```



## Topics


### 字体样式

- ``MFont``
- ``MFontSize``
- ``MFontWeight``


### MFontWeight
字重根据导入的字体文件可以动态添加，需要注意的是，在注册字体时使用字体名+字重的形式检索目录，因此需要注意文件名称

- ``MFontWeight/bold``
- ``MFontWeight/semiBold``
- ``MFontWeight/regular``

### MFontSize
字体尺寸根据HIG的描述提供了对应的尺寸，但是由于字体太大因此提供了一些更小的字体。为了支持动态字体大小调节，和自重以及SwiftUI.Font.TextStyle相关联

- ``MFontSize/largeTitle``
- ``MFontSize/title``
- ``MFontSize/title2``
- ``MFontSize/title3``
- ``MFontSize/headline``
- ``MFontSize/subheadline``
- ``MFontSize/body``
- ``MFontSize/callout``
- ``MFontSize/footnote``
- ``MFontSize/caption``
- ``MFontSize/caption2``
- ``MFontSize/bannerTitle``
- ``MFontSize/bannerBody``


### 原理
- ``MFontController``

*【✅2021.11.01】*
