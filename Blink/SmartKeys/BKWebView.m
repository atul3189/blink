//
//  BKWebView.m
//  Blink
//
//  Created by Atul M on 28/12/16.
//  Copyright © 2016 Carlos Cabañero Projects SL. All rights reserved.
//

#import "BKWebView.h"

@implementation BKWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)inputAccessoryView{
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
  label.text = @"Bottom Bar...";
  label.backgroundColor = [UIColor yellowColor];
  return label;
}

- (BOOL)canBecomeFirstResponder{
  return YES;
}
@end
