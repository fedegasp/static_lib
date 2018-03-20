//
//  MRToolBarAdditions.h
//  MRNavigationController
//
//  Created by Enrico Cupellini on 18/02/18.
//  Copyright © 2018 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MRBase/lib.h>

@protocol MRToolBarAdditions

@property (nonatomic, assign) IBInspectable BOOL showToolBar;

@end

@interface MRToolBarAdditions : MRNotifyingObject<MRToolBarAdditions>

@property (nonatomic, assign) IBInspectable BOOL showToolBar;

@property (nonatomic, weak)IBOutlet id _Nullable toolBarOwner;

@end
