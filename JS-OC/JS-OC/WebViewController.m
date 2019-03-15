//
//  WebViewController.m
//  JS-OC
//
//  Created by 祝国庆 on 2019/3/13.
//  Copyright © 2019年 qixinpuhui. All rights reserved.
//

#import "WebViewController.h"
#import "JSObject.h"

@interface WebViewController ()<UIWebViewDelegate, JSObjcDelegate>
{
    UIWebView *webPageView;
}
@end
/**  屏幕宽度、高度 */
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"此页面测试UIWebView";
    UIButton *jsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [jsButton setTitle:@"调用js弹窗" forState:UIControlStateNormal];
    [jsButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [jsButton addTarget:self action:@selector(js_Method) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:jsButton];

    
    webPageView = [UIWebView new];
    webPageView.delegate = self;
    webPageView.scalesPageToFit = YES;
    webPageView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 50);
    [self.view addSubview:webPageView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"myHtml" ofType:@"html"];
    [webPageView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    
}
//oc调用js方法
- (void)js_Method
{
    NSString *js_str = [NSString stringWithFormat:@"alert('%@')", @"h5弹窗"]; //准备执行的js代码
    [webPageView stringByEvaluatingJavaScriptFromString:js_str];
    
}
//方法一：js调用oc本地方法，JSExport
- (void)js_ocMethod
{
    //方法类
    JSObject *jsObject = [JSObject new];
    jsObject.delegate = self;
    //js执行环境，包含了js执行时所需要的所有函数和对象
    JSContext *jsContext = [webPageView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //test：H5与移动端约定的id
    jsContext[@"test1"] = jsObject;
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}
//本地方法的具体实现
- (void)showAlert:(NSString *)tip
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"jsExport-oc原生弹窗" message:tip delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}
//方法三：js调用oc本地方法，Block方式
- (void)blockMethod
{
    __weak WebViewController *vc = self;
    JSContext *context=[webPageView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    /**注意循环引用问题*/
    //调用id：test
    context[@"test"] = ^(id str)
    {
        NSArray *values = [JSContext currentArguments];
        for (JSValue *value in values)
        {
            //本地方法名称：showAlert1
            if ([[value toString] isEqualToString:@"showAlert1"])
            {
                [vc showAlert1];
            }
        }
    };
}
- (void)showAlert1
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"block-oc原生弹窗" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
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
    //方法二：拦截url
    //适用于UIWebView和WKWebView
    //注：url路径为移动端与h5商定，不区分大小写
    if ([request.URL.absoluteString hasPrefix:@"myapp://url"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"弹窗" message:@"拦截url方法-oc原生弹窗" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //js调用本地方法
    [self js_ocMethod];
    //block方式
    [self blockMethod];
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
