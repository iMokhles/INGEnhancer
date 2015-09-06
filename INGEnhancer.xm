//
//  INGEnhancer.x
//  INGEnhancer
//
//  Created by iMokhles on 06.09.2015.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import "INGEnhancerHelper.h"

%group main

%hook IGCoreTextView
- (void)handleLongTap {
	// i don't like this feature so i replaced it easily :P
	[INGEnhancerHelper ingen_shareText:self.styledString.attributedString.string];
}
%end

%hook IGFeedItemPhotoCell
- (void)layoutSubviews {
	[INGEnhancerHelper addNotificationFromObserver:self withName:@"INGShareImageNotification" andSelector:@selector(showShareImageSheet:)];
	UILongPressGestureRecognizer *longPressMenu = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressZoomImage:)];
	[self.contentView addGestureRecognizer:longPressMenu];
	%orig;
}

%new
- (void)showShareImageSheet:(NSNotification *)notification {
	NSURL *imageURL = (NSURL *)[notification object];
	NSData *urlData = [NSData dataWithContentsOfURL:imageURL];
	UIImage *imageToShare = [UIImage imageWithData:urlData];
	NSData *pngData = UIImagePNGRepresentation(imageToShare);

	if (pngData) {
		NSString  *filePath = [NSString stringWithFormat:@"%@/%@", [INGEnhancerHelper insta_DocumentsPath], @"image.png"];
		[pngData writeToFile:filePath atomically:YES];
		double delayInSeconds = 0.5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[INGEnhancerHelper ingen_shareFile:filePath];
		});
	}

}

%new
- (void)longPressZoomImage:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
    	NSURL *imageURL = self.photoView.photoImageView.photoImageView.imageURL;
		NSData *urlData = [NSData dataWithContentsOfURL:imageURL];
		UIImage *imageToZoom = [UIImage imageWithData:urlData];
		
		INGEnhancerPhoto *photo = [[INGEnhancerPhoto alloc] init];
		photo.image = imageToZoom;
    	NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:@[photo]];
		[[INGEnhancerHelper mainINGEnhancerViewController] presentViewController:photosViewController animated:YES completion:nil];
    }
}
%end

%hook IGFeedItemVideoCell
- (void)layoutSubviews {
	[INGEnhancerHelper addNotificationFromObserver:self withName:@"INGShareVideoNotification" andSelector:@selector(showShareVideoSheet:)];
	%orig;
}
%new
- (void)showShareVideoSheet:(NSNotification *)notification {
	NSURL *videoURL = (NSURL *)[notification object];
	NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
	if (videoData) {
		NSString  *filePath = [NSString stringWithFormat:@"%@/%@", [INGEnhancerHelper insta_DocumentsPath], @"video.mp4"];
		[videoData writeToFile:filePath atomically:YES];
		double delayInSeconds = 0.5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[INGEnhancerHelper ingen_shareFile:filePath];
		});
	}

}
%end

// visit-site-share
// nux-arrow-down
%hook IGFeedItemActionCell
- (id)initWithFrame:(id)arg1 {
	if (self == %orig()) {
		[self.contentView addSubview:[self ing_shareButton]];
	}
	return self;
}
%new
- (UIButton *)ing_shareButton {
	UIButton *newShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *tintedImage = [UIImage IGTintedImageWithName:@"visit-site-share" tintColor:[UIColor grayColor]];
	[newShareButton setImage:tintedImage forState:UIControlStateNormal];
	[newShareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[newShareButton setFrame:CGRectMake(46*3, 0, 46, 46)];
	return newShareButton;
}
%new
- (void)shareButtonPressed {
	int mediaType = self.feedItem.mediaType;
	if (mediaType == 1) {
		// Shre image
		NSURL *imageURL = [INGEnhancerHelper urlFromVersionArray:self.feedItem.photo.imageVersions];
		[INGEnhancerHelper postNotificationWithName:@"INGShareImageNotification" andObject:imageURL];
	} else {
		if (mediaType == 2) {
			// Share Video
			NSURL *videoURL = [INGEnhancerHelper urlFromVersionArray:self.feedItem.video.videoVersions];
			[INGEnhancerHelper postNotificationWithName:@"INGShareVideoNotification" andObject:videoURL];
		}
	}
}
- (void)layoutSubviews {
	%orig;
}
%end

%end


%ctor {
	@autoreleasepool {
		%init(main);
	}
}
