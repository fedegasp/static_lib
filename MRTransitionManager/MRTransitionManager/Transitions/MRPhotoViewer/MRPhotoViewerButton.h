//
//  PhotoViewerButton.h
//  dpr
//
//  Created by Gai, Fabio on 24/09/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRPhotoViewerTransition.h"

@interface MRPhotoViewerButton : UIButton
@property MRPhotoViewerTransition *modalPhotoViewerTransition;
@property (weak, nonatomic) IBOutlet UIViewController *mainViewController;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property IBInspectable NSString *storyboard;
@property IBInspectable NSString *identifier;
@end
