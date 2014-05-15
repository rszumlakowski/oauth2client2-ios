//
//  PCFViewController.m
//  OAuth2Client2
//
//  Created by Rob Szumlakowski on 2014-05-15.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "PCFViewController.h"
#import <NXOAuth2Client/NXOAuth2.h>

@interface PCFViewController ()

@end

@implementation PCFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.webview.delegate = self;
    self.label.text = @"";
    self.label.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      
                                                      if (aNotification.userInfo) {
                                                          //account added, we have access
                                                          //we can now request protected data
                                                          [self addLogMessage:@"Success!! We have an access token."];
                                                          [self requestOAuth2ProtectedDetails];
                                                      } else {
                                                          //account removed, we lost access
                                                      }
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      [self addLogMessage:[NSString stringWithFormat:@"Error!! %@", error.localizedDescription]];
                                                      
                                                  }];

    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Google"
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
                                       NSLog(@"Received preparedURL: '%@'.", preparedURL);
                                       
                                        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:preparedURL];
                                       [self.webview loadRequest:urlRequest];
                                   }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.host isEqualToString:@"mobile.cf.pivotal.com"]) {
        [self authorizationComplete:request.URL];
        self.webview.hidden = YES;
        return NO;
    } else {
        NSLog(@"Webview loading request '%@'.", request.URL);
        return YES;
    }
}

- (void)authorizationComplete:(NSURL*)redirectURL {
    [self addLogMessage:@"Authorization complete!"];
    [[NXOAuth2AccountStore sharedStore] handleRedirectURL:redirectURL];
}

- (void)requestOAuth2ProtectedDetails
{
    NXOAuth2AccountStore *store = [NXOAuth2AccountStore sharedStore];
    NSArray *accounts = [store accountsWithAccountType:@"Google"];
    
    
    [NXOAuth2Request performMethod:@"GET"
                        onResource:[NSURL URLWithString:@"https://www.googleapis.com/oauth2/v1/userinfo"]
                   usingParameters:nil
                       withAccount:accounts[0]
               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                   // e.g., update a progress indicator
               }
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                       // Process the response
                       if (responseData) {
                           NSError *error;
                           NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
                           NSLog(@"%@", userInfo);
                           [self addLogMessage:@"Protected profile data has been read."];
                           [self addLogMessage:[NSString stringWithFormat:@"name: '%@'", userInfo[@"name"]]];
                           [self addLogMessage:[NSString stringWithFormat:@"email: '%@'", userInfo[@"email"]]];
                       }
                       if (error) {
                           [self addLogMessage:[@"Could not read protected profile data: Error: " stringByAppendingString:error.localizedDescription]];
                       }
                   }];
}

- (void) addLogMessage:(NSString*)message {
    self.label.hidden = NO;
    if (self.label.text.length == 0) {
        self.label.text = message;
    } else {
        self.label.text = [NSString stringWithFormat:@"%@\n%@", self.label.text, message];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
