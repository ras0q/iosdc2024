---
theme: default
title: PencilKitで実装するPDFへの手書き注釈
titleTemplate: "[iOSDC Japan 2024] %s"
info: |
  repo: https://github.com/ras0q/iosdc2024
  slide: https://iosdc2024.ras0q.github.io
  proposal: https://fortee.jp/iosdc-japan-2024/proposal/c39177cc-63a3-46f6-a3e4-5be077839662
author: Ras (@ras0q)
keywords: iOSDC,iOSDC2024,iOSDC Japan 2024
download: true
exportFilename: iosdc2024-ras0q-pencilkit-pdf-annotation
export:
  format: pdf
  withClicks: true
  withToc: true
highlighter: shiki
twoslash: false
monaco: false
mdc: true
layout: cover
---

# PencilKitで実装する<br/>PDFへの手書き注釈

iOSDC Japan 2024 Day2 Track B

<div class="absolute bottom-8">
  Ras (@ras0q)
</div>

---

# Keynote

1. PencilKitとは？
2. PencilKitでアプリを作る
3. PencilKitをPDFに組み込む
4. PencilKitのドローイングをPDF注釈として保存する
5. PencilKitを使ってみた感想

<div class="text-center my-8">
  <div>↓↓サンプルレポジトリ↓↓</div>
  <a href="https://github.com/ras0q/iosdc2024" class="font-bold">github.com/ras0q/iosdc2024</a>
</div>

<Comment>
  <PoweredBySlidev />
</Comment>

<!--
30s
-->

---
layout: self-introduction
---

## 東京工業大学 大学院 修士1年

- 10月に大学が改名するらしい
- デジタル創作同好会traP
  - Web開発をメインに創作をしています
  - <a href="https://portfolio.trap.jp">portfolio.trap.jp</a> をリリースしました

## ピクシブ株式会社 アルバイト

- iOSアプリエンジニア育成プロジェクト
- pixiv / pixiv Sketch / Pastela
- iOSDC Japan 参加(3) 登壇(2)

<!-- 10s -->

---

# Keynote

1. <span class="bg-yellow-2">PencilKitとは</span>
2. PencilKitでアプリを作る
3. PencilKitをPDFに組み込む
4. PencilKitのドローイングをPDF注釈として保存する
5. PencilKitを使ってみた感想

<div class="text-center my-8">
  <div>↓↓サンプルレポジトリ↓↓</div>
  <a href="https://github.com/ras0q/iosdc2024" class="font-bold">github.com/ras0q/iosdc2024</a>
</div>

---
layout: section
---

# PencilKit?

---

## PencilKit?

<div/>

<img
  alt="WWDC19で発表されたPencilKitのデモ画面"
  src="/pencilkit-wwdc19.png"
  class="w-3/5 h-auto mx-auto"
/>

<div class="text-sm text-right">引用元: WWDC19</div>

<!-- iPadやiPhoneを持っている方ならこのような画面を見たことがあるのではないでしょうか
これはファイルアプリでマークアップを行っている画面です -->

---

## PencilKit

<div class="text-center text-2xl font-semibold my-4">ドローイングをiOSアプリに組み込むことができる純正ライブラリ</div>

指やApple Pencilからの入力を受け取ってアプリで使う画像データに変換する

<div class="mt-8 grid grid-cols-3 gap-8">
  <div class="p-8 grid place-items-center text-center h-full aspect-ratio-square bg-blue-1 rounded-full">
    <h3 class="font-semibold">描画ツール搭載</h3>
    <div>鉛筆のほかに<br/>万年筆や定規も...</div>
  </div>
  <div class="p-8 grid place-items-center text-center h-full aspect-ratio-square bg-blue-1 rounded-full">
    <h3 class="font-semibold">純正アプリにも</h3>
    <div>ファイル, メモ, <br/>写真...</div>
  </div>
  <div class="p-8 grid place-items-center text-center h-full aspect-ratio-square bg-blue-1 rounded-full">
    <h3 class="font-semibold">アプリ間の連携</h3>
    <div>別アプリへ図形のコピペが可能</div>
  </div>
</div>

---

# Keynote

1. PencilKitとは？ ✅
2. <span class="bg-yellow-2">PencilKitでアプリを作る</span>
3. PencilKitをPDFに組み込む
4. PencilKitのドローイングをPDF注釈として保存する
5. PencilKitを使ってみた感想

<div class="text-center my-8">
  <div>↓↓サンプルレポジトリ↓↓</div>
  <a href="https://github.com/ras0q/iosdc2024" class="font-bold">github.com/ras0q/iosdc2024</a>
</div>

---
layout: section
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

```swift {1,5,10}
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

```swift {6,13-16|*}
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

<!--
ベーシックなVCを用意します

PencilKitをimportし、PKCanvasViewを追加します、これでキャンバスが画面全体に広がりました

描画ツールを使うにはPKToolPickerを使います
toolPickerの監視対象にcanvasViewを追加し、canvasViewがfirst responderになったときにtoolPickerを表示するようにします
-->

---

## ✅ PencilKitでアプリを作る

<SlidevVideo autoplay autoreset="slide" class="w-auto h-4/5 mx-auto my-16">
  <source src="/pencilkit-in3min.mp4" type="video/mp4">
</SlidevVideo>

<!--
完成しました!

20行弱のコードでこのようなメモアプリを簡単に実装することができます
-->

---

# Keynote

1. PencilKitとは？ ✅
2. PencilKitでアプリを作る ✅
3. <span class="bg-yellow-2">PencilKitをPDFに組み込む</span>
4. PencilKitのドローイングをPDF注釈として保存する
5. PencilKitを使ってみた感想

<div class="text-center my-8">
  <div>↓↓サンプルレポジトリ↓↓</div>
  <a href="https://github.com/ras0q/iosdc2024" class="font-bold">github.com/ras0q/iosdc2024</a>
</div>

---
layout: section
---

# try! PDF Integration

<!-- 次は、PDFにPencilKitを統合してみましょう! -->

---

## PDFKit

````md magic-move
```swift
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
```

```swift {1,5}
import PDFKit
import UIKit

class ViewController: UIViewController {
    private lazy var pdfDocument = PDFDocument(somePDFURL)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
```

```swift {6-10,15|*}
import PDFKit
import UIKit

class ViewController: UIViewController {
    private lazy var pdfDocument = PDFDocument(somePDFURL)
    private lazy var pdfView: PDFView = {
        let view = PDFView(frame: view.frame)
        view.document = pdfDocument
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pdfView)
    }
}
```
````

<!-- PDFを使うには同じく標準ライブラリのPDFKitを使います

ドキュメントを読み込み、PDFViewに設定することでPDFをアプリ上に表示させることができるようになります
 -->

---
layout: center
---

## どうやってPencilKitを組み込む？

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

```swift
import PencilKit

class ViewController: UIViewController {
    // 各ページに対してCanvasViewを作成
    private lazy var canvasViews = (0..<ページ数).map { _ in
        PKCanvasView()
    }

    // ページ番号をインデックスとしてcanvasViewsの要素を返す関数
    private func canvasView(for: page) -> PKCanvasView { ... }
```

```swift
extension ViewController: PDFPageOverlayViewProvider {
    func pdfView(_: PDFView, overlayViewFor page: PDFPage) -> UIView? {
        canvasView(for: page)
    }
}
```

---

## ドローイングの設定

```swift {*|2,7|9-12|15-17}
class ViewController: UIViewController {
    private lazy var toolPicker = PKToolPicker()

    override func viewDidLoad() {
        // ...
        for canvasView in canvasViews {
            toolPicker.addObserver(canvasView)

            // キャンバスのドローイング用RecognizerをPDFViewに追加する
            pdfView.addGestureRecognizer(
              canvasView.drawingGestureRecognizer
            )
        }

        // 今回のfirst responderはPDFView
        toolPicker.setVisible(true, forFirstResponder: pdfView)
        pdfView.becomeFirstResponder()
    }
```

---

## 複数の手書き認識を設定した結果...

<div/>

最後に追加したRecognizerしか発火しない

`// TODO: もっといい方法がある？`

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

タップ時に該当ページのRecognizerのみを適切に発火させる必要がある

`// TODO: SVGのindexが間違ってる`

<div class="h-4/5 flex items-center">
  <img
    alt="タップ時にdrawingGestureRecognizerを適切に制御する"
    src="/drawingGestureRecognizer-resolve.svg"
    class="w-full h-auto mx-auto"
  />
</div>

---

## Override `func hitTest(_:with:)`

タップしたページのキャンバスの手書き認識のみ有効化

```swift {*|4|5,6}
class CanvasPDFView: PDFView {
    let switchRecognizerHandler: (to: PDFPage) -> Void

    override func hitTest(_ point:CGPoint,with e:UIEvent?) -> UIView? {
        // pointから該当ページを探すことができる
        if let activePage = page(for: point, nearest: true) {
            switchRecognizerHandler(to: page)
        }

        return super.hitTest(point, with: e)
    }
}
```

---

## ✅ PencilKitをPDFに組み込む

<SlidevVideo autoplay autoreset="slide" class="w-auto h-4/5 mx-auto my-16">
  <source src="/pencilkit-with-pdfkit.mp4" type="video/mp4">
</SlidevVideo>

---

# Keynote

1. PencilKitとは？ ✅
2. PencilKitでアプリを作る ✅
3. PencilKitをPDFに組み込む ✅
4. <span class="bg-yellow-2">PencilKitのドローイングをPDF注釈として保存する</span>
5. PencilKitを使ってみた感想

<div class="text-center my-8">
  <div>↓↓サンプルレポジトリ↓↓</div>
  <a href="https://github.com/ras0q/iosdc2024" class="font-bold">github.com/ras0q/iosdc2024</a>
</div>

---
layout: section
---

# try! PDF Annotation

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

## ドローイングを注釈として追加する

```swift {*|7-10}
class CanvasPDFAnnotation: PDFAnnotation {
    private let drawing: PKDrawing

    init(drawing: PKDrawing, page: PDFPage) {
        self.drawing = drawing

        var pdfBounds = drawing.bounds
        pdfBounds.origin.y = page.bounds(for: .mediaBox).height
            - drawing.bounds.height
            - drawing.bounds.origin.y

        super.init(bounds: pdfBounds, forType: .ink)

        self.page = page
    }
}
```

<div v-click="2">これは？</div>

---

## PDF座標系への変換

座標系をy軸方向に反転させる必要がある

図形が反転するわけではないことに注意

<div class="h-4/5">
  <img
    alt="Coordinate differences between PDF and UIView"
    src="/coordinates.svg"
    class="w-auto h-full mx-auto"
  />
</div>

---

## ドローイングを注釈として追加する

注釈の追加/更新時に`PDFAnnotation#draw()`が呼ばれる

```swift {*|5-10|12-13}
class CanvasPDFAnnotation: PDFAnnotation {
    override func draw(with box: PDFDisplayBox,in context: CGContext) {
        super.draw(with: box, in: context)

        UIGraphicsPushContext(context)
        context.saveGState()
        defer {
            context.restoreGState()
            UIGraphicsPopContext()
        }

        let image = drawing.image(from: drawing.bounds, scale: 1.0)
        context.draw(image.cgImage!, in: bounds)
    }
}
```

<!--
新しい注釈を追加したり、注釈の位置が変わったりするとPDFAnnotationのdrawメソッドが呼ばれます

ドローイングを注釈として追加するために、drawメソッドをoverrideします

まず、描画コンテキストをスタックに保存し、新しいコンテキストを設定します、メソッドの終了時にはコンテキストを抜ける処理も書いておきます

次に、drawingを画像に変換します。drawingのboundsに合わせてキャプチャします。

最後に、コンテキストに変換した画像を書き込みます。書き込むboundsはdrawingのものではなく、PDF用の座標系に変換したものを使うことに注意してください
-->

---

## ドローイングを注釈として追加する

```swift
let page = pdfView.currentPage
let canvasView = canvasView(for: page)

let annotation = CanvasPDFAnnotation(
    drawing: canvasView.drawing,
    page: page
)
page.addAnnotation(annotation)
```

<br/>

```swift
for stroke in canvasView.drawing.strokes {
    let annotation = CanvasPDFAnnotation(
        drawing: PKDrawing(strokes: [stroke]),
        page: page
    )
    page.addAnnotation(annotation)
}
```

<!--
実際に注釈を追加するコードを書いてみます

まず現在のページとページに対応するキャンバスを取得します

今回の例では各ページのドローイングをまとめて1つの注釈としています

PKDrawingにはひとつひとつの線をまとめて配列にしたstrokesというプロパティがあるので、注釈を分割したい場合はこれを使うのも検討してみてください
-->

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

## 注釈をファイルに保存する

`PDFDocument#dataRepresentation()`から`Data`を抽出

ファイルURLを指定し書き込む

```swift
let data = pdfDocument.dataRepresentation()
let documentURL = pdfDocument.documentURL

try data.write(to: documentURL)
```

---

## ✅ PencilKitのドローイングをPDF注釈として保存する

TODO: 保存機能を実装してデモを貼る

---

# Keynote

1. PencilKitとは？ ✅
2. PencilKitでアプリを作る ✅
3. PencilKitをPDFに組み込む ✅
4. PencilKitのドローイングをPDF注釈として保存する ✅
5. <span class="bg-yellow-2">PencilKitを使ってみた感想</span>

<div class="text-center my-8">
  <div>↓↓サンプルレポジトリ↓↓</div>
  <a href="https://github.com/ras0q/iosdc2024" class="font-bold">github.com/ras0q/iosdc2024</a>
</div>

---

## PencilKitを使ってみた感想

- Apple Pencilとの連携を数行のコードで組み込めるのはありがたい
- PDFKitとの連携が完全でない
  - 投げ縄ツールが使えない

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
