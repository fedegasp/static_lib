//
//  MRTextView.h
//  MASClient
//
//  Created by Enrico Cupellini on 14/09/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRTextView : UITextView

@property (nonatomic, strong) NSNumber* insetTop;
@property (nonatomic, strong) NSNumber* insetLeft;

@property (nonatomic, strong) UIColor *borderColor;
//for textFields inside tableView
@property (nonatomic, strong)NSIndexPath *indexPath;
//dinamic changes
//-(void)setLocalizedText:(NSString*)text;

@end
