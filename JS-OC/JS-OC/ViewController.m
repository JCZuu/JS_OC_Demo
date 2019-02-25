//
//  ViewController.m
//  JS-OC
//
//  Created by 祝国庆 on 2019/2/20.
//  Copyright © 2019 qixinpuhui. All rights reserved.
//
/*
 js与oc交互方式：
 1、JSExport
 2、拦截url（适用于UIWebView和WKWebView）
*/
#import "ViewController.h"
#import "JSObject.h"
@interface ViewController ()<UIWebViewDelegate, JSObjcDelegate>
{
    UIWebView *webPageView;
}
@end
/**  屏幕宽度、高度 */
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webPageView = [UIWebView new];
    webPageView.delegate = self;
    webPageView.scalesPageToFit = YES;
    webPageView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 50);
    [self.view addSubview:webPageView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"myHtml" ofType:@"html"];
    [webPageView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
//
}
//oc调用js方法
- (void)js_Method
{
    NSString *js_str = [NSString stringWithFormat:@"ios_JS('%@')", @"oc调用js"]; //准备执行的js代码
    [webPageView stringByEvaluatingJavaScriptFromString:js_str];

}
//js调用oc本地方法
- (void)js_ocMethod
{
    //方法类
    JSObject *jsObject = [JSObject new];
    jsObject.delegate = self;
    //js执行环境，包含了js执行时所需要的所有函数和对象
    JSContext *jsContext = [webPageView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //test：H5与移动端约定的id
    jsContext[@"test"] = jsObject;
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}
//本地方法的具体实现
- (void)showAlert:(NSString *)tip
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tip delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //适用于UIWebView和WKWebView
    //注：url路径为移动端与h5商定，不区分大小写
    if ([request.URL.absoluteString hasPrefix:@"myapp://url"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"弹窗" message:@"拦截url方法" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //调用js方法
//    [self js_Method];
    //js调用本地方法
    [self js_ocMethod];

}

@end
