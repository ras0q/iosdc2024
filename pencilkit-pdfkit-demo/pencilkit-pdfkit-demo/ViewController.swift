import PDFKit
import PencilKit
import UIKit

class ViewController: UIViewController {
    private lazy var pdfView: PDFView = {
        let view = CanvasPDFView(frame: view.frame)
        view.interactionDelegate = self
        view.pageOverlayViewProvider = self
        view.autoScales = true
        view.displaysPageBreaks = true
        view.document = pdfDocument
        return view
    }()

    private lazy var pdfDocument = PDFDocument(
        url: Bundle.main.url(forResource: "sample", withExtension: "pdf")!
    )!

    // If you use pdfview.document, this line causes a circular reference.
    private lazy var canvasViews: [PKCanvasView] = (0 ..< pdfDocument.pageCount).map { _ in
        let view = PKCanvasView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }

    private lazy var toolPicker = PKToolPicker()

    private lazy var menuButton: UIButton = {
        let button = UIButton(
            frame: CGRect(x: 48, y: 48, width: 64, height: 64)
        )
        button.configuration = menuButtonConfiguration
        button.showsMenuAsPrimaryAction = true
        button.menu = UIMenu(
            children: [
                UIAction(title: "Show ToolPicker") { _ in
                    self.pdfView.becomeFirstResponder()
                },
                UIAction(title: "Annotate CanvasView drawing") { _ in
                    self.annotateCanvasViewDrawing()
                    self.showResult(isSuccess: true)
                },
                UIAction(title: "Save annotations to PDF") { _ in
                    do {
                        try self.saveAnnotationsToPDF()
                        self.showResult(isSuccess: true)
                    } catch {
                        self.showResult(isSuccess: false)
                    }
                },
            ]
        )
        return button
    }()

    private lazy var menuButtonConfiguration: UIButton.Configuration = {
        var configuration: UIButton.Configuration = .filled()
        configuration.baseBackgroundColor = .lightGray
        configuration.image = UIImage(systemName: "line.3.horizontal")
        return configuration
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pdfView)
        view.addSubview(menuButton)

        for canvasView in canvasViews {
            pdfView.addGestureRecognizer(canvasView.drawingGestureRecognizer)
            toolPicker.addObserver(canvasView)
        }

        toolPicker.setVisible(true, forFirstResponder: pdfView)
        pdfView.becomeFirstResponder()
    }

    private func canvasView(for page: PDFPage) -> PKCanvasView? {
        guard let pageNumber = page.pageRef?.pageNumber, pageNumber <= canvasViews.count else {
            return nil
        }

        return canvasViews[pageNumber - 1]
    }

    private func showResult(isSuccess: Bool) {
        var resultConfiguration: UIButton.Configuration = .filled()
        resultConfiguration.baseBackgroundColor = isSuccess ? .systemGreen : .systemRed
        resultConfiguration.image = UIImage(
            systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill"
        )
        menuButton.configuration = resultConfiguration

        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            menuButton.configuration = menuButtonConfiguration
        }
    }

    private func annotateCanvasViewDrawing() {
        guard let page = pdfView.currentPage, let canvasView = canvasView(for: page) else {
            return
        }

        let existingAnnotations = page.annotations.filter { $0 is CanvasPDFAnnotation }
        for annotation in existingAnnotations {
            page.removeAnnotation(annotation)
        }

        let annotation = CanvasPDFAnnotation(drawing: canvasView.drawing, page: page)
        page.addAnnotation(annotation)
    }

    private func saveAnnotationsToPDF() throws {
        guard let data = pdfDocument.dataRepresentation(), let documentURL = pdfDocument.documentURL else {
            return
        }

        try data.write(to: documentURL)
    }
}

extension ViewController: CanvasPDFViewDelegate {
    func switchActivePage(to page: PDFPage) {
        guard let activeCanvasView = canvasView(for: page) else {
            return
        }

        for canvasView in canvasViews {
            canvasView.drawingGestureRecognizer.isEnabled = (canvasView == activeCanvasView)
        }
    }
}

extension ViewController: PDFPageOverlayViewProvider {
    func pdfView(_: PDFView, overlayViewFor page: PDFPage) -> UIView? {
        canvasView(for: page)
    }
}

// MARK: - CanvasPDFView

protocol CanvasPDFViewDelegate: AnyObject {
    func switchActivePage(to page: PDFPage)
}

class CanvasPDFView: PDFView {
    var interactionDelegate: (any CanvasPDFViewDelegate)?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let activePage = page(for: point, nearest: true) {
            interactionDelegate?.switchActivePage(to: activePage)
        }

        return super.hitTest(point, with: event)
    }
}

// MARK: - CanvasPDFAnnotation

class CanvasPDFAnnotation: PDFAnnotation {
    private let drawing: PKDrawing

    init(drawing: PKDrawing, page: PDFPage) {
        self.drawing = drawing

        // Convert bounds
        // from the UIView coordinate system (origin at the top-left)
        // to the PDF coordinate system (origin at the bottom-left)
        var pdfBounds = drawing.bounds
        pdfBounds.origin.y = page.bounds(for: .mediaBox).height - pdfBounds.origin.y - pdfBounds.height
        super.init(bounds: pdfBounds, forType: .ink, withProperties: nil)

        self.page = page
    }

    @available(*, unavailable) required init?(coder _: NSCoder) { fatalError() }

    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        super.draw(with: box, in: context)

        UIGraphicsPushContext(context)
        context.saveGState()
        defer {
            context.restoreGState()
            UIGraphicsPopContext()
        }

        // Using smaller `scale` reduces resolution.
        guard let cgImage = drawing.image(from: drawing.bounds, scale: 1.0).cgImage else {
            return
        }

        context.draw(cgImage, in: bounds)
    }
}
