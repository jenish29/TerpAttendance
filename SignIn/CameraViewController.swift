//
//  CameraViewController.swift
//  SignIn
//
//  Created by pc on 11/5/16.
//  Copyright © 2016 pc. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    
    /* record vedio objects */
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var sucess = false
    
    //green box around qr code
    var qrCodeFrameView:UIView?
  
    var id : String? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    override func viewDidAppear(_ animated: Bool) {

        //set up camera
        setupCamera()
        
        //gesture recognizer
        dismissGesture()
    }
    
    //set ups the camera but doesnt launch it 
    func setupCamera(){
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do{
            
            //add input to capture session
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            //add output for the data
            let captureMetaData = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetaData)
            captureMetaData.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetaData.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeFace]
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView?.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView!)
            view.bringSubview(toFront: qrCodeFrameView!)
            
            //starts camera session
            scanQr()
            
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    // starts up the camera
    func scanQr(){
     
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            view.layer.addSublayer(videoPreviewLayer!)
            videoPreviewLayer?.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
        
            // starts the camera
            captureSession?.startRunning()
        
    }
    
    // this method will be called when video has outout and if output is qrcode then it will scan it
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
        
        if let mt = metadataObj {
            if mt.type == AVMetadataObjectTypeQRCode {
            
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            view.bringSubview(toFront: qrCodeFrameView!)
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: mt as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if(!sucess){
            postAttendance()
            }
            }
            }
        }
        
    
    private func postAttendance(){
        sucess = true


    }
    
    private func showAlerts(val:Bool,err:Error?){
        
        let alertController = UIAlertController()
        
        if(val){
            alertController.message = "Sucess"
            alertController.title = "Great"
            let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                  _ = self.navigationController?.popToRootViewController(animated: true)
            })
            alertController.addAction(action)
        }
        else if (err == nil){
            alertController.message = "Failed to scan retry"
            alertController.title = "Failed"
            let action = UIAlertAction(title: "retry", style: .default, handler: nil)
            alertController.addAction(action)

        }
        else{
            alertController.message = err?.localizedDescription
            alertController.title = "Oops"
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
        

    }
    
    private func dismissGesture(){
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .right
        gesture.addTarget(self, action: #selector(dismissController))
        view.addGestureRecognizer(gesture)
        
    }
    
    @objc private func dismissController(){
        captureSession?.stopRunning()
        videoPreviewLayer?.removeFromSuperlayer()
       _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}



