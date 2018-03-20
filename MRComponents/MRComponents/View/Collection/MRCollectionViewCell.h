//
//  MRCollectionViewCell.h
//  MRComponents
//
//  Created by Enrico Cupellini on 15/09/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MRBase/UICollectionViewCell+MRUtil.h>

@interface MRCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *label;
@property (strong, nonatomic) IBOutletCollection(UIImageView)NSArray *image;
@property (strong, nonatomic) IBOutletCollection(UITextField)NSArray *textField;
@property (strong, nonatomic) IBOutletCollection(UITextView)NSArray *textView;
@property (strong, nonatomic) IBOutletCollection(UIWebView)NSArray *webView;
@property (strong, nonatomic) IBOutletCollection(UIButton)NSArray *button;
@property (strong, nonatomic) IBOutletCollection(UIView)NSArray *view;

@end
