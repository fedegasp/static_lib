//
//  PhotoBrowserScrollView.m
//  TransitionManager
//
//  Created by Gai, Fabio on 13/09/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRPhotoBrowserScrollView.h"
#import "UIImageView+ContentMode.h"

@implementation MRPhotoBrowserScrollView

-(instancetype) initWithFrame:(CGRect)frame
                   modalImage:(UIImageView *)modalImage
                   pbDelegate:(id<MRPhotoBrowserScrollViewDelegate>)pbdelegate
                  currentPage:(int)currentPage{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        _photosImageview = [[NSMutableArray alloc] init];
        _photosScrollView = [[NSMutableArray alloc] init];
        _modalImage = modalImage;
        _pbdelegate = pbdelegate;
        _currentPage = currentPage;
        [self setup];
    }
    return self;
}

-(void)setup{
    
    _photos = [self.pbdelegate photoBrowserDatasource];
    NSInteger i = 0;
    for (id imageName in _photos)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        if ([imageName isKindOfClass:[NSURL class]]) {
            [self setImageView:imageView
               withPlaceholder:@""//TRAVEL_PLACEHOLDER
                        andUrl:imageName];
        }else{
            imageView.image =  [UIImage imageNamed:imageName];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = NO;
        imageView.tag = 1;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i,
                                                                                  0,
                                                                                  self.frame.size.width,
                                                                                  self.frame.size.height)];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 4.0f;
        scrollView.minimumZoomScale = 1.0;
        imageView.frame = CGRectMake(self.modalImage.frame.origin.x,
                                     self.modalImage.frame.origin.y,
                                     self.frame.size.width,
                                     self.modalImage.frame.size.height);
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView addSubview:imageView];
        [self addSubview:scrollView];
        [_photosImageview addObject:imageView];
        [_photosScrollView addObject:scrollView];
        i++;
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width*_photos.count, self.frame.size.height);
    self.contentOffset = CGPointMake(self.frame.size.width*_currentPage, 0);
    self.pagingEnabled = YES;
    
    _currentImageView = _photosImageview[_currentPage];
    _currentImageView.tag = 1;
    
    [self addTapGesture];
    
}



-(void)addTapGesture{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    UIScrollView *sv = _photosScrollView[_currentPage];
    if(sv.zoomScale > sv.minimumZoomScale)
        [sv setZoomScale:sv.minimumZoomScale animated:YES];
    else
        [sv setZoomScale:sv.maximumZoomScale/2 animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _currentImageView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _currentPage = self.contentOffset.x / self.frame.size.width;
    _currentImageView = _photosImageview[_currentPage];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.pbdelegate photoBrowserDidChangePage:_currentPage];
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
    _currentImageView.tag = enable ? 1 : 0;
    [self.pbdelegate photoBrowserIsZoomed:!enable];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self.pbdelegate photoBrowserIsZoomed:scrollView.zoomScale == 1 ? NO : YES];
    _currentImageView.frame = [self centeredFrameForScrollView:scrollView andUIView:_currentImageView];;
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

-(void)setImageView:(UIImageView*)imageView
    withPlaceholder:(NSString *)placeholder
             andUrl:(NSURL *)url{
    
    if (imageView != nil) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPShouldHandleCookies:NO];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        //__weak typeof (imageView) weakSelf = imageView;
        //imageView.image
        
        /*[weakSelf setImageWithURLRequest:request
                        placeholderImage:[UIImage imageNamed:placeholder]
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                     if (!response){
                                         [weakSelf setImage:image];
                                     }else{
                                         [UIView transitionWithView:weakSelf duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                             [weakSelf setImage:image];
                                         } completion:nil];
                                     }
                                     
                                     CGSize s = [weakSelf aspectFitInView:self];
                                     imageView.frame = CGRectMake(0,
                                                                 0,
                                                                 s.width,
                                                                 s.height);
                                     imageView.center = self.center;
                                     
                                 } failure:nil];*/
    }
}


@end
