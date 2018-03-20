//
//  NibEmbeddingView.h
//  MASClient
//
//  Created by Federico Gasperini on 19/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NibEmbeddingView : UIView

@property (strong, nonatomic) IBInspectable NSString* nibName;
@property (assign, nonatomic) IBInspectable NSUInteger objectIndex;

@property (assign, nonatomic) IBInspectable UIEdgeInsets edgeInset;
@property (assign, nonatomic) IBInspectable BOOL centerContent;

@property (readonly) UIView* embeddedView;

@end
