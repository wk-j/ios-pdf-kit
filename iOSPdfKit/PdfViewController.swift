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
    
    init(frame : CGRect, pdfDocument: PDFDocument) {
        super.init(frame : frame)
        let pdfView = PDFView(frame: frame)
        pdfView.document = pdfDocument
        addSubview(pdfView)
        
    }
}



class PdfViewController: UIViewController {
    var document: PDFDocument?
    
    
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
        button.frame = CGRect(x: self.view.frame.size.width - 60, y: 60, width: 50, height: 50)
        button.backgroundColor = UIColor.red
        button.setTitle("Name your Button ", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        show()
    }
    
    func show() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let logsPath = paths[0].appendingPathComponent("temp")
        do {
            try FileManager.default.createDirectory(at: logsPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        let source = document!.documentURL!
        let dest = logsPath.appendingPathComponent("xyz.pdf")
        
        do {
            
            try FileManager.default.copyItem(at: source, to: dest)
            let activityVC = UIActivityViewController(activityItems: [dest], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        catch {
            
        }
    }
}

