//
//  PhotoViewerButton.m
//  dpr
//
//  Created by Gai, Fabio on 24/09/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRPhotoViewerButton.h"
#import "MRTransitionManager.h"

@implementation MRPhotoViewerButton

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addTarget:self action:@selector(openImage) forControlEvents:UIControlEventTouchUpInside];
}

-(void)openImage{
    
    UIStoryboard *st = [UIStoryboard storyboardWithName:self.storyboard bundle:nil];
    UIViewController *v = [st instantiateViewControllerWithIdentifier:self.identifier];
    MRTransitionManager *manager = (MRTransitionManager *)v.transitioningDelegate;
    self.modalPhotoViewerTransition = (MRPhotoViewerTransition *)manager.transitionObject;
    self.modalPhotoViewerTransition.mainImage = self.mainImage;
    self.mainViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.mainViewController presentViewController:v animated:YES completion:nil];
    
}

@end
