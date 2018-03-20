//
//  SideMenuViewController.h
//  MASClient
//
//  Created by Gai, Fabio on 26/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

@interface SideMenuViewController : MRViewController
@property IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainConstraint;
@property IBOutlet UIButton *dismissButton;
-(IBAction)closeMenu:(id)sender;
@end
