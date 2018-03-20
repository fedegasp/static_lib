//
//  TabContent.m
//  MRTabController
//
//  Created by Gai, Fabio on 20/10/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "TabContent.h"
#import <MRBase/lib.h>

@implementation TabContent

-(void)setContent:(id)content{
    self.label.text = [NSString stringWithFormat:@"index %li", (long)self.collectionIndexPath.row];
}

-(void)setSelected:(BOOL)selected{
    if ([self.parentCollectionView tag] != 2) {
        //the content it's shared, but it's only an example. use different content in real app.
        if (selected) {
            self.backgroundColor = [UIColor whiteColor];
            self.label.textColor = [UIColor darkGrayColor];
        }else{
            self.backgroundColor = [UIColor clearColor];
            self.label.textColor = [UIColor whiteColor];
        }
    }
    
}

@end
