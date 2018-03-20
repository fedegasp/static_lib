//
//  MRCalendarCell.h
//  calendar
//
//  Created by Federico Gasperini on 19/04/17.
//  Copyright © 2017 Accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRCalendarCell : UICollectionViewCell

@property (nonatomic, strong) NSDate* date;

@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger year;

@property (weak, nonatomic, nullable) IBOutlet UILabel* dayLabel;

@property (nonatomic, assign, getter=isPast) BOOL past;
@property (nonatomic, assign, getter=isFuture) BOOL future;

@end

NS_ASSUME_NONNULL_END
