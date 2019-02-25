//
//  JSObject.h
//  JS-OC
//
//  Created by 祝国庆 on 2019/2/20.
//  Copyright © 2019 qixinpuhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol JSObjcDelegate <JSExport>
/**
 *  调起弹窗
 *  tip  描述文案
 */
- (void)showAlert:(NSString *)tip;
@end
NS_ASSUME_NONNULL_BEGIN

@interface JSObject : NSObject<JSObjcDelegate>

@property(nonatomic, weak)id<JSObjcDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
