//
//  MRViewModel.h
//  MRComponents
//
//  Created by Enrico Cupellini on 15/09/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRPlaceholderTextView.h"

@interface MRViewModel : UIView

+(NSMutableDictionary*)getModelWithIdentifier:(NSString*)identifier tag:(NSInteger)tag andObject:(id)obj;
+(NSMutableDictionary*)getModelWithIdentifier:(NSString*)identifier tag:(NSInteger)tag;

/*!
 * textArray can contain NSString or NSAttributedString objects
 */
+(void)setLabelModel:(NSMutableDictionary*)viewModel withTextArray:(NSArray<id>*)textArray;

/*!
 * imageArray can contain NSString or NSURL objects
 */
+(void)setImageModel:(NSMutableDictionary*)viewModel withImageArray:(NSArray<id>*)imageArray placeHolder:(NSString*)placeHolder;

+(void)setWebViewModel:(NSMutableDictionary*)viewModel withUrlArray:(NSArray<NSURL*>*)urlArray;

+(void)setButtonModel:(NSMutableDictionary*)viewModel buttonEnabled:(NSArray<NSNumber*>*)buttonEnabled buttonHidden:(NSArray<NSNumber*>*)buttonHidden;

+(void)setTextFieldModel:(NSMutableDictionary*)viewModel withTextArray:(NSArray<NSString*>*)textArray placeholder:(NSArray<NSString*>*)placeholder enabled:(NSArray<NSNumber*>*)enabled;

+(void)setTextViewModel:(NSMutableDictionary*)viewModel withTextArray:(NSArray<NSString*>*)textArray placeholder:(NSArray<NSString*>*)placeholder;

+(void)setViewModels:(NSMutableDictionary*)viewModel withColorArray:(NSArray<UIColor*>*)colorArray;

+(void)setViewModels:(NSMutableDictionary*)viewModel withCustomValue:(NSObject*)v forKey:(NSString*)k;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *label;
@property (strong, nonatomic) IBOutletCollection(UIImageView)NSArray *image;
@property (strong, nonatomic) IBOutletCollection(UITextField)NSArray *textField;
@property (strong, nonatomic) IBOutletCollection(UITextView)NSArray *textView;
@property (strong, nonatomic) IBOutletCollection(UIWebView)NSArray *webView;
@property (strong, nonatomic) IBOutletCollection(UIButton)NSArray *button;
@property (strong, nonatomic) IBOutletCollection(UIView)NSArray *view;

-(void)setContent:(id)content;

@end
