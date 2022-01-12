//
//  CVFViewController.h
//  CVFunhouse2App
//
//  Created by John Brewer on 1/11/22.
//  Copyright © 2022 Jera Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CVFImageProcessorDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CVFViewController : UIViewController <
    AVCaptureVideoDataOutputSampleBufferDelegate,
    CVFImageProcessorDelegate
> {
    bool _useBackCamera;
}

@property (nonatomic) CVFImageProcessor *imageProcessor;
- (void)setImageProcessor:(CVFImageProcessor *)imageProcessor;
- (CVFImageProcessor *)imageProcessor;


- (void)setupCamera;
- (void)turnCameraOn;
- (void)turnCameraOff;

@end

NS_ASSUME_NONNULL_END
