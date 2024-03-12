//
//  CameraScannerViewController.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 27.02.2024.
//

import SwiftUI
import UIKit
import VisionKit

struct CameraScannerViewController: UIViewControllerRepresentable {
    
    @Binding var startScanning: Bool
    @Binding var scanResult: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let viewController = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .fast,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isHighlightingEnabled: true)
        
        viewController.delegate = context.coordinator

        return viewController
    }
    
    func updateUIViewController(_ viewController: DataScannerViewController, context: Context) {
        if startScanning {
            try? viewController.startScanning()
        } else {
            viewController.stopScanning()
        }
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: CameraScannerViewController
        init(_ parent: CameraScannerViewController) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                if let range = text.transcript.range(of: "\\d+[.,]00", options: .regularExpression) {
                    let scannedNumber = String(text.transcript[range])
                    parent.scanResult = String(scannedNumber.dropLast(3))
                }
            default:
                break
            }
        }
    }
}
