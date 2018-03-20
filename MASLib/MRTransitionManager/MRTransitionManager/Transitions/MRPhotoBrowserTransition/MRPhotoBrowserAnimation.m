//
//  CustomAnimation.m
//  material
//
//  Created by Gai, Fabio on 31/08/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRPhotoBrowserAnimation.h"
#import "UIImageView+ContentMode.h"

@implementation MRPhotoBrowserAnimation

-(void)prepareForPresentation{
    [self showSubviews:NO duration:0];
}

-(void)presentViewController:(UIViewController *)modalViewController
          fromViewController:(UIViewController *)mainViewController
           transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [self createModalImage];
    CGSize s = [self.modalImage aspectFitInController:modalViewController];
    BOOL   isNaN= isnan(s.width);
    if (!isNaN) {
        
        [transitionContext.containerView addSubview:modalViewController.view];
        [self prepareModalViewController:modalViewController];
        
        [UIView animateWithDuration:0.5 animations:^{
            modalViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        }];
        
        [UIView animateWithDuration: .6
                              delay: 0
             usingSpringWithDamping: .8
              initialSpringVelocity: 2
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             self.modalImage.frame = CGRectMake(0, 0, s.width, s.height);
                             self.modalImage.center = modalViewController.view.center;
                             
                         } completion:^(BOOL finished) {
                             
                             [self createPhotoBrowser:modalViewController];
                             [self.modalImage removeFromSuperview];
                             [transitionContext completeTransition:YES];
                             [self showSubviews:YES duration:0.15];
                             NSLog(@"");
                         }];
    }else{
        [transitionContext completeTransition:YES];
        [modalViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
}

-(void)prepareModalViewController:(UIViewController *)modalViewController{
    
    modalViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [modalViewController.view addSubview:self.modalImage];
}

-(void)createModalImage{
    
    _mainImage = [self.mainDelegate photoBrowserMainImageForPage:_currentPage.intValue];
    self.modalImage = [[UIImageView alloc] init];
    self.modalImage.frame = self.mainFrame;
    self.modalImage.image = self.mainImage.image;
    self.modalImage.contentMode = UIViewContentModeScaleAspectFill;
    self.modalImage.layer.masksToBounds = NO;
    self.mainImage.hidden = YES;
    [self.modalView layoutIfNeeded];
    
}

-(void)createPhotoBrowser:(UIViewController *)modalViewController{
    
    _pbScrollView = [[MRPhotoBrowserScrollView alloc] initWithFrame:modalViewController.view.frame
                                                       modalImage:self.modalImage
                                                       pbDelegate:self
                                                      currentPage:self.currentPage.intValue];
    //[modalViewController.view addSubview:_pbScrollView];
    [modalViewController.view insertSubview:_pbScrollView atIndex:0];
    modalViewController.closePanningView = _pbScrollView.currentImageView;
}

-(CGRect)mainFrame
{
    return [self.mainImage convertRect:self.mainImage.bounds toView:self.mainImage.window];
}

-(void)dismissViewController:(UIViewController *)modalViewController
         popToViewController:(UIViewController *)mainViewController
           transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext{

    
    [self showSubviews:NO duration:0.15];
    [UIView animateWithDuration:0.5 animations:^{
        modalViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        
    }];
    
    _pbScrollView.currentImageView.layer.masksToBounds = YES;
    [UIView animateWithDuration: .7
                          delay: 0
         usingSpringWithDamping: .8
          initialSpringVelocity: 2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect f = [self.mainImage convertRect:self.mainImage.bounds toView:self.mainImage.window];
                         _pbScrollView.currentImageView.frame = f;
                     } completion:^(BOOL finished) {
                         [self.mainDelegate photoBrowserIsDismissed];
                         self.mainImage.hidden = NO;
                         [_pbScrollView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}


-(void)panToDismissViewController:(UIViewController *)modalViewController
                    onPanningView:(UIView *)panningView
              popToViewController:(UIViewController *)mainViewController
                       recognizer:(UIPanGestureRecognizer *)recognizer
{
    if (_pbScrollView.currentImageView.tag == 1) {
        
        CGPoint translation = [recognizer translationInView:modalViewController.view];
        CGFloat percentage = translation.y/panningView.frame.size.height;
        CGPoint displacement = CGPointMake(translation.x, translation.y);
        __block CGFloat alpha = 1 - ((percentage < 0 ? -percentage : percentage)*1.5);
        
        switch (recognizer.state) {
            case UIGestureRecognizerStateBegan:
                [self.mainDelegate photoBrowserIsStartingDismissed];
                [self showSubviews:NO duration:0.15];
                break;
                
            case UIGestureRecognizerStateChanged:
                modalViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
                _pbScrollView.currentImageView.transform = CGAffineTransformMakeTranslation(displacement.x, displacement.y);
                break;
                
            case UIGestureRecognizerStateEnded:
                if (alpha < 0.8) {
                    [modalViewController dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self showSubviews:YES duration:0.15];
                    [UIView animateWithDuration: .5
                                          delay: 0
                         usingSpringWithDamping: .8
                          initialSpringVelocity: 2
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         alpha = 1;
                                         modalViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
                                         _pbScrollView.currentImageView.transform = CGAffineTransformIdentity;
                                     } completion:nil];
                }
                
                break;
                
            default:
                break;
        }
    }
}


-(void)showSubviews:(BOOL)show duration:(CGFloat)duration{
    for (UIView *v in self.modalViewController.view.subviews) {
        if (v != _pbScrollView) {
            [UIView animateWithDuration:duration animations:^{
                v.alpha = show ? 1 : 0;
            }];
        }
    }
}

-(NSArray *)photoBrowserDatasource{
    return [self.mainDelegate photoBrowserDatasource];
}

-(void)photoBrowserDidChangePage:(int)page{
    [self.modalDelegate photoBrowserDidChangePage:page];
    [self.mainDelegate photoBrowserDidChangePage:page];
    [self setCurrentPage:[NSNumber numberWithInteger:page]];
    [_mainImage setHidden:NO];
    _mainImage = [self.mainDelegate photoBrowserMainImageForPage:_currentPage.intValue];
    [_mainImage setHidden:YES];
}

-(void)photoBrowserIsZoomed:(BOOL)zoomed{
    [self showSubviews:!zoomed duration:0.15];
}

@end
