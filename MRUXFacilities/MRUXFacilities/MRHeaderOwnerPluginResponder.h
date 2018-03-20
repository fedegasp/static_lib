//
//  MRHeaderOwnerPluginResponder.h
//  MRUXFacilities
//
//  Created by Federico Gasperini on 09/08/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import <MRBase/PlugInResponder.h>
#import "MRHeaderScrollChainedDelegate.h"

@interface UIViewController ()

-(void)headerScrollingPercentage:(CGFloat)p;

@end

@interface MRHeaderOwnerPluginResponder : PlugInResponder <HeaderOwner>

@property (assign, getter=isEnabled, nonatomic) IBInspectable BOOL enabled;
@property (assign, nonatomic) IBInspectable BOOL scrollDownImmediatly;
@property (assign, nonatomic) IBInspectable BOOL adjustContentOffset;
@property (assign, nonatomic) IBInspectable BOOL magneticEdges;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* headerHeightConstraint;

@end
