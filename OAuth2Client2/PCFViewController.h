//
//  PCFViewController.h
//  OAuth2Client2
//
//  Created by Rob Szumlakowski on 2014-05-15.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic) IBOutlet UILabel *label;

@end
