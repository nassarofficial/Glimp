//
//  ViewController.swift
//  AVCamSwift
//
//  Created by sunset on 14-11-9.
//  Copyright (c) 2014年 sunset. All rights reserved.
//

import UIKit
import AssetsLibrary
import CoreLocation

import AVFoundation


var SessionRunningAndDeviceAuthorizedContext = "SessionRunningAndDeviceAuthorizedContext"
var CapturingStillImageContext = "CapturingStillImageContext"
var RecordingContext = "RecordingContext"
var uploadUrl = NSURL.fileURLWithPath(NSTemporaryDirectory().stringByAppendingPathComponent("captured").stringByAppendingString(".mov"))

class Glimp: UIViewController, AVCaptureFileOutputRecordingDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    var administrativeArea:String = ""
    // MARK: property
    
    @IBOutlet weak var counterbg: UIImageView!
    var sessionQueue: dispatch_queue_t?
    var session: AVCaptureSession?
    var videoDeviceInput: AVCaptureDeviceInput?
    var movieFileOutput: AVCaptureMovieFileOutput?

    @IBOutlet weak var setflash: UIButton!
    var outputFilePath: String?
    var gllatitude: Float?
    var gllongitude: Float?
    var count = 30

    var deviceAuthorized: Bool  = false
    var backgroundRecordId: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var sessionRunningAndDeviceAuthorized: Bool {
        get {
            return (self.session?.running != nil && self.deviceAuthorized )
        }
    }
    var toggler = 0
    
    var runtimeErrorHandlingObserver: AnyObject?
    var lockInterfaceRotation: Bool = false
    
    @IBOutlet var countDownLabel: UILabel!

    @IBOutlet weak var previewView: AVCamPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    func update() {
        
        if(count > 0)
        {
            NSTimer.after(1.second) {
           

            self.countDownLabel.text = String(self.count--)
                
            }
        }
        else if (count == 0)
        {
            self.movieFileOutput!.stopRecording()
            countDownLabel.text = String(30)
        }

    }

    

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })

        //1 grab current location
        var currentLocation = locations.last as! CLLocation
        //2 create location point for map based on current location
        var location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        //3 define layout for map
        locationManager.stopUpdatingLocation()
        gllatitude = Float(currentLocation.coordinate.latitude)
        gllongitude = Float(currentLocation.coordinate.longitude)
    }

    // MARK: Override methods
    // Call the function from tap gesture recognizer added to your view (or button)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var session: AVCaptureSession = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetMedium

      //  session.sessionPreset = AVCaptureSessionPreset640x480
        session.beginConfiguration()
        session.commitConfiguration()
        
        //session.sessionPreset = AVCaptureSessionPresetMedium
        
        self.session = session

        
        //session.beginConfiguration()
        //session.commitConfiguration()

        self.previewView.session = session
        self.checkDeviceAuthorizationStatus()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        var preferredTimeScale:Int32 = 30
        var totalSeconds:Int64 = Int64(Int(30) * Int(preferredTimeScale)) // after 7 sec video recording stop automatically
        var maxDuration:CMTime = CMTimeMake(totalSeconds, preferredTimeScale)
       // self.movieFileOutput!.maxRecordedDuration = maxDuration

        
        var sessionQueue: dispatch_queue_t = dispatch_queue_create("session queue",DISPATCH_QUEUE_SERIAL)
        
        self.sessionQueue = sessionQueue
        dispatch_async(sessionQueue, {
            self.backgroundRecordId = UIBackgroundTaskInvalid
            
            var videoDevice: AVCaptureDevice! = Glimp.deviceWithMediaType(AVMediaTypeVideo, preferringPosition: AVCaptureDevicePosition.Back)
            var error: NSError? = nil
            
            
            
            var videoDeviceInput: AVCaptureDeviceInput? =  AVCaptureDeviceInput(device: videoDevice, error: &error)
            
            if (error != nil) {
                println(error)
                
            }
            
            if session.canAddInput(videoDeviceInput){
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                
                dispatch_async(dispatch_get_main_queue(), {
                    // Why are we dispatching this to the main queue?
                    // Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
                    // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                    
                    var orientation: AVCaptureVideoOrientation =  AVCaptureVideoOrientation(rawValue: self.interfaceOrientation.rawValue)!
                    (self.previewView.layer as! AVCaptureVideoPreviewLayer).connection.videoOrientation = orientation
                    
                })
                
            }
            
            
            var audioDevice: AVCaptureDevice = AVCaptureDevice.devicesWithMediaType(AVMediaTypeAudio).first as! AVCaptureDevice
            var audioDeviceInput: AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(audioDevice, error: &error) as! AVCaptureDeviceInput
            if error != nil{
                println(error)
            }
            if session.canAddInput(audioDeviceInput){
                session.addInput(audioDeviceInput)
            }
            
            
            
            var movieFileOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
            if session.canAddOutput(movieFileOutput){
                session.addOutput(movieFileOutput)
                
                
                var connection: AVCaptureConnection? = movieFileOutput.connectionWithMediaType(AVMediaTypeVideo)
                let stab = connection?.supportsVideoStabilization
                if (stab != nil) {
                    connection!.enablesVideoStabilizationWhenAvailable = true
                }
                
                self.movieFileOutput = movieFileOutput

            }

        })
        

        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "gotovideoeditor") {
            let glimperVC = segue.destinationViewController as! GlimpPreview
            
            glimperVC.ViewControllerVideoPath = self.outputFilePath!
            glimperVC.gllat = self.gllatitude
            glimperVC.gllong = self.gllongitude
            glimperVC.locLabel = self.administrativeArea
            
        }

    }

    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=true;
       // self.hidesBottomBarWhenPushed = true
        //self.navigationController?.setToolbarHidden(true, animated: animated)
        let prefs = NSUserDefaults.standardUserDefaults()
        let booler = prefs.integerForKey("glimper")
        println(booler)
        
        dispatch_async(self.sessionQueue!, {
            self.addObserver(self, forKeyPath: "sessionRunningAndDeviceAuthorized", options: NSKeyValueObservingOptions.Old | NSKeyValueObservingOptions.New, context: &SessionRunningAndDeviceAuthorizedContext)
            self.addObserver(self, forKeyPath: "movieFileOutput.recording", options: NSKeyValueObservingOptions.Old | NSKeyValueObservingOptions.New, context: &RecordingContext)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "subjectAreaDidChange:", name: AVCaptureDeviceSubjectAreaDidChangeNotification, object: self.videoDeviceInput?.device)
            
            
            weak var weakSelf = self
            
            self.runtimeErrorHandlingObserver = NSNotificationCenter.defaultCenter().addObserverForName(AVCaptureSessionRuntimeErrorNotification, object: self.session, queue: nil, usingBlock: {
                (note: NSNotification?) in
                var strongSelf: Glimp = weakSelf!
                dispatch_async(strongSelf.sessionQueue!, {
                    //                    strongSelf.session?.startRunning()
                    if let sess = strongSelf.session{
                        sess.startRunning()
                    }
                    //                    strongSelf.recordButton.title  = NSLocalizedString("Record", "Recording button record title")
                })
                
            })
            
            self.session?.startRunning()
            
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        dispatch_async(self.sessionQueue!, {
            
            if let sess = self.session{
                sess.stopRunning()
                
                NSNotificationCenter.defaultCenter().removeObserver(self, name: AVCaptureDeviceSubjectAreaDidChangeNotification, object: self.videoDeviceInput?.device)
                NSNotificationCenter.defaultCenter().removeObserver(self.runtimeErrorHandlingObserver!)
                
                self.removeObserver(self, forKeyPath: "sessionRunningAndDeviceAuthorized", context: &SessionRunningAndDeviceAuthorizedContext)
                
                self.removeObserver(self, forKeyPath: "movieFileOutput.recording", context: &SessionRunningAndDeviceAuthorizedContext)
                
                
            }

            
            
        })
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            // println(administrativeArea)
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        (self.previewView.layer as! AVCaptureVideoPreviewLayer).connection.videoOrientation = AVCaptureVideoOrientation(rawValue: toInterfaceOrientation.rawValue)!
        
        //        if let layer = self.previewView.layer as? AVCaptureVideoPreviewLayer{
        //            layer.connection.videoOrientation = self.convertOrientation(toInterfaceOrientation)
        //        }
        
    }
    
    override func shouldAutorotate() -> Bool {
        return !self.lockInterfaceRotation
    }
    //    observeValueForKeyPath:ofObject:change:context:
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        
        
        if context == &CapturingStillImageContext{
            var isCapturingStillImage: Bool = change[NSKeyValueChangeNewKey]!.boolValue
            if isCapturingStillImage {
                self.runStillImageCaptureAnimation()
            }
            
        }else if context  == &RecordingContext{
            var isRecording: Bool = change[NSKeyValueChangeNewKey]!.boolValue
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if isRecording {
                    self.recordButton.titleLabel!.text = "Stop"
                    self.recordButton.enabled = true
                    self.cameraButton.enabled = false
                    
                }else{
                    self.performSegueWithIdentifier("gotovideoeditor", sender: self)
                    self.recordButton.titleLabel!.text = "Record"
                    self.recordButton.enabled = true
                    self.cameraButton.enabled = true
                    
                }
                
                
            })
            
            
        }
            
        else{
            return super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
        
    }
    
    
    // MARK: Selector
    func subjectAreaDidChange(notification: NSNotification){
        var devicePoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
        self.focusWithMode(AVCaptureFocusMode.ContinuousAutoFocus, exposureMode: AVCaptureExposureMode.ContinuousAutoExposure, point: devicePoint, monitorSubjectAreaChange: false)
    }
    
    // MARK:  Custom Function
    
    func focusWithMode(focusMode:AVCaptureFocusMode, exposureMode:AVCaptureExposureMode, point:CGPoint, monitorSubjectAreaChange:Bool){
        
        dispatch_async(self.sessionQueue!, {
            var device: AVCaptureDevice! = self.videoDeviceInput!.device
            var error: NSError? = nil
            
            if device.lockForConfiguration(&error){
                if device.focusPointOfInterestSupported && device.isFocusModeSupported(focusMode){
                    device.focusMode = focusMode
                    device.focusPointOfInterest = point
                }
                if device.exposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode){
                    device.exposurePointOfInterest = point
                    device.exposureMode = exposureMode
                }
                device.subjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
                device.unlockForConfiguration()
            }else{
                println(error)
            }
            
            
        })
        
    }
    
    @IBAction func s(sender: AnyObject) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            if (device.torchMode == AVCaptureTorchMode.On) {
                device.torchMode = AVCaptureTorchMode.Off
                setflash.setImage(UIImage(named: "flash.png"), forState: UIControlState.Normal)

            } else {
                setflash.setImage(UIImage(named: "flashicon.png"), forState: UIControlState.Normal)

                device.setTorchModeOnWithLevel(1.0, error: nil)
            }
            device.unlockForConfiguration()
        }

    }
    
    class func setFlashMode(flashMode: AVCaptureFlashMode, device: AVCaptureDevice){
        
        if device.hasFlash && device.isFlashModeSupported(flashMode) {
            var error: NSError? = nil
            if device.lockForConfiguration(&error){
                device.flashMode = flashMode
                device.unlockForConfiguration()
                
            }else{
                println(error)
            }
        }
        
    }
    
    func runStillImageCaptureAnimation(){
        dispatch_async(dispatch_get_main_queue(), {
            self.previewView.layer.opacity = 0.0
            println("opacity 0")
            UIView.animateWithDuration(0.25, animations: {
                self.previewView.layer.opacity = 1.0
                println("opacity 1")
            })
        })
    }
    
    class func deviceWithMediaType(mediaType: String, preferringPosition:AVCaptureDevicePosition)->AVCaptureDevice{
        
        var devices = AVCaptureDevice.devicesWithMediaType(mediaType);
        var captureDevice: AVCaptureDevice = devices[0] as! AVCaptureDevice;
        
        for device in devices{
            if device.position == preferringPosition{
                captureDevice = device as! AVCaptureDevice
                break
            }
        }
        
        return captureDevice
        
        
    }
    
    func checkDeviceAuthorizationStatus(){
        var mediaType:String = AVMediaTypeVideo;
        
        AVCaptureDevice.requestAccessForMediaType(mediaType, completionHandler: { (granted: Bool) in
            if granted{
                self.deviceAuthorized = true;
            }else{
                
                dispatch_async(dispatch_get_main_queue(), {
                    var alert: UIAlertController = UIAlertController(
                        title: "AVCam",
                        message: "AVCam does not have permission to access camera",
                        preferredStyle: UIAlertControllerStyle.Alert);
                    
                    var action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                        (action2: UIAlertAction!) in
                        exit(0);
                    } );
                    
                    alert.addAction(action);
                    
                    self.presentViewController(alert, animated: true, completion: nil);
                })
                
                self.deviceAuthorized = false;
            }
        })
        
    }
    
    // MARK: File Output Delegate
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        
        if(error != nil){
            println(error)
        }
        
        self.lockInterfaceRotation = false
        
        // Note the backgroundRecordingID for use in the ALAssetsLibrary completion handler to end the background task associated with this recording. This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's -isRecording is back to NO — which happens sometime after this method returns.
        
        var backgroundRecordId: UIBackgroundTaskIdentifier = self.backgroundRecordId
        self.backgroundRecordId = UIBackgroundTaskInvalid
        
        ALAssetsLibrary().writeVideoAtPathToSavedPhotosAlbum(outputFileURL, completionBlock: {
            (assetURL:NSURL!, error:NSError!) in
            if error != nil{
                println(error)
                
            }
            
        //    NSFileManager.defaultManager().removeItemAtURL(outputFileURL, error: nil)
            
            if backgroundRecordId != UIBackgroundTaskInvalid {
                UIApplication.sharedApplication().endBackgroundTask(backgroundRecordId)
            }
            
        })
        
        
    }
    
    // MARK: Actions
    
    @IBAction func toggleMovieRecord(sender: AnyObject) {
        counterbg.hidden = false

        self.recordButton.enabled = false
        self.recordButton.setImage(UIImage(named: "stopicon.png"), forState: UIControlState.Normal)
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)

        dispatch_async(self.sessionQueue!, {
            if !self.movieFileOutput!.recording{
                self.lockInterfaceRotation = true
                
                if UIDevice.currentDevice().multitaskingSupported {
                    self.backgroundRecordId = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({})
                    
                }
                
                self.movieFileOutput!.connectionWithMediaType(AVMediaTypeVideo).videoOrientation =
                    AVCaptureVideoOrientation(rawValue: (self.previewView.layer as! AVCaptureVideoPreviewLayer).connection.videoOrientation.rawValue )!
                
                // Turning OFF flash for video recording

                
                var err: NSErrorPointer = nil
                let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
                if NSFileManager.defaultManager().fileExistsAtPath(docPath) == false{
                    NSFileManager.defaultManager().createDirectoryAtPath(docPath, withIntermediateDirectories: false, attributes: nil, error: err)
                }
                
                
                let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
                self.outputFilePath = documentsPath.stringByAppendingPathComponent("glimp_1".stringByAppendingPathExtension("mov")!)

                self.movieFileOutput!.startRecordingToOutputFileURL(NSURL.fileURLWithPath(self.outputFilePath!), recordingDelegate: self)
            }else{
                self.movieFileOutput!.stopRecording()
                self.recordButton.setImage(UIImage(named: "recordiconrec.png"), forState: UIControlState.Normal)

            }
        })
        
    }
    @IBAction func changeCamera(sender: AnyObject) {
        
        
        
        println("change camera")
        
        self.cameraButton.enabled = false
        self.recordButton.enabled = false
        
        dispatch_async(self.sessionQueue!, {
            
            var currentVideoDevice:AVCaptureDevice = self.videoDeviceInput!.device
            var currentPosition: AVCaptureDevicePosition = currentVideoDevice.position
            var preferredPosition: AVCaptureDevicePosition = AVCaptureDevicePosition.Unspecified
            
            switch currentPosition{
            case AVCaptureDevicePosition.Front:
                preferredPosition = AVCaptureDevicePosition.Back
            case AVCaptureDevicePosition.Back:
                preferredPosition = AVCaptureDevicePosition.Front
            case AVCaptureDevicePosition.Unspecified:
                preferredPosition = AVCaptureDevicePosition.Back
                
            }
            
            
            
            var device:AVCaptureDevice = Glimp.deviceWithMediaType(AVMediaTypeVideo, preferringPosition: preferredPosition)
            
            var videoDeviceInput: AVCaptureDeviceInput = AVCaptureDeviceInput(device: device, error: nil)
            
            self.session!.beginConfiguration()
            
            self.session!.removeInput(self.videoDeviceInput)
            
            if self.session!.canAddInput(videoDeviceInput){
                
                NSNotificationCenter.defaultCenter().removeObserver(self, name:AVCaptureDeviceSubjectAreaDidChangeNotification, object:currentVideoDevice)
                
                Glimp.setFlashMode(AVCaptureFlashMode.Auto, device: device)
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "subjectAreaDidChange:", name: AVCaptureDeviceSubjectAreaDidChangeNotification, object: device)
                
                self.session!.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                
            }else{
                self.session!.addInput(self.videoDeviceInput)
            }
            
            self.session!.commitConfiguration()
            
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.recordButton.enabled = true
                self.cameraButton.enabled = true
            })
            
        })
        
        
        
        
    }
    
    @IBAction func focusAndExposeTap(gestureRecognizer: UIGestureRecognizer) {
        
        println("focusAndExposeTap")
        var devicePoint: CGPoint = (self.previewView.layer as! AVCaptureVideoPreviewLayer).captureDevicePointOfInterestForPoint(gestureRecognizer.locationInView(gestureRecognizer.view))
        
        println(devicePoint)
        
        self.focusWithMode(AVCaptureFocusMode.AutoFocus, exposureMode: AVCaptureExposureMode.AutoExpose, point: devicePoint, monitorSubjectAreaChange: true)
        
    }
}

