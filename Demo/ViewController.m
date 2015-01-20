//
//  ViewController.m
//  AFWebViewController
//
//  Created by Anders Eriksen on 09/11/14.
//  Copyright (c) 2014-2015 Fogh Development. All rights reserved.
//

#import "ViewController.h"
#import "AFWebViewController.h"
#import "AFModalWebViewController.h"

@implementation ViewController

- (IBAction)openWebView:(id)sender {
    AFWebViewController *webViewController = [AFWebViewController webViewControllerWithAddress:@"https://google.com"];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)openWebViewModal:(id)sender {
    AFModalWebViewController *webViewController = [AFModalWebViewController webViewControllerWithAddress:@"https://google.com"];
    [self presentViewController:webViewController animated:YES completion:NULL];
}
@end
