//
//  ErrorLabel.h
//  MASClient
//
//  Created by Gai, Fabio on 20/07/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorLabel : UILabel <ErrorStateView>
@property IBInspectable UIColor *errorColor;
@property IBInspectable UIColor *normalColor;
@end
