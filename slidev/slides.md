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

---
layout: section
---

# Apple Pencilを活用した<br/>iOSアプリを作りたい！

---

# Apple Pencilを活用したiOSアプリを作りたい！

- アプリの機能の1つとして手書きの描画機能を実装したい
  - お絵かき
  - 手書きメモ
- 世の中のPDF注釈アプリが需要にマッチしないため自作したい
  - 複雑すぎる操作UI
  - ファイルのアクセス制限
  - 無限に現れる広告
  - など...

<div class="font-semibold text-center my-8">このトークを見ることでApple Pencilを一層活用できるようになります！！！</div>

<!--
**~1:10 くらい**
-->

---

# Keynote

1. PencilKitとは？
2. PencilKitでアプリを作る
3. PDFに描画する
4. 描画をPDF注釈として保存する
5. PencilKitを使ってみた感想

<div class="text-center my-8">
  <div>↓↓サンプルレポジトリ↓↓</div>
  <a href="https://github.com/ras0q/iosdc2024" class="font-bold">github.com/ras0q/iosdc2024</a>
</div>

<Comment>
  <PoweredBySlidev />
</Comment>

<!--
**~ 2:30**

- PencilKitの紹介
- PencilKitの実装
- 3から本題、PDFに手書きの描画を実装する
- 描画をPDF注釈として反映し、保存する

- 本トークで登場するコードは適宜省略しているのでGitHubを見てね
- 右上にスライドへのQRコードがあるよ
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
**~3:30**

- Ras (らす)
- Swiftの他にGoやTSを書く
- 東工大の修士1年
  - traPというサークルで活動している
  - 普段はモバイルアプリよりもWeb開発をしている
- ピクシブ株式会社で2,3年バイトしている
- iOSアプリエンジニア育成プロジェクトに参加した
  - 0からiOSアプリの開発手法を学んだ
  - pixiv insideに記事が上がっているので読んでね
- 様々な方の協力のおかげで、iOSDC3回中2回登壇できた
-->

---

# Keynote

1. <span class="bg-yellow-2">PencilKitとは</span>
2. PencilKitでアプリを作る
3. PDFに描画する
4. 描画をPDF注釈として保存する
5. PencilKitを使ってみた感想

<div class="text-center my-8">
  <div>↓↓サンプルレポジトリ↓↓</div>
  <a href="https://github.com/ras0q/iosdc2024" class="font-bold">github.com/ras0q/iosdc2024</a>
</div>

<!--
- 早速PencilKitの紹介に入ります
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
- 太い文字や細い文字が書かれている
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
**~5:00**

- PencilKitは指やApple Pencilによるドローイングを画像としてアプリに組み込むことを可能にするApple標準ライブラリ
- さっき見た描画ツールが使える
- ファイル以外にもメモや写真などで使われている
- 投げ縄ツールなどを使うことで、PencilKitを使ったアプリ間で図形のコピペや移動といった連携ができる
-->

---

# Keynote

1. PencilKitとは？ ✅
2. <span class="bg-yellow-2">PencilKitでアプリを作る</span>
3. PDFに描画する
4. 描画をPDF注釈として保存する
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
**~6:00**

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
  <source src="/demo-pencilkit.mp4" type="video/mp4">
</SlidevVideo>

<!--
- 完成！
- 20行弱のコードでお絵かきアプリを作ることができる
-->

---

# Keynote

1. PencilKitとは？ ✅
2. PencilKitでアプリを作る ✅
3. <span class="bg-yellow-2">PDFに描画する</span>
4. 描画をPDF注釈として保存する
5. PencilKitを使ってみた感想

<div class="text-center my-8">
  <div>↓↓サンプルレポジトリ↓↓</div>
  <a href="https://github.com/ras0q/iosdc2024" class="font-bold">github.com/ras0q/iosdc2024</a>
</div>

<!--
- ここからはタイトルにもある通りPencilKitを使ってPDFに描画していく
- 話題が変わるので脳みそリセットタイム
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
  - ファイルのURLを指定してPDFDocumentのインスタンスを生成する
- PDFDocumentを元にPDFViewを作成する
  - これを画面に追加することで画面にPDFが現れる
-->

---

## ✅ 画面にPDFを表示する

<SlidevVideo autoplay autoreset="slide" class="w-auto h-4/5 mx-auto my-8">
  <source src="/demo-pdfkit.mp4" type="video/mp4">
</SlidevVideo>

---
layout: center
---

## PencilKitを使ってPDFに描画できるようにするには？

<!--
- PDFは表示できた
- PDFに描画を行うにはどうすればよいか？
- 答えは次のページに！
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
- 解決策はOverlay view使うこと
-->

---
title: PDFPageOvelayViewProvider
layout: image
image: /pdfkit-wwdc22-4.png
backgroundSize: contain
---

<!--
- PDFの上にViewを重ねて表示することを目的として、iOS16からPDFPageOverlayViewProviderが追加
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
- 先ほどPDFViewを追加したViewControllerにPDFPageOverlayViewProviderを実装する
  - pdfView()メソッドを追加
- ページ数分のキャンバスを作成し、各ページに対応するキャンバスを返すようにする
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

```swift {4,8-15}
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
**~10:00**

- 描画ツールも設定する
- 今の続きから
- PKToolPickerのインスタンスを生成する
  - 各ページのキャンバスを監視対象にする
  - PDFViewがFRになったときにツールを表示するようにする
- 最後にキャンバスの描画認識をPDFViewに追加する
-->

---

## ❓ PDFに (完成...？)

最後のページにしか描画できない (動画は上のページにも描こうとしています)

WARNING: "Drawing did change that is not in text."

<SlidevVideo autoplay autoreset="slide" class="w-auto h-4/5 mx-auto my-4">
  <source src="/demo-pdfkit-recognizer-bug.mp4" type="video/mp4">
</SlidevVideo>

<!--
- これで完成？かと思いきや
- 最後のページにしか描画できない問題が発生
-->

---

## ❓ PDFに描画する (完成...？)

最後のページにしか描画できない (動画は上のページにも描こうとしています)

WARNING: "Drawing did change that is not in text."

<div class="grid grid-cols-[40%_1fr]">

<SlidevVideo autoplay autoreset="slide" class="w-auto h-4/5 mx-auto mt-4">
  <source src="/demo-pdfkit-recognizer-bug.mp4" type="video/mp4">
</SlidevVideo>

<div class="">

`pdfView.addGestureRecognizer(...)`

1. Recognizerの認識範囲はPDFView全体
2. 複数追加されたRecognizerの範囲が重複する
3. 最後に追加されたRecognizerのみが発火する

→ 最後のページしか正常に認識されない😭

</div>

</div>

<div v-click class="text-center font-semibold">→ 描画ごとに発火させるRecognizerを切り替える必要がある</div>

<!--
**~11:00**

- 原因は有効になっているRecognizerが複数存在していること
- PDFViewに対してRecognizerを追加したため、認識範囲はPDFView全体 (全ページ) に渡っている
- Recognizerが複数追加されたことで認識範囲が重複している
- 最後に追加されたRecognizerのみが発火する
- 最後のページでしか正しいRecognizerが正常に認識されず描画されない
- 対策として、タップごとに有効なRecognizerを切り替えて、1つのみが動くようにする
-->

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

<!--
- hitTest(): Viewがタップされる際に対象となるViewを決めるメソッド
- PDFViewを継承したCanvasPDFViewを作成
- page(): タップされた座標からページを特定する
- Delegateを作成してViewControllerにRecognizerの切り替えを任せる
-->

---

## ViewController側で有効なRecognizerを切り替える

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

<!--
- PDFViewをCanvasPDFViewに変更する
- 有効なRecognizerを設定する処理を実装し、Delegateに設定する
-->

---

## ✅ PDFに描画する

<SlidevVideo autoplay autoreset="slide" class="w-auto h-4/5 mx-auto my-8">
  <source src="/demo-pencilkit-pdfkit.mp4" type="video/mp4">
</SlidevVideo>

<!--
**~13:00**

- 無事PencilKitを使ってPDFに描画することができるように
-->

---

# Keynote

1. PencilKitとは？ ✅
2. PencilKitでアプリを作る ✅
3. PDFに描画する ✅
4. <span class="bg-yellow-2">描画をPDF注釈として保存する</span>
5. PencilKitを使ってみた感想

<div class="text-center my-8">
  <div>↓↓サンプルレポジトリ↓↓</div>
  <a href="https://github.com/ras0q/iosdc2024" class="font-bold">github.com/ras0q/iosdc2024</a>
</div>

<!--
- PencilKitを使ってPDFに描画することができた
- これをPDF注釈としてファイルに保存するまでの実装を行う
-->

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

<!--
- 元のPDFファイルからPDFViewを作成しPKCanvasViewを重ねた
- PKCanvasViewは重ねているだけなので実際のPDFViewには描画が反映されていない
- 注釈として反映させる
-->

---

## 注釈用クラスのイニシャライザ

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

<!--
- PDFAnnotationは注釈を表すクラス
- PKDrawingはキャンバスから取れる描画
- 描画をPDFAnnotationに反映するためにクラスを継承
- イニシャライザを見るとboundsが複雑
- これは何をしているのか？
-->

---

## View Coordinates → PDF Coordinates

<div class="grid grid-cols-2 mt-8 gap-4">

<div>

座標系をy軸反転させる必要がある

- boundsの基準点も変わる
- 図形が反転するわけではない

</div>

<div class="h-full">
  <img
    alt="Coordinate differences between PDF and UIView"
    src="/coordinates.svg"
    class="w-auto h-full mx-auto"
  />
</div>

</div>

<!--
- Viewの座標系では原点が左上
- PDFの座標系では原点が左下
- 変換が必要
- 原点から最も近い点も変わるのでboundsの基準が変わる
-->

---

## 再掲: 注釈用クラスのイニシャライザ

```swift {7-10}
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

<!--
- 座標系の変換をしていることが理解できる
-->

---

## キャンバスの描画を注釈として追加する

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

```swift {12}
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
    }
}
```

```swift {13|*}
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
        context.draw(image.cgImage!, in: bounds) // PDF座標系のbounds
    }
}
```
````

<!--
- 注釈が追加/更新されるとPDFAnnotation#draw()が呼ばれる
- overrideしてキャンバスの描画を注釈として追加する
- 引数のコンテキストをCurrentContextに設定する
- キャンバスの描画から画像を生成する
- コンテキストを通して変換したPDF座標系のboundsに注釈を追加する
-->

---

## PDF注釈の使用例

ページ全体の描画を1つの注釈に

```swift
let annotation = CanvasPDFAnnotation(
    drawing: canvasView.drawing,
    page: page
)
page.addAnnotation(annotation)
```

各ストロークの描画をそれぞれの注釈に

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
- 使用例
- canvasView.drawingをそのまま使うと1ページに描かれた図形が1つの注釈として追加される
- ストロークに分けて注釈を追加することもできる
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

<!--
- キャンバスの描画をPDF注釈として追加することができた
- 最後にファイルシステム上のPDFファイルに注釈を保存する
-->

---

## 注釈をファイルに保存する

`PDFDocument#dataRepresentation()`から`Data`を抽出

ファイルURLを指定し書き込む

```swift
let data = pdfDocument.dataRepresentation()
let documentURL = pdfDocument.documentURL

try data.write(to: documentURL)
```

<!--
- PDFDocumentからデータ表現を取り出す
- ファイルURLに対して書き込む
-->

---

## ✅ 描画をPDF注釈として保存する

<SlidevVideo autoplay autoreset="slide" class="w-auto h-4/5 mx-auto my-8">
  <source src="/demo-pdfkit-annotation.mp4" type="video/mp4">
</SlidevVideo>

<!--
**~ 18:30**

- キャンバスの描画をPDF注釈として追加する
- 保存するとファイルアプリ上でも反映されている
-->

---

# Keynote

1. PencilKitとは？ ✅
2. PencilKitでアプリを作る ✅
3. PDFに描画する ✅
4. 描画をPDF注釈として保存する ✅
5. <span class="bg-yellow-2">PencilKitを使ってみた感想</span>

<div class="text-center my-8">
  <div>↓↓サンプルレポジトリ↓↓</div>
  <a href="https://github.com/ras0q/iosdc2024" class="font-bold">github.com/ras0q/iosdc2024</a>
</div>

---

## PencilKitを使ってみた感想

<div class="grid grid-cols-[1fr_25%] gap-4">

<div class="text-size-xl">

- 自作だと大変なところを公式で提供してくれているのはありがたい
  - 数行のコードで低遅延の描画認識を描くことができる
  - 感度認識など
- PencilKitをViewの一部として加える場面では問題なく使えそう
- 一方PDFKit (`PDFPageOvelayViewProvider`) との連携が難しい
  - 投げ縄ツールが現状使えない
  - 定規が全ページに出現する
    - toolPickerをページ数分用意したら治るかも...？
    - そうするとツールの同期ができなくなるのでは...？

</div>

<div>
  <img
    alt="multi rulers"
    src="/multi-rulers.png"
    class="w-auto h-full"
  />
</div>

</div>

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
