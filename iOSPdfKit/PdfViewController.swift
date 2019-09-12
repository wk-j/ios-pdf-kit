//
//  PdfViewController.swift
//  iOSPdfKit
//
//  Created by wk on 10/9/2562 BE.
//  Copyright © 2562 wk. All rights reserved.
//

import Foundation
import UIKit
import PDFKit
import QuickLook


class PdfView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(frame : CGRect, pdfDocument: PDFDocument) {
        super.init(frame : frame)
        let pdfView = PDFView(frame: frame)
        pdfView.document = pdfDocument
        addSubview(pdfView)

    }
}

extension PdfViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {

        return self.previewItem as QLPreviewItem
    }
}




class PdfViewController: UIViewController {
    var document: PDFDocument?

    lazy var previewItem = NSURL()


    override func viewDidLoad() {
        super.viewDidLoad()

        let url = Bundle.main.url(forResource: "tesla", withExtension: "pdf")
        guard let x = url else {
            return;
        }

        let document = PDFDocument(url: x)

        let pdf = PdfView(frame: UIScreen.main.bounds, pdfDocument: document!)
        self.view.addSubview(pdf)

        self.document = document

        setupButton()
    }

    func setupButton() {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.frame = CGRect(x: self.view.frame.size.width - 60, y: 60, width: 50, height: 50)
        button.backgroundColor = UIColor.red
        button.setTitle("PDF", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
    }

    @objc func buttonAction(sender: UIButton!) {
        show()
//        writePdf()
//        quickLook()
    }

    func quickLook() {

        let previewController = QLPreviewController()

        let url = document?.documentURL
        guard let x = url else { return }

        previewItem = NSURL(fileURLWithPath: x.relativePath)

        previewController.dataSource = self
        self.present(previewController, animated: true, completion: nil)

    }

    func writePdf() {
        let pdfDoc = document?.dataRepresentation()!
        // let temp = getTempPath()
        let temp = getDocumentDir()
        let dest = temp.appendingPathComponent("abc.pdf")
        FileManager.default.createFile(atPath: dest.relativePath,  contents: pdfDoc as Data?, attributes: nil)
    }

    func getTempPath() -> URL {

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let logsPath = paths[0].appendingPathComponent("temp")
        return logsPath
    }

    func getDocumentDir() -> URL {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return getTempPath() }
        return dir
    }


    func show() {

        let dir = getDocumentDir()
        let source = document!.documentURL!
        let dest = dir.appendingPathComponent("xyz.pdf")

        print(dest)

        do {

            if !FileManager.default.fileExists(atPath: dest.relativePath) {
                try FileManager.default.copyItem(at: source, to: dest)
            }

            let activityVC = UIActivityViewController(activityItems: [dest], applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)

        }
        catch {

        }
    }
}

