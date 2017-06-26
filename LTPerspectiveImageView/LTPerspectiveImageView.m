//
//  LTPerspectiveImageView.m
//  FlygoHomeViewController
//
//  Created by 范舟弛 on 2017/6/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "LTPerspectiveImageView.h"
#import <React/RCTImageLoader.h>

@interface LTPerspectiveImageView ()
@property (nonatomic, weak, nullable) UIScrollView *scrollView;
@end

@implementation LTPerspectiveImageView {
  CGFloat _offset;
  CGSize _imageSize;
  NSURLRequest *_urlRequest;
  RCTBridge *_bridge;
  CALayer *_imageLayer;
  RCTImageLoaderCancellationBlock _cancellationBlock;
}
@synthesize scrollView = _scrollView;

#pragma mark -- react brage
- (void)setUri:(NSString *)uri {
  if (uri.length == 0) {
    _urlRequest = nil;
  } else {
    NSURL *url = [[NSURL alloc] initWithString:uri];
    
    if (url == nil) {
      _urlRequest = nil;
    } else {
      _urlRequest = [[NSURLRequest alloc] initWithURL:url];
    }
  }
  
  [self loadImage];
}

- (void)setOffset:(CGFloat)offset {
  _offset = offset;
  
  CGSize imageSize = self.bounds.size;
  
  imageSize.height += offset;
  
  [self setImageSize:imageSize];
}

#pragma mark -- property
- (void)setImageSize:(CGSize)imageSize {
  _imageSize = imageSize;
  
  [self loadImage];
  [self layoutImageView];
}

- (void)layoutImageView {
  /// check condition
  if (_imageSize.width == 0 || _imageSize.height == 0) {
    return;
  }
  
  CGSize selfSize = self.bounds.size;
  
  if (selfSize.width == 0 || selfSize.height == 0) {
    return;
  }
  
  if (self.scrollView == nil) {
    return;
  }
  
  UIView *superview = self.superview;
  
  if (superview == nil) {
    return;
  }
  
  /// set position
  CGFloat cy = self.scrollView.contentOffset.y;
  
  CGFloat scrollHeight = self.scrollView.bounds.size.height;
  
  CGFloat selfHeight = selfSize.height;
  
  CGFloat ry = [self.superview convertPoint:self.frame.origin
                                     toView:self.scrollView].y;
  
  CGFloat startLocY = cy - selfHeight;
  
  CGFloat lenY = selfHeight * 2 + scrollHeight;
  
  CGFloat radio = MAX(MIN(0.0, (startLocY - ry) / lenY), -1.0);
  
  [CATransaction begin];
  [CATransaction setValue:(id)kCFBooleanTrue
                   forKey:kCATransactionDisableActions];
  
  _imageLayer.frame = CGRectMake(0,
                                 _offset * radio,
                                 _imageSize.width,
                                 _imageSize.height);
  
  [CATransaction commit];
}

- (void)setScrollView:(UIScrollView *)scrollView {
  if (_scrollView != nil) {
    [_scrollView removeObserver:self
                     forKeyPath:@"contentOffset"];
  }
  
  _scrollView = scrollView;
  
  if (_scrollView != nil) {
    [_scrollView addObserver:self
                  forKeyPath:@"contentOffset"
                     options:NSKeyValueObservingOptionNew || NSKeyValueChangeOldKey
                     context:nil];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  if (object == _scrollView && [keyPath isEqualToString:@"contentOffset"]) {
    [self layoutImageView];
  }
}

+ (UIScrollView *)getScrollViewFromSuperView:(UIView *)superview {
  if (superview == nil) {
    return nil;
  }
  
  if ([superview isKindOfClass:[UIScrollView class]]) {
    return (id)superview;
  }
  
  return [self getScrollViewFromSuperView:superview.superview];
}

- (void)dealloc {
  self.scrollView = nil;
}

- (id)initWithBridge:(RCTBridge *)bridge {
  if (self = [super init]) {
    _offset = 5;
    
    _bridge = bridge;
    
    _imageLayer = [CALayer layer];
    
    [self.layer addSublayer:_imageLayer];
    
    _imageLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    self.clipsToBounds = YES;
  }
  
  return self;
}

#pragma mark -- adjust ui
- (void)didMoveToWindow {
  [super didMoveToWindow];
  
  if (!self.window) {
    self.scrollView = nil;
    
    return;
  }
  
  self.scrollView = [LTPerspectiveImageView getScrollViewFromSuperView:self.superview];
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  
  if (!self.superview) {
    self.scrollView = nil;
    
    return;
  }
  
  self.scrollView = [LTPerspectiveImageView getScrollViewFromSuperView:self.superview];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self setOffset:_offset];
}

#pragma mark -- request imgae
- (void)loadImage {
  if (_cancellationBlock != nil) {
    _cancellationBlock();
  }
  
  if (_imageSize.width == 0 || _imageSize.height == 0) {
    return;
  }
  
  if (_urlRequest == nil) {
    return;
  }
  
  _imageLayer.contents = nil;
  
  CALayer *imageLayer =  _imageLayer;
  
  _cancellationBlock = [_bridge.imageLoader loadImageWithURLRequest:_urlRequest
                                                                size:_imageSize
                                                               scale:[[UIScreen mainScreen] scale]
                                                             clipped:NO
                                                          resizeMode:RCTResizeModeContain
                                                       progressBlock:^(int64_t progress, int64_t total) {
                                                       }
                                                    partialLoadBlock:^(UIImage *image) {
//                                                      _imageLayer.contents = (__bridge id _Nullable)(image.CGImage);
                                                    }
                                                     completionBlock:^(NSError *error, UIImage *image) {
                                                       
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                         imageLayer.contents = (__bridge id _Nullable)(image.CGImage);
                                                       });
                                                       
                                                       
                                                       
//                                                       NSLog(@"layer is %@", _imageLayer);
                                                     }];
}

@end
