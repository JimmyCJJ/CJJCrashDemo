//
//  ViewController.m
//  CJJCrashDemo
//
//  Created by JimmyCJJ on 2020/5/28.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "ViewController.h"
#import "ForwardingTarget.h"
#import "ForwardInvocationOne.h"
#import "ForwardInvocationTwo.h"
#import <objc/runtime.h>
@interface ViewController ()
@property (nonatomic,strong) UIButton *addMethodBtn;
@property (nonatomic,strong) UIButton *forwardingTargetBtn;
@property (nonatomic,strong) UIButton *forwardingInvocationBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addMethodBtn];
    [self.view addSubview:self.forwardingTargetBtn];
    [self.view addSubview:self.forwardingInvocationBtn];
}

void instanceMethod(id self, SEL _cmd){
    NSLog(@"unrecognized selector sent to instance,%@成功添加了实例方法%@",self,NSStringFromSelector(_cmd));
    [ViewController performSelector:@selector(classMethod:)];
}

void classMethod(id self,SEL _cmd, int num){
    NSLog(@"unrecognized selector sent to class,%@成功添加了类方法%@",self,NSStringFromSelector(_cmd));
}

#pragma mark - add method by runtime

+ (BOOL)resolveClassMethod:(SEL)sel{
        if([NSStringFromSelector(sel) isEqualToString:@"classMethod:"]){
            Class metaClass = objc_getMetaClass("ViewController");
            class_addMethod(metaClass, sel, (IMP)classMethod, "v@:i");
            return YES;
        }
        return [super resolveClassMethod:sel];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if([NSStringFromSelector(sel) isEqualToString:@"instanceMethod:"]){
        class_addMethod([self class], sel, (IMP)instanceMethod, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

#pragma mark - message forwarding

- (id)forwardingTargetForSelector:(SEL)aSelector{
    if([NSStringFromSelector(aSelector) isEqualToString:@"forwardingTargetMethod"]){
        ForwardingTarget *obj = [ForwardingTarget new];
        if([obj respondsToSelector:aSelector]){
            return obj;
        }
    }
    return [super forwardingTargetForSelector:aSelector];
}
//
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if([NSStringFromSelector(aSelector) isEqualToString:@"forwardingInvocationMethod"]){
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    if([NSStringFromSelector(anInvocation.selector) isEqualToString:@"forwardingInvocationMethod"]){
        ForwardInvocationOne *one = [ForwardInvocationOne new];
        ForwardInvocationTwo *two = [ForwardInvocationTwo new];
        [anInvocation invokeWithTarget:one];
        [anInvocation invokeWithTarget:two];
    }
}


#pragma mark - lazy

- (UIButton *)addMethodBtn{
    if(!_addMethodBtn){
        _addMethodBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
        [_addMethodBtn setTitle:@"动态添加方法" forState:UIControlStateNormal];
        [_addMethodBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _addMethodBtn.backgroundColor = [UIColor yellowColor];
        [_addMethodBtn addTarget:self action:@selector(instanceMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addMethodBtn;
}

- (UIButton *)forwardingTargetBtn{
    if(!_forwardingTargetBtn){
        _forwardingTargetBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 200, 100)];
        [_forwardingTargetBtn setTitle:@"消息转发给单个对象" forState:UIControlStateNormal];
        [_forwardingTargetBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _forwardingTargetBtn.backgroundColor = [UIColor yellowColor];
        [_forwardingTargetBtn addTarget:self action:@selector(forwardingTargetMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forwardingTargetBtn;
}

- (UIButton *)forwardingInvocationBtn{
    if(!_forwardingInvocationBtn){
        _forwardingInvocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 200, 100)];
        [_forwardingInvocationBtn setTitle:@"消息转发给多个对象" forState:UIControlStateNormal];
        [_forwardingInvocationBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _forwardingInvocationBtn.backgroundColor = [UIColor yellowColor];
        [_forwardingInvocationBtn addTarget:self action:@selector(forwardingInvocationMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forwardingInvocationBtn;
}


@end
