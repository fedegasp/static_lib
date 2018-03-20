//
//  UICollectionViewCell+MRContent.h
//  CollectionSlider
//
//  Created by Gai, Fabio on 20/04/15.
//  Copyright (c) 2015 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static const char _indexPath_collection;
static const char _parent_flow_layout;

@interface UICollectionReusableView (MRCarouselHeader)
-(void)setContent:(id)content;
@end

@implementation UICollectionReusableView (MRCarouselHeader)
-(void)setContent:(id)content{
}
@end


@interface UICollectionViewFlowLayout (flowLayout)
@property (nonatomic) id parent;
@end

@implementation UICollectionViewFlowLayout (flowLayout)
-(id)parent
{
    return objc_getAssociatedObject(self, &_parent_flow_layout);
}
-(void)setParent:(id)parent
{
    objc_setAssociatedObject(self, &_parent_flow_layout, parent, OBJC_ASSOCIATION_RETAIN);
}
@end
