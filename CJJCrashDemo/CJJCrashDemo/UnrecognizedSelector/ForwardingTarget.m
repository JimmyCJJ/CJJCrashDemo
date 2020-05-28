//
//  ForwardingTarget.m
//  CJJCrashDemo
//
//  Created by JimmyCJJ on 2020/5/28.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "ForwardingTarget.h"

@implementation ForwardingTarget

- (void)forwardingTargetMethod{
    NSLog(@"unrecognized selector sent to instance,%@成功接受了实例方法%@的转发",self,NSStringFromSelector(_cmd));
}

@end
