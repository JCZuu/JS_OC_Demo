//
//  WKWebViewViewController.m
//  JS-OC
//
//  Created by 祝国庆 on 2019/3/13.
//  Copyright © 2019年 qixinpuhui. All rights reserved.
//

#import "WKWebViewViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebViewViewController () <WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webpageView;
@end

@implementation WKWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"此页面测试WKWebView";
    
    UIButton *jsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [jsButton setTitle:@"js改变颜色" forState:UIControlStateNormal];
    [jsButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [jsButton addTarget:self action:@selector(js_Method) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:jsButton];
    
    //进行配置控制器
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //实例化对象
    configuration.userContentController = [[WKUserContentController alloc] init];
    // 创建webView
    self.webpageView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    self.webpageView.UIDelegate = self;
    self.webpageView.navigationDelegate = self;
    self.webpageView.frame = self.view.bounds;
    [self.view addSubview:self.webpageView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"myHtml" ofType:@"html"];
    [self.webpageView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //重要：注册本地方法
    [self.webpageView.configuration.userContentController addScriptMessageHandler:self name:@"showAlert"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //重要：销毁已经注册的本地方法，否则会引起内存泄漏
    [self.webpageView.configuration.userContentController removeScriptMessageHandlerForName:@"showAlert"];
}
//oc调用js方法
- (void)js_Method
{
    //通过调用js里的方法来改变网页测试文本的背景色
    NSString *js_str = [NSString stringWithFormat:@"changeBgColor()"]; //准备执行的js代码:改变测试文本背景色
    [self.webpageView evaluateJavaScript:js_str completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //重要：在这里截取H5调用的本地方法
    if ([message.name isEqualToString:@"showAlert"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"本地弹窗-提示" message:[NSString stringWithFormat:@"%@", message.body] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - WKNavigationDelegate
// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler
{
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
  

}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 全局：处理拨打电话以及Url跳转等等
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    decisionHandler(WKNavigationActionPolicyAllow);
}


-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    
    
}




- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
