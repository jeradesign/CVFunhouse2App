//
//  CVFMainViewController.h
//  CVFunhouse
//
//  Created by John Brewer on 3/7/12.
//  Copyright (c) 2012 Jera Design LLC. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "CVFFlipsideViewController.h"
#import "CVFViewController.h"

@class CVFImageProcessor;

@interface CVFMainViewController : CVFViewController <
    CVFFlipsideViewControllerDelegate,
    UIPopoverControllerDelegate,
    UIWebViewDelegate
    >
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *fpsLabel;
@property (weak, nonatomic) IBOutlet UIButton *flipCameraButton;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionView;
@property (weak, nonatomic) IBOutlet UIView *descriptionContainer;
@property (weak, nonatomic) IBOutlet GLKView *arView;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (strong, atomic) CVFImageProcessor *imageProcessor;

- (IBAction)flipAction:(id)sender;
- (IBAction)swipeUpAction:(id)sender;
- (IBAction)swipeDownAction:(id)sender;
- (IBAction)closeDescription:(id)sender;

@end
