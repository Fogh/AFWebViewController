//
//  AFWebViewController.h
//  AFWebViewController
//
//  Created by Anders Eriksen on 09/11/14.
//  Copyright (c) 2014 Fogh Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFWebViewController : UIViewController

+ (instancetype)webViewControllerWithAddress:(NSString *)urlString;
+ (instancetype)webViewControllerWithURL:(NSURL *)URL;
+ (instancetype)webViewControllerWithURLRequest:(NSURLRequest *)request;
+ (instancetype)webViewControllerWithHTMLString:(NSString *)HTMLString andBaseURL:(NSURL *)baseURL;

- (instancetype)initWithAddress:(NSString *)urlString;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;
- (instancetype)initWithHTMLString:(NSString *)HTMLString andBaseURL:(NSURL *)baseURL;

@end
