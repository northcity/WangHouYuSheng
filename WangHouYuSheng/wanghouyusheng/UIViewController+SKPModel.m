//
//  UIViewController+SKPModel.m
//  wanghouyusheng
//
//  Created by 北城 on 2020/3/24.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import "UIViewController+SKPModel.h"
#import <objc/runtime.h>


@implementation UIViewController (SKPModel)

+(void)load{
       Method m1 = class_getInstanceMethod([self class], @selector(presentViewController:animated:completion:));
       Method m2 = class_getInstanceMethod([self class], @selector(skp_presentViewController:animated:completion:));
       method_exchangeImplementations(m1, m2);
}
- (void)skp_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
    viewControllerToPresent.modalPresentationStyle =  UIModalPresentationFullScreen;
    [self skp_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
