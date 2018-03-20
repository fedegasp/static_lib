//
//  MRMacros.h
//  MRBase
//
//  Created by Federico Gasperini on 27/10/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

//#ifndef MRMacros_h
//#define MRMacros_h

NSString* DocumentsDirectory(void);
NSString* LibraryDirectory(void);

#define __BLOCK_VAR_NAME(X) _##X
#define BLOCK_REF(X) __block typeof(X) __BLOCK_VAR_NAME(X) = X
#define COPY_BLOCK_REF(X) __block typeof(X) __BLOCK_VAR_NAME(X) = [X copy]
#define WEAK_REF(X) typeof(X) __weak __BLOCK_VAR_NAME(X) = X
#define BLOCK_REF_NAMED(X, Y) __block typeof(Y) X = Y

#if DISTRIBUTION

#define LOG_ON_CONSOLE (YES)
#define NSLog(...) do {} while (0)

#else

#define LOG_ON_CONSOLE ([[NSUserDefaults standardUserDefaults] boolForKey:@"LOG_ON_CONSOLE"])
// workaround a bug in Xcode 8.1.2 with iOS 10.x that truncates log
//#define NSLog(...) NSLog(__VA_ARGS__)
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

#endif

#define DEFAULT_ANIMATION_DURATION .3
#define SPEEDY_ANIMATION_DURATION .15

#define IS_PORTRAIT UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation)
#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define CA_TRANSACTION(X) do { [CATransaction begin]; { X } [CATransaction commit]; } while (0)

//#endif /* MRMacros_h */
