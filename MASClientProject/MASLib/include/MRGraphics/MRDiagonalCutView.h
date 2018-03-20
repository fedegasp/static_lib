//
//  MRDiagonalCutView.h
//  MRGraphics
//
//  Created by Federico Gasperini on 31/05/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MRDiagonalDirection) {
   MRDiagonalDirectionBottomLeftTopRight,
   MRDiagonalDirectionTopLeftBottomRight
};

@interface MRDiagonalCutView : UIView

@property (strong, nonatomic) IBInspectable UIColor* upColor;
@property (strong, nonatomic) IBInspectable UIColor* bottomColor;

@property (nonatomic, assign) MRDiagonalDirection diagonalDirection;

@end


@interface MRDiagonalCutView (ibinspectable)

@property (nonatomic, assign) IBInspectable NSInteger diagonalDirection;

@end

