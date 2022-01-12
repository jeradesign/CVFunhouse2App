//
//  CVFViewController.m
//  CVFunhouse2App
//
//  Created by John Brewer on 1/11/22.
//  Copyright © 2022 Jera Design LLC. All rights reserved.
//

#import "CVFViewController.h"
#import "CVFImageProcessor.h"

@interface CVFViewController () {
    AVCaptureDevice *_cameraDevice;
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_previewLayer;
    CVFImageProcessor *_imageProcessor;
    BOOL _authorized;
}

@end

@implementation CVFViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _useBackCamera = [[NSUserDefaults standardUserDefaults] boolForKey:@"useBackCamera"];
    [self requestCamera];
    [self turnCameraOn];
}

- (void)setImageProcessor:(CVFImageProcessor *)imageProcessor
{
    if (_imageProcessor != imageProcessor) {
        _imageProcessor.delegate = nil;
        _imageProcessor = imageProcessor;
        _imageProcessor.delegate = self;
    }
}

- (CVFImageProcessor *)imageProcessor {
    return _imageProcessor;
}


#pragma mark - Camera support

- (void)requestCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        _authorized = true;
        [self setupCamera];
        [self turnCameraOn];
    } else if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                self->_authorized = true;
                [self setupCamera];
                [self turnCameraOn];
            } else {
                self->_authorized = false;
            }
        }];
    } else {
        // TODO: Handle AVAuthorizationStatusRestricted and AVAuthorizationStatusDenied
        _authorized = false;
    }
}

- (void)setupCamera {
    _cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSArray *devices = [AVCaptureDevice devices];
    if (devices.count == 1) {
        
    }
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionFront && !_useBackCamera) {
            
            _cameraDevice = device;
            break;
        }
        if (device.position == AVCaptureDevicePositionBack && _useBackCamera) {
            
            _cameraDevice = device;
            break;
        }
    }
}

- (void)turnCameraOn {
    if (!_authorized) {
         return;
    }
    NSError *error;
    _session = [[AVCaptureSession alloc] init];
    [_session beginConfiguration];
    [_session setSessionPreset:AVCaptureSessionPresetMedium];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_cameraDevice
                                                                        error:&error];
    if (input == nil) {
        NSLog(@"%@", error);
        [_session commitConfiguration];
        return;
    }
    
    [_session addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [_session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    // Specify the pixel format
    output.videoSettings =
    @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    output.alwaysDiscardsLateVideoFrames = YES;
    //kCVPixelFormatType_32BGRA
    
//    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
//    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationLandscapeRight;
//    [_previewLayer setOrientation:orientation];
//    _previewLayer.frame = self.previewView.bounds;
//    [self.previewView.layer addSublayer:_previewLayer];
    
    // Start the session running to start the flow of data
    [_session commitConfiguration];
    [_session startRunning];
}

- (void)turnCameraOff {
    [_previewLayer removeFromSuperlayer];
    _previewLayer = nil;
    [_session stopRunning];
    _session = nil;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    @autoreleasepool {
#pragma unused(captureOutput)
#pragma unused(connection)
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        [self.imageProcessor processImageBuffer:imageBuffer
                                  withMirroring:(_cameraDevice.position ==
                                                 AVCaptureDevicePositionFront)];
    }
}

@end
