---
theme: default
title: PencilKitで実装するPDFへの手書き注釈
author: Ras (@ras0q)
keywords: iOSDC,iOSDC2024
download: true
info: |
  https://fortee.jp/iosdc-japan-2024/proposal/c39177cc-63a3-46f6-a3e4-5be077839662
highlighter: shiki
drawings:
  persist: false
mdc: true
layout: cover
---

# PencilKitで実装する<br/>PDFへの手書き注釈

iOSDC Japan 2024 Day2 Track B

## Ras (@ras0q)

---

## Keynote

- PencilKit の紹介・実装
- Apple Pencil で PDF に注釈したい！
- PencilKit の Good & More

## 注意事項

- 紹介するコードは全体の実装の一部です
  - 詳細な実装はGitHubを参照ください → [ras0q/iosdc2024](https://github.com/ras0q/iosdc2024)

---

## Ras

[<ri-twitter-x-fill />](https://x.com/ras0q) [<ri-github-fill />](https://github.com/ras0q) @ras0q

---
layout: center
---

# PencilKit?

---

## PencilKit

<div/>

<img
  alt="WWDC19で発表されたPencilKitのデモ画面"
  src="/pencilkit-wwdc19.png"
  class="w-3/5 h-auto mx-auto"
/>

<div class="text-right">引用元: WWDC19</div>

---

## PencilKit

<h3 class="text-center my-4"><strong>手書き認識をiOSアプリに組み込むことができる純正ライブラリ</strong></h3>

- 絵・図形を描くための環境が簡単に揃う
  - ペンの種類が豊富
    - 鉛筆, 万年筆, クレヨン, 定規, ...
  - ペンの設定ツールも標準で付属
- 様々な純正アプリに組み込まれている
  - メモ, 写真, ファイル, ...
- PencilKitを使ったアプリ感で図形の連携ができる
  - 移動, コピー＆ペースト, ...

---
layout: center
---

# try! PencilKit

in 1 minute

---

## try! PencilKit

````md magic-move
```swift
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
```

```swift {*|1,5,10}
import PencilKit
import UIKit

class ViewController: UIViewController {
    private lazy var canvasView = PKCanvasView(frame: view.frame)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(canvasView)
    }
}
```

```swift {*|6,13-16}
import PencilKit
import UIKit

class ViewController: UIViewController {
    private lazy var canvasView = PKCanvasView(frame: view.frame)
    private lazy var toolPicker = PKToolPicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(canvasView)

        toolPicker.addObserver(canvasView)
        toolPicker.setVisible(true, forFirstResponder: canvasView)

        canvasView.becomeFirstResponder()
    }
}
```
````

---

## 完成！

<SlidevVideo autoplay autoreset="slide" class="w-3/5 h-auto mx-auto">
  <source src="/pencilkit-in3min.mp4" type="video/mp4">
</SlidevVideo>

---
layout: center
---

# try! PDF Integration

---

# PDFKit

```swift
import PDFKit
import UIKit

class ViewController: UIViewController {
    private lazy var pdfDocument = PDFDocument(somePDFURL)
    private lazy var pdfView: PDFView = {
        let view = PDFView()
        view.document = pdfDocument
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pdfView)
    }
}
```

---
title: What's new in PDFKit (WWDC22)
layout: image
image: /pdfkit-wwdc22-1.png
---

---
title: How can I draw on PDF pages using PencilKit?
layout: image
image: /pdfkit-wwdc22-2.png
---

---
title: the answer is to use an overlay view.
layout: image
image: /pdfkit-wwdc22-3.png
---

---
title: PDFPageOvelayViewProvider
layout: image
image: /pdfkit-wwdc22-4.png
backgroundSize: contain
---

---

## PDFPageOvelayViewProvider

```swift {*|1,8-17|1,20-24}
import PencilKit
import PDFKit
import UIKit

class ViewController: UIViewController {
    // ....

    // 各ページに対してCanvasViewを作成
    private lazy var canvasViews: [PKCanvasView] = (0 ..< pdfDocument!.pageCount).map { _ in
        let view = PKCanvasView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }

    // ページ番号をインデックスとしてcanvasViewsの要素を返す関数
    private func canvasView(for: page) -> PKCanvasView { ... }
}

extension ViewController: PDFPageOverlayViewProvider {
    func pdfView(_: PDFView, overlayViewFor page: PDFPage) -> UIView? {
        canvasView(for: page)
    }
}
```

---

## 手書き認識の設定

```swift {*|2,10-11|13-14|17-19}
// in ViewController...
private lazy var toolPicker = PKToolPicker()

override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(pdfView)

    for canvasView in canvasViews {
        // 各キャンバスにツールを設定する
        toolPicker.addObserver(canvasView)

        // 各キャンバスの手書き認識をPDFViewに登録する
        pdfView.addGestureRecognizer(canvasView.drawingGestureRecognizer)
    }

    // PKCanvasViewはoverlayしているだけなので、first responderはPDFViewになる
    toolPicker.setVisible(true, forFirstResponder: pdfView)
    pdfView.becomeFirstResponder()
}
```

---

## 複数の手書き認識を設定した結果...

<div/>

どのページにも最後に追加した`drawingGestureRecognizer`のみが発火してしまう

<div class="h-4/5 flex items-center">
  <img
    alt="最後に追加したdrawingGestureRecognizerのみが発火してしまう"
    src="/drawingGestureRecognizer-issue.svg"
    class="w-full h-auto mx-auto"
  />
</div>

---

## 複数の手書き認識を設定した結果...

<div/>

タップ時に該当ページの`drawingGestureRecognizer`のみを適切に発火させる必要がある

<div class="h-4/5 flex items-center">
  <img
    alt="タップ時にdrawingGestureRecognizerを適切に制御する"
    src="/drawingGestureRecognizer-resolve.svg"
    class="w-full h-auto mx-auto"
  />
</div>

---

## override func hitTest()

タップしたページのキャンバスの手書き認識のみ有効化

```swift
protocol CanvasPDFViewDelegate: AnyObject {
    func switchActivePage(to page: PDFPage)
}

class CanvasPDFView: PDFView {
    var interactionDelegate: (any CanvasPDFViewDelegate)?

    // ✅
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let activePage = page(for: point, nearest: true) {
            // 移譲先でdrawingGestureRecognizer.isEnabled を切り替える
            interactionDelegate?.switchActivePage(to: activePage)
        }

        return super.hitTest(point, with: event)
    }
}
```

---
layout: center
---

# try! PDF Annotation

---

## おさらい

<br/>

### 今できること

- PencilKitを使ってキャンバス画面に図形を描画する
- PDF上にキャンバスを重ねて各ページに図形を描画する

### これから行うこと

- 描画した図形を注釈としてPDFに反映させる
- 注釈を反映したPDFを保存する

---

## PKCanvasView → PDFView

<div class="relative h-4/5 flex items-center">
  <img
    alt="annotation-1"
    src="/annotation-1.svg"
    class="absolute w-full h-auto mx-auto"
    v-click.hide="1"
  />
  <img
    alt="annotation-2"
    src="/annotation-2.svg"
    class="absolute w-full h-auto mx-auto"
    v-click="1"
  />
</div>

---

## PKCanvasView → PDFView

`PDFView`への注釈は`PDFAnnotation`を使う

`PKCanvasView`の描画は`canvasView.drawing: PKDrawing`から取得できる

```swift {*|7-10}
class CanvasPDFAnnotation: PDFAnnotation {
    private let drawing: PKDrawing

    init(drawing: PKDrawing, page: PDFPage) {
        self.drawing = drawing

        var pdfBounds = drawing.bounds
        pdfBounds.origin.y = page.bounds(for: .mediaBox).height
            - drawing.bounds.height
            - drawing.bounds.origin.y

        super.init(bounds: pdfBounds, forType: .ink, withProperties: nil)

        self.page = page
    }
}
```

<div v-click="2">これは？</div>

---

## 座標系の変換

```swift
pdfBounds.origin.y = page.bounds(for: .mediaBox).height - drawing.bounds.height - drawing.bounds.origin.y
```

<div class="h-3/4 flex items-center">
  <img
    alt="Coordinate differences between PDF and UIView"
    src="/coordinates.png"
    class="w-auto h-full mx-auto"
  />
</div>

<div class="text-right">引用元: <a href="https://zenn.dev/cookiezby/articles/38a7c23dd15706">iOSのPDFKitを利用してPDFを編集する | Zenn</a></div>

---

## PKCanvasView → PDFView

```swift {*|2-3|5-10|12-15|17-18}
class CanvasPDFAnnotation: PDFAnnotation {
    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        super.draw(with: box, in: context)

        UIGraphicsPushContext(context)
        context.saveGState()
        defer {
            context.restoreGState()
            UIGraphicsPopContext()
        }

        // Y-flip (M' = Scale * Translate * M)
        let pageHeight = page!.bounds(for: box).height
        context.translateBy(x: 0, y: pageHeight)
        context.scaleBy(x: 1.0, y: -1.0)

        let image = drawing.image(from: drawing.bounds, scale: 1.0)
        image.draw(in: drawing.bounds)
    }
}
```

---

## 使用例

```swift
guard let page = pdfView.currentPage, let canvasView = canvasView(for: page) else {
    return
}

// キャンバスへの描画を1つの注釈としているため更新時にリセットが必要
let existingAnnotations = page.annotations.filter { $0 is CanvasPDFAnnotation }
for annotation in existingAnnotations {
    page.removeAnnotation(annotation)
}

let annotation = CanvasPDFAnnotation(drawing: canvasView.drawing, page: page)
page.addAnnotation(annotation)
```

---
layout: center
---

## ✅ 描画した図形を注釈としてPDFに反映させる

---

## PDFView → Raw PDF File

<div class="relative h-4/5 flex items-center">
  <img
    alt="annotation-2"
    src="/annotation-2.svg"
    class="absolute w-full h-auto mx-auto"
    v-click.hide="1"
  />
  <img
    alt="annotation-3"
    src="/annotation-3.svg"
    class="absolute w-full h-auto mx-auto"
    v-click="1"
  />
</div>

---

## PDFView → Raw PDF File

```swift
let data = pdfDocument.dataRepresentation()
let documentURL = pdfDocument.documentURL

try data.write(to: documentURL)
```

---
layout: center
---

## ✅ 注釈を反映したPDFを保存する

---

TODO: 保存機能を実装してデモを貼る

---
layout: end
---

# ありがとうございました！

[サンプルレポジトリ](https://github.com/ras0q/iosdc2024) も是非ご覧ください！

<img alt="repo qrcode" src="/qrcode.svg" width="150px" height="150px" class="mx-auto" />

Presenter: Ras (@ras0q [<ri-twitter-x-fill />](https://x.com/ras0q) [<ri-github-fill />](https://github.com/ras0q))

---

## References

- [PencilKit | Apple Developer Documentation](https://developer.apple.com/documentation/pencilkit)
- [PDFKit | Apple Developer Documentation](https://developer.apple.com/documentation/pdfkit)
- [What's new in PDFKit - WWDC22 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2022/10089/)
- [iOSのPDFKitを利用してPDFを編集する | Zenn](https://zenn.dev/cookiezby/articles/38a7c23dd15706)

<!-- TODO: improve CSS -->
<footer class="absolute bottom-12 right-12">
<div class="text-right block">This slide is powered by <a href="https://sli.dev">Slidev</a></div>
</footer>
