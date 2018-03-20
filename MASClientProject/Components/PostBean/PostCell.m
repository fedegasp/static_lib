//
//  PostCell.m
//  MASClient
//
//  Created by Gai, Fabio on 17/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

-(void)setContent:(id)content
{
   [super setContent:content];
   [self setPostData:content];
}

-(void)prepareForReuse
{
   [super prepareForReuse];
}

@end
