# [PencilKitで実装するPDFへの手書き注釈](https://fortee.jp/iosdc-japan-2024/proposal/c39177cc-63a3-46f6-a3e4-5be077839662)

iOSDC Japan 2024 Day2 Track B

Presenter: Ras (@ras0q)

このトークでは、PencilKitとPDFKitという2つのSwiftの標準ライブラリを使って、Apple Pencilを使ってPDFに注釈をするアプリの開発手順について解説します。

スライドは <https://ras0q.github.io/iosdc2024> から閲覧することができます。

## デモを実行する

このレポジトリにはトークで紹介するコードの完全版が含まれています。2種類のデモはそれぞれ以下のセクションに対応しています。

- `pencilkit-demo`: 「PencilKitでアプリを作る」
- `pencilkit-pdfkit-demo`: 「PencilKitをPDFに組み込む」、「PencilKitのドローイングをPDF注釈として保存する」

このレポジトリを`git clone`した後、以下のコマンドでワークスペースをXCode上で開きデモを実行することができます。

Apple Pencilを使うためには実機ビルドが必要です。

```bash
open iosdc2024-ras0q.xcworkspace
```
