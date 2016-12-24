//
//  UIResponder+FirstResponder.m
//  Blink
//
//  Created by Atul M on 21/12/16.
//  Copyright © 2016 Carlos Cabañero Projects SL. All rights reserved.
//

#import "UIResponder+FirstResponder.h"
#import <objc/runtime.h>

static char const * const aKey = "first";
@implementation UIResponder (FirstResponder)

- (id) currentFirstResponder {
  [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:self forEvent:nil];
  id obj = objc_getAssociatedObject (self, aKey);
  objc_setAssociatedObject (self, aKey, nil, OBJC_ASSOCIATION_ASSIGN);
  return obj;
}

- (void) setCurrentFirstResponder:(id) aResponder {
  objc_setAssociatedObject (self, aKey, aResponder, OBJC_ASSOCIATION_ASSIGN);
}

- (void) findFirstResponder:(id) sender {
  [sender setCurrentFirstResponder:self];
}

@end
