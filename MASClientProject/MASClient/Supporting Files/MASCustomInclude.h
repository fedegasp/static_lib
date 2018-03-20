//
//  MASCustomInclude.h
//  MASClient
//
//  Created by Federico Gasperini on 25/01/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#ifndef MASCustomInclude_h
#define MASCustomInclude_h

#import "UITableViewCell+utility.h"
#import "UIViewController+Handler.h"
#import "NotificationView.h"
#import "NavigationManager.h"
#import "NSObject+Post.h"

@interface NSObject ()

-(NSString*)isp_tableViewCellIdentifier;

@end

#define setNotifyPerforming notifyPerformingOn:self

#endif /* MASCustomInclude_h */
