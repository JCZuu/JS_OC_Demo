# JS_OC_Demo
oc与js交互
# 注：
该Demo主要介绍基于UIWebView的JS与OC之间的交互，以及基于WKwebView的JS与OC之间的交互。

UIWebView主要介绍有三种方式：

方式一：JSExport

方式二：UIWebView拦截Url

方式三：JSContext的Block方式

WKwebView 介绍了js调用以及调用OC本地方法，并阐述了注意事项，规避内存泄漏问题
注意问题：
UIWebView：
1、JSExport注意JSObject.h文件要遵循代理方法；
如下：（@interface JSObject : NSObject<JSObjcDelegate>）

2、Block方式要注意请持有导致的内存泄漏问题；

3、如果出现调用无效的情况，注意检查本地方法是否与h5调用方法一致，调用id是否与h5使用的上下文id一致。
WKWeBview：
注意在注册本地方法后，退出页面要销毁注册的方法，否则会引起内存泄漏，销毁方法要写在Dealloc方法之前，否则无效

iOS技术交流群:681732945
