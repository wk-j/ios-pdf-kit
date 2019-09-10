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


class PdfView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame : CGRect) {
        //super.init(frame : frame)
        super.init(frame: frame)
        
        let url = Bundle.main.url(forResource: "tesla", withExtension: "pdf")
        guard let x = url else {
            return;
        }
        
        let pdfView = PDFView(frame: frame)
        let pdfDocument = PDFDocument(url: x)
        pdfView.document = pdfDocument
        addSubview(pdfView)
    }
}


class PdfViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let pdf = PdfView(frame: UIScreen.main.bounds)
        self.view.addSubview(pdf)
    }
}

