//
//  JSObject.m
//  JS-OC
//
//  Created by 祝国庆 on 2019/2/20.
//  Copyright © 2019 qixinpuhui. All rights reserved.
//

#import "JSObject.h"

@implementation JSObject
//调起弹窗
- (void)showAlert:(NSString *)tip
{
    [self.delegate showAlert:tip];
}
@end
