---
theme: default
title: PencilKitで実装するPDFへの手書き注釈
titleTemplate: "[iOSDC Japan 2024] %s"
info: |
  このトークでは、PencilKitとPDFKitという2つのSwiftの標準ライブラリを使って、Apple Pencilを使ってPDFに注釈をするアプリの開発手順について解説します。

  - Repository: <https://github.com/ras0q/iosdc2024>
  - Slide: <https://ras0q.github.io/iosdc2024>
  - Proposal: <https://fortee.jp/iosdc-japan-2024/proposal/c39177cc-63a3-46f6-a3e4-5be077839662>
author: Ras (@ras0q)
keywords: iOSDC,iOSDC2024,iOSDC Japan 2024
download: /iosdc2024-ras0q-pencilkit.pdf
exportFilename: iosdc2024-ras0q-pencilkit
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

<!--
タイトル
-->

---
layout: section
---

# PDFに注釈がしたい！

<!--
PDFに注釈がしたい！
-->

---

# PDFに注釈がしたい！！！

- アプリの機能の1つとして注釈機能を組み込みたい
- 世のPDFアプリが絶妙にハマらないため自作したい
  - 複雑すぎる操作UI
  - ファイルのアクセス制限
  - 無限に現れる広告
  - など...

<div class="font-semibold text-center my-8">このトークを見ることでPDF注釈アプリがイチから作れるようになります!!!</div>

<!--
機能の例: 署名

TODO: この時点ではPDFに限らなくていいのでは？
-->

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
- キーノート、2と3でちょっと話が変わるよ
- 登場するコードは適宜省略しているので詳しく知りたかったらGitHubの完全版を見てね
- 右上にスライドのQRコードがあるよ
-->

---
layout: self-introduction
---

## 東京工業大学 大学院 修士1年

- 10月に大学が改名するらしい
- デジタル創作同好会traP
  - Web開発をメインに創作をしています
  - <a href="https://portfolio.trap.jp">traPortfolio</a> をリリースしました

## ピクシブ株式会社 アルバイト

- iOSアプリエンジニア育成プロジェクト
- pixiv / pixiv Sketch / Pastela
- iOSDC Japan 参加(3) 登壇(2)

<!--
- Ras (らす)
- Swiftの他にGoやTSを書く
- 東工大の修士1年
  - traPというサークルで活動している
  - 普段はモバイルアプリよりもWeb開発をしている
- ピクシブ株式会社で2,3年バイトしている
- iOSアプリエンジニア育成プロジェクトというプロジェクトに半年ほど参加した
  - 0からiOSアプリの開発手法を学んだ
  - pixiv insideに記事が上がっているので探して読んでね
- 社員の方々にもアドバイスを貰ってiOSDC3回中2回登壇できた
-->

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

<!--
- まずはPencilKitの紹介をします
-->

---
layout: section
---

# PencilKit?

<!--
- PencilKitを使ったことがある人〜〜〜〜？
-->

---

## PencilKit?

<div/>

<img
  alt="WWDC19で発表されたPencilKitのデモ画面"
  src="/pencilkit-wwdc19.png"
  class="w-3/5 h-auto mx-auto"
/>

<div class="text-sm text-right">引用元: WWDC19</div>

<!--
- ファイルアプリでマークアップを行っている画面
- 下の方にツールが置かれている
-->

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

<!--
- PencilKitは指やApple Pencilによるドローイングを画像としてアプリに組み込むことを可能にするSwiftの純正ライブラリ
- さっき見た描画ツールが使える
- ファイル以外にもメモや写真などで使われている
- PencilKitを使ったアプリ間で図形のコピペや移動といった連携ができる
-->

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

<!--
- 紹介が終わったところでPencilKitを実際に使ってみる
-->

---
layout: section
---

# try! PencilKit

in 1 minute

<!--
- 1分で実装するからこっち見て〜〜〜〜〜〜〜〜〜
-->

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
- UIKitで説明する
  - SwiftUIが使いたい場合はUIViewRepresentableを使ってね
- 基本のViewController
- PencilKitをimport、PKCanvasViewというViewを画面に追加する
  - 画面全体にキャンバスが広がる
- さっき紹介したツールキットはPKToolPickerとして提供されている
  - まず作ったcanvasViewを監視対象にする
  - canvasViewがFirstResponderになったときにツールを表示するようにする
    - FR: イベントを検知したときに一番最初に処理をするオブジェクト
  - 設定をしたのでcanvasViewをFRにして完成
-->

---

## ✅ PencilKitでアプリを作る

<SlidevVideo autoplay autoreset="slide" class="w-auto h-4/5 mx-auto my-8">
  <source src="/pencilkit-in1min.mp4" type="video/mp4">
</SlidevVideo>

<!--
- 完成！
- 20行弱のコードでお絵かきアプリを作ることができる
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

<!--
- 話題が変わるので脳みそシャッフルタイム
-->

---
layout: section
---

# try! PDF Integration

<!--
- PDF上でPencilKitを使ってみます
-->

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

<!--
- 先ほどと同じく基本のViewController
- PDFを扱うためのパッケージであるPDFKitをimportする
  - ファイルのURLを指定してPDFDocumentクラスを作成する
- PDFDocumentを元にPDFViewを作成する
  - これを画面に追加することで画面にPDFが現れる

TODO: PDF出すだけのデモもほしい
-->

---
layout: center
---

## どうやってPencilKitを組み込む？

<!--
- PencilKitを組み込む解決策は次のページに！
-->

---
title: What's new in PDFKit (WWDC22)
layout: image
image: /pdfkit-wwdc22-1.png
---

<!--
WWDC 2022でPDFKitに新たな機能が追加された
-->

---
title: How can I draw on PDF pages using PencilKit?
layout: image
image: /pdfkit-wwdc22-2.png
---

<!--
- PDF EngineerのConrad Carlen
- PencilKitでPDFのページに書き込みを行うには？
-->

---
title: the answer is to use an overlay view.
layout: image
image: /pdfkit-wwdc22-3.png
---

<!--
- 解決策はOverlay view使うことだ
-->

---
title: PDFPageOvelayViewProvider
layout: image
image: /pdfkit-wwdc22-4.png
backgroundSize: contain
---

<!--
- PDFの上にViewを被せることを目的として、iOS16からPDFPageOverlayViewProviderが登場
-->

---

## PDFPageOverlayViewProvider

````md magic-move
```swift
class ViewController: UIViewController {
    private lazy var pdfView: PDFView = {
        let view = PDFView(frame: view.frame)
        view.document = pdfDocument
        return view
    }()
}
```

```swift {5,10-13}
class ViewController: UIViewController {
    private lazy var pdfView: PDFView = {
        let view = PDFView(frame: view.frame)
        view.document = pdfDocument
        view.pageOverlayViewProvider = self
        return view
    }()
}

extension ViewController: PDFPageOverlayViewProvider {
    func pdfView(_: PDFView, overlayViewFor page: PDFPage) -> UIView? {
    }
}
```

```swift {8-11,16-17|*}
class ViewController: UIViewController {
    private lazy var pdfView: PDFView = {
        let view = PDFView(frame: view.frame)
        view.document = pdfDocument
        view.pageOverlayViewProvider = self
        return view
    }()
    // 各ページに被せるキャンバスを作成
    private lazy var canvasViews = (0..<ページ数).map { _ in
        PKCanvasView()
    }
}

extension ViewController: PDFPageOverlayViewProvider {
    func pdfView(_: PDFView, overlayViewFor page: PDFPage) -> UIView? {
        // ページ数に対応するキャンバスを返す
        canvasViews[page.ページ番号]
    }
}
```
````

<!--
- ページ数分のPKCanvasViewを用意
- PDFPageOverlayViewProviderのpdfViewメソッドで各ページのCanvasを返すようにする
-->

---

## 描画ツールも設定する

````md magic-move
```swift
class ViewController: UIViewController {
    private lazy var pdfView: PDFView = ...
    private lazy var canvasViews = ...

    override func viewDidLoad() {
        // PDFViewの設定...
    }
}
```

```swift {8-9}
class ViewController: UIViewController {
    private lazy var pdfView: PDFView = ...
    private lazy var canvasViews = ...

    override func viewDidLoad() {
        // PDFViewの設定...

        for canvasView in canvasViews {
        }
    }
}
```

```swift {4,10,13-15}
class ViewController: UIViewController {
    private lazy var pdfView: PDFView = ...
    private lazy var canvasViews = ...
    private lazy var toolPicker = PKToolPicker()

    override func viewDidLoad() {
        // PDFViewの設定...

        for canvasView in canvasViews {
          toolPicker.addObserver(canvasView)
        }

        // 今回のfirst responderはPDFView
        toolPicker.setVisible(true, forFirstResponder: pdfView)
        pdfView.becomeFirstResponder()
    }
}
```

```swift {11|*}
class ViewController: UIViewController {
    private lazy var pdfView: PDFView = ...
    private lazy var canvasViews = ...
    private lazy var toolPicker = PKToolPicker()

    override func viewDidLoad() {
        // PDFViewの設定...

        for canvasView in canvasViews {
          toolPicker.addObserver(canvasView)
          pdfView.addGestureRecognizer(canvasView.drawingGestureRecognizer)
        }

        // 今回のfirst responderはPDFView
        toolPicker.setVisible(true, forFirstResponder: pdfView)
        pdfView.becomeFirstResponder()
    }
}
```
````

<!--
- 描画ツールも設定する
- 今の続きから
- 各キャンバスに対して繰り返し処理を行う
- PKToolPickerを使う
  - キャンバスを監視対象にする
  - PDFViewがFRになったときにツールを表示するようにする
- 最後にキャンバスのドローイング認識をPDFViewに追加する
-->

---

## 完成？

<!-- TODO: デモを貼る -->

---

## 複数のRecognizerを設定した結果...

<div/>

最後に追加したRecognizerしか発火しない

<div class="h-4/5 flex items-center">
  <img
    alt="最後に追加したdrawingGestureRecognizerのみが発火してしまう"
    src="/drawingGestureRecognizer-issue.svg"
    class="w-full h-auto mx-auto"
  />
</div>

---

## 複数のRecognizerを設定した結果...

<div/>

タップ時に該当ページのRecognizerのみを適切に発火させる必要がある

<div class="h-4/5 flex items-center">
  <img
    alt="タップ時にdrawingGestureRecognizerを適切に制御する"
    src="/drawingGestureRecognizer-resolve.svg"
    class="w-full h-auto mx-auto"
  />
</div>

---

## Override `func hitTest(_:with:)`

タップしたページのキャンバスのRecognizerのみを有効化させる

````md magic-move
```swift
class CanvasPDFView: PDFView {
    override func hitTest(_ point:CGPoint,with e:UIEvent?) -> UIView? {
        return super.hitTest(point, with: e)
    }
}
```

```swift {3-4}
class CanvasPDFView: PDFView {
    override func hitTest(_ point:CGPoint,with e:UIEvent?) -> UIView? {
        if let activePage = page(for: point, nearest: true) {
        }

        return super.hitTest(point, with: e)
    }
}
```

```swift {1-3,6,10}
protocol CanvasPDFViewDelegate: AnyObject {
    func switchActivePage(to page: PDFPage)
}

class CanvasPDFView: PDFView {
    var interactionDelegate: (any CanvasPDFViewDelegate)?

    override func hitTest(_ point:CGPoint,with e:UIEvent?) -> UIView? {
        if let activePage = page(for: point, nearest: true) {
            interactionDelegate?.switchActivePage(to: activePage)
        }

        return super.hitTest(point, with: e)
    }
}
```
````

---

## ViewController側でRecognizerを切り替える

````md magic-move
```swift
class ViewController: UIViewController {
    private lazy var pdfView: PDFView = {
        let view = PDFView(frame: view.frame)
        view.document = pdfDocument
        view.pageOverlayViewProvider = self
        return view
    }()
}
```

```swift
class ViewController: UIViewController {
    private lazy var pdfView: CanvasPDFView = {
        let view = PDFView(frame: view.frame)
        view.document = pdfDocument
        view.pageOverlayViewProvider = self
        return view
    }()
}
```

```swift {6,11-}
class ViewController: UIViewController {
    private lazy var pdfView: CanvasPDFView = {
        let view = PDFView(frame: view.frame)
        view.document = pdfDocument
        view.pageOverlayViewProvider = self
        view.interactionDelegate = self
        return view
    }()
}

extension ViewController: CanvasPDFViewDelegate {
    func switchActivePage(to page: PDFPage) {
        let activeCanvasView = canvasView[page.ページ番号]
        for canvasView in canvasViews {
            let isActiveView = (canvasView == activeCanvasView)
            canvasView.drawingGestureRecognizer.isEnabled = isActiveView
        }
    }
}
```
````

---

## ✅ PencilKitをPDFに組み込む

<SlidevVideo autoplay autoreset="slide" class="w-auto h-4/5 mx-auto my-8">
  <source src="/with-pdfkit.mp4" type="video/mp4">
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

// TODO: ココ座標変わってね？

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

````md magic-move
```swift
class CanvasPDFAnnotation: PDFAnnotation {
    override func draw(with box: PDFDisplayBox,in context: CGContext) {
        super.draw(with: box, in: context)
    }
}
```

```swift {5-10}
class CanvasPDFAnnotation: PDFAnnotation {
    override func draw(with box: PDFDisplayBox,in context: CGContext) {
        super.draw(with: box, in: context)

        UIGraphicsPushContext(context)
        context.saveGState()
        defer {
            context.restoreGState()
            UIGraphicsPopContext()
        }
    }
}
```

```swift {12-13|*}
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
````

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

上の例では、各ページのドローイングをまとめて1つの注釈としています

下の例では、PKDrawingにはひとつひとつの線をまとめて配列にしたstrokesというプロパティを使っています
注釈を分割したい場合はこれを使うのも検討してみてください
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

<SlidevVideo autoplay autoreset="slide" class="w-auto h-4/5 mx-auto my-8">
  <source src="/annotation-demo.mp4" type="video/mp4">
</SlidevVideo>

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

// TODO: 詳しく

---
layout: end
---

# ありがとうございました！

<div/>

[サンプルレポジトリ](https://github.com/ras0q/iosdc2024) も是非ご覧ください！

<QRCode value="https://github.com/ras0q/iosdc2024" width="150" height="150" class="mx-auto" />

Presenter: Ras (@ras0q [<ri-twitter-x-fill />](https://x.com/ras0q) [<ri-github-fill />](https://github.com/ras0q))

---

## References

- [PencilKit | Apple Developer Documentation](https://developer.apple.com/documentation/pencilkit)
- [PDFKit | Apple Developer Documentation](https://developer.apple.com/documentation/pdfkit)
- [What's new in PDFKit - WWDC22 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2022/10089/)
- [iOSのPDFKitを利用してPDFを編集する | Zenn](https://zenn.dev/cookiezby/articles/38a7c23dd15706)
