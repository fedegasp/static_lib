//
//  MRExpandCellTableViewDelegate.h
//  MRAdapter
//
//  Created by Federico Gasperini on 16/03/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MRBase/MRChainedDelegate.h>

@interface MRExpandCellTableViewDelegate : MRChainedDelegate

@property (assign) IBInspectable CGFloat normalHeight;
@property (assign) IBInspectable CGFloat selectedHeight;

@end
