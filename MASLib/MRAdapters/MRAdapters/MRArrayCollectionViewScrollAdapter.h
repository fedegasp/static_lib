//
//  TLCArrayCollectionVewScrollAdapter.h
//  Telco
//
//  Created by Federico Gasperini on 06/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRArrayCollectionViewAdapter.h"

@interface MRArrayCollectionViewScrollAdapter : MRArrayCollectionViewAdapter

@property (strong, nonatomic) IBOutlet UIPageControl* pageControl;

@end
