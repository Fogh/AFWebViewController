//
//  AFWebViewController.m
//  AFWebViewController
//
//  Created by Anders Eriksen on 09/11/14.
//  Copyright (c) 2014 Fogh Development. All rights reserved.
//

#import "AFWebViewController.h"
#import <TUSafariActivity.h>
#import <ARChromeActivity.h>
@import WebKit;

@interface AFWebViewController () <WKNavigationDelegate>

// Bar buttons
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarButtonItem;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;
@end

@implementation AFWebViewController

#pragma mark - Initialization

+ (instancetype)webViewControllerWithAddress:(NSString *)urlString {
    return [[self alloc] initWithAddress:urlString];
}

+ (instancetype)webViewControllerWithURL:(NSURL *)URL {
    return [[self alloc] initWithURL:URL];
}

+ (instancetype)webViewControllerWithURLRequest:(NSURLRequest *)request {
    return [[self alloc] initWithURLRequest:request];
}

+ (instancetype)webViewControllerWithHTMLString:(NSString *)HTMLString andBaseURL:(NSURL *)baseURL {
    return [[self alloc] initWithHTMLString:HTMLString andBaseURL:baseURL];
}

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:URL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request {
    if (self = [super init]) {
        self.request = request;
    }
    return self;
}

- (instancetype)initWithHTMLString:(NSString *)HTMLString andBaseURL:(NSURL *)baseURL {
    
    if (self = [super init]) {
        [self.webView loadHTMLString:HTMLString baseURL:baseURL];
    }
    return self;
}

- (void)loadRequest:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}

#pragma mark - View lifecycle

- (void)dealloc
{
    self.webView.navigationDelegate = nil;
}

- (void)loadView {
    self.view = self.webView;
    [self loadRequest:self.request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateToolbarItems];
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"AFWebViewController needs to be contained in a UINavigationController. Use AFModalWebViewController for modal presentation.");
    
    [super viewWillAppear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Getters

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AFWebViewController.bundle/Back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackTapped:)];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AFWebViewController.bundle/Forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardTapped:)];
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped:)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopTapped:)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    if (!_actionBarButtonItem) {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
    }
    return _actionBarButtonItem;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.self.webView.canGoForward;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat toolbarWidth = 250;
        fixedSpace.width = 35;
        
        NSArray *items = @[fixedSpace,
                          refreshStopBarButtonItem,
                          fixedSpace,
                          self.backBarButtonItem,
                          fixedSpace,
                          self.forwardBarButtonItem,
                          fixedSpace,
                          self.actionBarButtonItem];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, toolbarWidth, 44)];
        toolbar.items = items;
        toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationItem.rightBarButtonItems = items.reverseObjectEnumerator.allObjects;
    }
    else {
        NSArray *items = @[fixedSpace,
                          self.backBarButtonItem,
                          flexibleSpace,
                          self.forwardBarButtonItem,
                          flexibleSpace,
                          refreshStopBarButtonItem,
                          flexibleSpace,
                          self.actionBarButtonItem,
                          fixedSpace];
        
        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.toolbarItems = items;
    }
}

#pragma mark - Target actions

- (void)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)goBackTapped:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (void)goForwardTapped:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (void)reloadTapped:(UIBarButtonItem *)sender {
    [self.webView reload];
}

- (void)stopTapped:(UIBarButtonItem *)sender {
    [self.webView stopLoading];
    [self updateToolbarItems];
}

- (void)actionButtonTapped:(id)sender {
    NSURL *url = self.webView.URL ?: self.request.URL;
    if (url) {
        // More activities should be added in the future
        NSArray *activities = @[[TUSafariActivity new], [ARChromeActivity new]];
        if ([[url absoluteString] hasPrefix:@"file:///"]) {
            UIDocumentInteractionController *dc = [UIDocumentInteractionController interactionControllerWithURL:url];
            [dc presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
        }
        else {
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:activities];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                UIPopoverPresentationController *ctrl = activityController.popoverPresentationController;
                ctrl.sourceView = self.view;
                ctrl.barButtonItem = sender;
            }
            
            [self presentViewController:activityController animated:YES completion:NULL];
        }
    }
}

#pragma mark - WKNavigation delegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateToolbarItems];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (!self.navigationItem.title) {
        self.navigationItem.title = webView.title;
    }
    
    [self updateToolbarItems];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateToolbarItems];
}

@end
