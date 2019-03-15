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
#import "WebViewController.h"
#import "WKWebViewViewController.h"
@interface ViewController ()
@end
/**  屏幕宽度、高度 */
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *webViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [webViewBtn setTitle:@"UIWebView测试" forState:UIControlStateNormal];
    webViewBtn.backgroundColor = [UIColor purpleColor];
    [webViewBtn addTarget:self action:@selector(jumpToWebView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webViewBtn];
    [webViewBtn setFrame:CGRectMake((KScreenWidth - 200) / 2, 180, 200, 35)];

    UIButton *wkWebViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wkWebViewBtn setTitle:@"WKWebView测试" forState:UIControlStateNormal];
    wkWebViewBtn.backgroundColor = [UIColor orangeColor];
    [wkWebViewBtn addTarget:self action:@selector(jumpToWKWeview:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wkWebViewBtn];
    [wkWebViewBtn setFrame:CGRectMake((KScreenWidth - 200) / 2, 180 + 60, 200, 35)];

}
- (void)jumpToWebView:(UIButton *)button
{
    WebViewController *vc = [[WebViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)jumpToWKWeview:(UIButton *)button
{
    WKWebViewViewController *vc = [[WKWebViewViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
