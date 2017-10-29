//
//  ViewController.swift
//  QRCode-Example
//
//  Created by Hans Knöchel on 09.06.17.
//  Copyright © 2017 Hans Knoechel. All rights reserved.
//

import UIKit
import Vision
import AVKit
import SnapKit
import Alamofire

class QRcodeReaderVC: UIViewController {

    var previewView = VideoPreviewView()
    let btn = UIButton()

    let label = UILabel()
    let backBtn: UIButton = {
        let btn = UIButton()
        let iv = UIImageView()
        iv.image = UIImage(named: "batsu")
        btn.addSubview(iv)
        iv.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.centerX.centerY.equalToSuperview()
        }
        return btn
    }()
    
    var captureSession: AVCaptureSession!

    var capturePhotoOutput: AVCapturePhotoOutput!

    var isCaptureSessionConfigured = false

    private func configureCaptureSession() {

        guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Unable to find capture device")
            return
        }

        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            print("Unable to obtain video input")
            return
        }

        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput.isHighResolutionCaptureEnabled = true
        capturePhotoOutput.isLivePhotoCaptureEnabled = capturePhotoOutput.isLivePhotoCaptureSupported

        guard captureSession.canAddInput(videoInput) else {
            print("Unable to add input")
            return
        }

        guard captureSession.canAddOutput(capturePhotoOutput) else {
            print("Unable to add output")
            return
        }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        captureSession.addInput(videoInput)
        captureSession.addOutput(capturePhotoOutput)
        captureSession.commitConfiguration()
    }

    @objc private func snapPhoto() {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        let videoPreviewLayerOrientation = previewView.videoPreviewLayer.connection!.videoOrientation

        if let photoOutputConnection = capturePhotoOutput.connection(with: AVMediaType.video) {
        photoOutputConnection.videoOrientation = videoPreviewLayerOrientation
        }

        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto

        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    private func scanImage(cgImage: CGImage) {
        let barcodeRequest = VNDetectBarcodesRequest(completionHandler: {(request, error) in
            self.reportResults(results: request.results)
        })

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [.properties : ""])

        guard let _ = try? handler.perform([barcodeRequest]) else {
            return print("Could not perform barcode-request!")
        }
    }

    private func reportResults(results: [Any]?) {
        // Loop through the found results
        print("Barcode observation")
        var url = ""
        var color = ""
        
        if results == nil {
        print("No results found.")
        } else {
            print("Number of results found: \(results!.count)")
            for result in results! {

                // Cast the result to a barcode-observation
                if let barcode = result as? VNBarcodeObservation {

                    if let payload = barcode.payloadStringValue {
                        
                        let result = payload.characters.index(of: ",")
                        let index = payload.index(after: result!)
                        if let theRange = result {
                            url = "\(payload[..<theRange])"
                            color = "\(payload[index...])"
                        } else {
                            Alert.show(with: "形式が違います")
                        }
                        
                        let alert: UIAlertController = UIAlertController(title: color, message: "", preferredStyle:  UIAlertControllerStyle.alert)
                        let defaultAction: UIAlertAction = UIAlertAction(title: "join", style: UIAlertActionStyle.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                            let nv = WatingVC(url, color)
                            self.navigationController?.pushViewController(nv, animated: true)
                        })

                        alert.addAction(defaultAction)
                        
                        present(alert, animated: true, completion: nil)
                        print("Payload: \(payload)")
                    }

                    // Print barcode-values
                    print("Symbology: \(barcode.symbology.rawValue)")

                        if let desc = barcode.barcodeDescriptor as? CIQRCodeDescriptor {
                            let content = String(data: desc.errorCorrectedPayload, encoding: .utf8)

                            // FIXME: This currently returns nil. I did not find any docs on how to encode the data properly so far.
                            print("Payload: \(String(describing: content))")
                            print("Error-Correction-Level: \(desc.errorCorrectionLevel)")
                            print("Symbol-Version: \(desc.symbolVersion)")
                        }
                }
            }
        }
    }
}

// MARK: UIViewControllerDelegate

extension QRcodeReaderVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        self.view.addSubview(previewView)
        label.text = "タップして読みとってね！"
        previewView.addSubview(label)
        previewView.addSubview(btn)
        btn.addTarget(self, action: #selector(snapPhoto), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backDidTap), for: .touchUpInside)

        previewView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        btn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(40)
            $0.width.equalTo(200)
        }

        captureSession = AVCaptureSession()
        print(captureSession)
        previewView.session = captureSession
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9999085069, green: 1, blue: 0.9998822808, alpha: 1)
        if isCaptureSessionConfigured {
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
        } else {
            configureCaptureSession()
            isCaptureSessionConfigured = true
            captureSession.startRunning()
            previewView.updateVideoOrientationForDeviceOrientation()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    @objc func backDidTap() {
        dismiss(animated: true, completion: nil)
    }
}

    // MARK: AVCapturePhotoCaptureDelegate

extension QRcodeReaderVC : AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("Finished processing photo")

        if let cgImageRef = photo.cgImageRepresentation() {
            let cgImage = cgImageRef.takeUnretainedValue()

            print("Scanning image")
            scanImage(cgImage: cgImage)
        } else {
            print("Could not get image representation")
        }
    }
}
