//
//  LTPerspectiveImageViewManager.m
//  FlygoHomeViewController
//
//  Created by 范舟弛 on 2017/6/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "LTPerspectiveImageViewManager.h"
#import "LTPerspectiveImageView.h"

@implementation LTPerspectiveImageViewManager

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

- (UIView *)view
{
  return [[LTPerspectiveImageView alloc] initWithBridge:_bridge];
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

RCT_EXPORT_VIEW_PROPERTY(uri, NSString);
RCT_EXPORT_VIEW_PROPERTY(offset, CGFloat);

@end
