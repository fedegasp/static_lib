//
//  MRPoppingScrollChainedDelegate.h
//  MRUXFacilities
//
//  Created by Federico Gasperini on 31/05/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

@import UIKit;
#import <MRBase/MRChainedDelegate.h>

@interface MRPoppingScrollChainedDelegate : MRChainedDelegate

@property (assign, nonatomic) IBInspectable CGFloat treshold;
@property (assign, nonatomic) IBInspectable CGFloat poppingSize;

@end
