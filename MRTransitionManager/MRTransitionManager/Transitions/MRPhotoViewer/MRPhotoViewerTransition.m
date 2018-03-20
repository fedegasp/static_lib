//
//  PhotoViewerTransition.m
//  dpr
//
//  Created by Gai, Fabio on 24/09/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRPhotoViewerTransition.h"
#import "UIImageView+ContentMode.h"

@implementation MRPhotoViewerTransition

-(void)prepareForPresentation{
    [self showSubviews:NO duration:0];
}

-(void)presentViewController:(UIViewController *)modalViewController
          fromViewController:(UIViewController *)mainViewController
           transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [self createModalImage];
    [self enableGestures:YES];
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
                             self.modalImage.layer.cornerRadius = 0;
                             
                             
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                             [self showSubviews:YES duration:0.15];
                         }];
    }else{
        [transitionContext completeTransition:YES];
        [modalViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
}

-(void)prepareModalViewController:(UIViewController *)modalViewController{
    
    modalViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.scrollView = [[UIScrollView alloc] initWithFrame:modalViewController.view.frame];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 4.0f;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:self.modalImage];
    [modalViewController.view insertSubview:self.scrollView atIndex:0];
}

-(void)createModalImage{
    
    self.modalImage = [[UIImageView alloc] init];
    self.modalImage.frame = self.mainFrame;
    self.modalImage.image = self.mainImage.image;
    self.modalImage.contentMode = UIViewContentModeScaleAspectFill;
    self.modalImage.layer.masksToBounds = NO;
    self.mainImage.hidden = YES;
    self.modalImage.layer.cornerRadius = self.mainImage.layer.cornerRadius;
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
        self.modalImage.layer.cornerRadius = self.mainImage.layer.cornerRadius;
        modalViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        
    }];
    
    self.modalImage.layer.masksToBounds = YES;
    [UIView animateWithDuration: .7
                          delay: 0
         usingSpringWithDamping: .8
          initialSpringVelocity: 2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect f = [self.mainImage convertRect:self.mainImage.bounds toView:self.mainImage.window];
                         _modalImage.frame = f;
                     } completion:^(BOOL finished) {
                         self.mainImage.hidden = NO;
                         [self.modalImage removeFromSuperview];
                         [transitionContext completeTransition:YES];
                         if ([self.delegate respondsToSelector:@selector(photoViewerIsDismissed)]) {
                             [self.delegate photoViewerIsDismissed];
                         }
                     }];
}


-(void)panToDismissViewController:(UIViewController *)modalViewController
                    onPanningView:(UIView *)panningView
              popToViewController:(UIViewController *)mainViewController
                       recognizer:(UIPanGestureRecognizer *)recognizer
{
    if (self.modalImage.tag == 1) {
        
        CGPoint translation = [recognizer translationInView:modalViewController.view];
        CGFloat percentage = translation.y/panningView.frame.size.height;
        CGPoint displacement = CGPointMake(translation.x, translation.y);
        __block CGFloat alpha = 1 - ((percentage < 0 ? -percentage : percentage)*1.5);
        
        switch (recognizer.state) {
            case UIGestureRecognizerStateBegan:
                [self showSubviews:NO duration:0.15];
                break;
                
            case UIGestureRecognizerStateChanged:
                modalViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
                self.modalImage.transform = CGAffineTransformMakeTranslation(displacement.x, displacement.y);
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
                                         self.modalImage.transform = CGAffineTransformIdentity;
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
        if (v != self.scrollView) {
            [UIView animateWithDuration:duration animations:^{
                v.alpha = show ? 1 : 0;
            }];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.modalImage;
}


-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                      withView:(UIView *)view
                       atScale:(CGFloat)scale{
    if (scale == 1) {
        [self enableGestures:YES];
    }else{
        [self enableGestures:NO];
    }
}

-(void)enableGestures:(BOOL)enable{
    self.modalImage.tag = enable ? 1 : 0;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.modalImage.frame = [self centeredFrameForScrollView:scrollView andUIView:self.modalImage];
    if (scrollView.zoomScale <= 1) {
        [self showSubviews:YES duration:0.15];
    }else{
        [self showSubviews:NO duration:0.15];
    }
}

-(CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    frameToCenter.origin.x = 0;
    frameToCenter.origin.y = 0;
    
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    
    return frameToCenter;
}



@end
