# JS_OC_Demo
oc与js交互
# 注：
该Demo主要介绍基于UIWebView的JS与OC之间的交互。 

主要介绍有三种方式：

方式一：JSExport

方式二：UIWebView拦截Url

方式三：JSContext的Block方式

注意问题：

1、JSExport注意JSObject.h文件要遵循代理方法；
如下：（@interface JSObject : NSObject<JSObjcDelegate>）

2、Block方式要注意请持有导致的内存泄漏问题；

3、如果出现调用无效的情况，注意检查本地方法是否与h5调用方法一致，调用id是否与h5使用的上下文id一致。

iOS技术交流群:681732945
