//
//  INGEnhancerListController.m
//  INGEnhancer
//
//  Created by iMokhles on 06.09.2015.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import "INGEnhancerHelper.h"

@implementation INGEnhancerPhoto

@end

@implementation INGEnhancerHelper

// Preferences
+ (NSString *)preferencesPath {
	return @"/User/Library/Preferences/com.imokhles.ingenhancer.plist";
}

+ (CFStringRef)preferencesChanged {
	return (__bridge CFStringRef)@"com.imokhles.ingenhancer.preferences-changed";
}

// UIWindow to present your elements
// u can show/hide it using ( setHidden: NO/YES )
+ (UIWindow *)mainINGEnhancerWindow {
	return [[UIApplication sharedApplication] windows][0];
}

+ (UIViewController *)mainINGEnhancerViewController {
	return self.mainINGEnhancerWindow.rootViewController;
}

// Instagram Stuffs
+ (NSString *)insta_DocumentsPath {
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString  *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

+ (void)addNotificationFromObserver:(id)target withName:(NSString *)notiName andSelector:(SEL)aSelector {
	[[NSNotificationCenter defaultCenter] addObserver:target selector:aSelector name:notiName object:nil];
}
+ (void)postNotificationWithName:(NSString *)notiName andObject:(id)object {
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:notiName object:object userInfo:nil];
}

+ (NSURL *)urlFromVersionArray:(NSArray *)versions {

	/* Images Versions Output
	Sep  6 04:48:12 iPad Instagram[2977] <Warning>: ********* Images (
	        {
	        height = 150;
	        url = "http://scontent-cdg2-1.cdninstagram.com/hphotos-xfa1/t51.2885-15/s150x150/e35/11909351_893155867441203_392587202_n.jpg#ig_cache_key=MTA2NzY2MTg5NDY4MTY3MTEzMQ==.2w150h150";
	        width = 150;
	    },
	        {
	        height = 240;
	        url = "http://scontent-cdg2-1.cdninstagram.com/hphotos-xfa1/t51.2885-15/s240x240/e35/11909351_893155867441203_392587202_n.jpg#ig_cache_key=MTA2NzY2MTg5NDY4MTY3MTEzMQ==.2w240h240";
	        width = 240;
	    },
	        {
	        height = 320;
	        url = "http://scontent-cdg2-1.cdninstagram.com/hphotos-xfa1/t51.2885-15/s320x320/e35/11909351_893155867441203_392587202_n.jpg#ig_cache_key=MTA2NzY2MTg5NDY4MTY3MTEzMQ==.2w320h320";
	        width = 320;
	    },
	        {
	        height = 485;
	        url = "http://scontent-cdg2-1.cdninstagram.com/hphotos-xfa1/t51.2885-15/e35/11909351_893155867441203_392587202_n.jpg#ig_cache_key=MTA2NzY2MTg5NDY4MTY3MTEzMQ==.2w485h485";
	        width = 485;
	    }
	)
	*/
	
	/* Videos Versions Output
	Sep  6 04:48:56 iPad Instagram[2977] <Warning>: ********* Videos (
	        {
	        height = 640;
	        type = 101;
	        url = "http://scontent-cdg2-1.cdninstagram.com/hphotos-xaf1/t50.2886-16/11937120_439521332902216_431401395_n.mp4";
	        width = 640;
	    },
	        {
	        height = 480;
	        type = 102;
	        url = "http://scontent-cdg2-1.cdninstagram.com/hphotos-xaf1/t50.2886-16/11912055_455489177964020_1914680007_s.mp4";
	        width = 480;
	    },
	        {
	        height = 480;
	        type = 103;
	        url = "http://scontent-cdg2-1.cdninstagram.com/hphotos-xaf1/t50.2886-16/11912055_455489177964020_1914680007_s.mp4";
	        width = 480;
	    }
	)
	*/

	NSURL *url;
	CGFloat hightResolution;
	for (NSDictionary *versionDict in versions) {
		CGFloat height = [versionDict[@"height"] floatValue];
		CGFloat width = [versionDict[@"width"] floatValue];
		CGFloat resolution = height * width;

		if (resolution > hightResolution) {
			hightResolution = resolution;
			url = [NSURL URLWithString:versionDict[@"url"]];
		}
	}
	return url;
}

// Checking App Version
+ (BOOL)isAppVersionGreaterThanOrEqualTo:(NSString *)appversion {
	return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] compare:appversion options:NSNumericSearch] != NSOrderedAscending;
}
+ (BOOL)isAppVersionLessThanOrEqualTo:(NSString *)appversion {
	return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] compare:appversion options:NSNumericSearch] != NSOrderedDescending;
}

// Checking OS Version
+ (BOOL)isIOS83_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3;
}
+ (BOOL)isIOS80_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0;
}
+ (BOOL)isIOS70_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}
+ (BOOL)isIOS60_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0;
}
+ (BOOL)isIOS50_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0;
}
+ (BOOL)isIOS40_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0;
}

// Checking Device Type
+ (BOOL)isIPhone6_Plus {
	return [self isIPhone] && [self screenMaxLength] == 736.0;
}
+ (BOOL)isIPhone6 {
	return [self isIPhone] && [self screenMaxLength] == 667.0;
}
+ (BOOL)isIPhone5 {
	return [self isIPhone] && [self screenMaxLength] == 568.0;
}
+ (BOOL)isIPhone4_OrLess {
	return [self isIPhone] && [self screenMaxLength] < 568.0;
}

// Checking Device Interface
+ (BOOL)isIPad {
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
+ (BOOL)isIPhone {
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

// Checking Device Retina
+ (BOOL)isRetina {
	if ([self isIOS80_OrGreater]) {
        return [UIScreen mainScreen].nativeScale>=2;
    }
	return [[UIScreen mainScreen] scale] >= 2.0;
}

// Checking UIScreen sizes
+ (CGFloat)screenWidth {
	return [[UIScreen mainScreen] bounds].size.width;
}
+ (CGFloat)screenHeight {
	return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)screenMaxLength {
    return MAX([self screenWidth], [self screenHeight]);
}

+ (CGFloat)screenMinLength {
    return MIN([self screenWidth], [self screenHeight]);
}

// INGEnhancer methods
+ (void)ingen_shareText:(NSString *)textToShare {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[textToShare] applicationActivities:@[[[ARSpeechActivity alloc] init]]];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            [activityViewController setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {

            }];
            // Show UIActivityViewController
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self mainINGEnhancerViewController] presentViewController:activityViewController animated:YES completion:NULL];
            });
        } else {
            // Create pop up
            UIPopoverPresentationController *presentPOP = activityViewController.popoverPresentationController;
            activityViewController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
            activityViewController.popoverPresentationController.sourceView = [self mainINGEnhancerViewController].view;
            presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
            presentPOP.delegate = (id<UIPopoverPresentationControllerDelegate>)self;
            presentPOP.sourceRect = CGRectMake(700,80,0,0);
            presentPOP.sourceView = [self mainINGEnhancerViewController].view;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self mainINGEnhancerViewController] presentViewController:activityViewController animated:YES completion:NULL];
            });
        }
        
    });
}
+ (void)ingen_shareFile:(NSString *)fileToShare {
	dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD show:@"Preparing File....."];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *URL = [NSURL fileURLWithPath:fileToShare];
        TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:[self mainINGEnhancerViewController].view andRect:[self mainINGEnhancerViewController].view.frame];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            openInAppActivity.superViewController = activityViewController;
            [activityViewController setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
                NSLog(@"[DevLib] completed: %@, \n%d, \n%@, \n%@,", activityType, completed, returnedItems, activityError);
                if (completed && ![activityType isEqualToString:@"TTOpenInAppActivity"]) {
                    // [[DevLib sharedInstance] dismissMainWindow];
                }
                if (activityError && ![activityType isEqualToString:@"TTOpenInAppActivity"]) {
                    // [[DevLib sharedInstance] dismissMainWindow];
                }
            }];
            // Show UIActivityViewController
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self mainINGEnhancerViewController] presentViewController:activityViewController animated:YES completion:NULL];
                [ProgressHUD showSuccess:@"Finished....."];
            });
        } else {
            // Create pop up
            UIPopoverPresentationController *presentPOP = activityViewController.popoverPresentationController;
            activityViewController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
            activityViewController.popoverPresentationController.sourceView = [self mainINGEnhancerViewController].view;
            presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
            presentPOP.delegate = (id<UIPopoverPresentationControllerDelegate>)self;
            presentPOP.sourceRect = CGRectMake(700,80,0,0);
            presentPOP.sourceView = [self mainINGEnhancerViewController].view;
            openInAppActivity.superViewController = presentPOP;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self mainINGEnhancerViewController] presentViewController:activityViewController animated:YES completion:NULL];
                [ProgressHUD showSuccess:@"Finished....."];
            });
        }
        
    });
}
+ (NSBundle *)ingen_bundle {
	return [NSBundle bundleWithPath:@"/Library/Application Support/INGEnhancer/INGEnhancer.bundle"];
}
@end
