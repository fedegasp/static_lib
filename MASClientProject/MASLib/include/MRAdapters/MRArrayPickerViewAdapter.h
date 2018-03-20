//
//  MRArrayPickerViewAdapter.h
//  Ax
//
//  Created by Federico Gasperini on 02/03/15.
//  Copyright (c) 2015 Federico Gasperini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject ()

-(NSString*)pikerViewTitle;

@end


@protocol MRArrayPickerViewAdapterDelegate <UIPickerViewDelegate>

@optional
-(void)pickerView:(UIPickerView *)pickerView didSelect:(NSArray*)selection;

@end

typedef NSString* (^TitleBlock)(id, NSInteger);

@interface MRArrayPickerViewAdapter : NSObject <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet id<MRArrayPickerViewAdapterDelegate> adapterDelegate;
@property (weak, nonatomic) IBOutlet UIPickerView* pickerView;
@property (strong, nonatomic) IBOutletCollection(NSObject) NSMutableArray* data;
@property (strong, nonatomic) IBInspectable NSString* plistSource;
@property (strong, nonatomic) IBInspectable NSString* dataString;

@property (copy, nonatomic) TitleBlock titleBlock;

-(void)setInitialValues:(NSArray*)value;

@end

@interface NSNumber (pikerViewTitle)

-(NSString*)pikerViewTitle;

@end
