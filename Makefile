GO_EASY_ON_ME = 1
THEOS_DEVICE_IP = 192.168.0.15

ARCHS = armv7 armv7s arm64

TARGET = iphone:clang:latest:6.0

THEOS_BUILD_DIR = Packages

export MODULES=nahm8

include theos/makefiles/common.mk

TWEAK_NAME = INGEnhancer
INGEnhancer_CFLAGS = -fobjc-arc
INGEnhancer_FILES = INGEnhancer.xm INGEnhancerHelper.m $(wildcard ionicons/*.m) $(wildcard NYTPv/*.m)
INGEnhancer_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore CoreImage Accelerate AVFoundation AudioToolbox MobileCoreServices Social Accounts MediaPlayer ImageIO CoreMedia MessageUI AssetsLibrary Security LocalAuthentication CoreData WebKit CoreText AdSupport CoreTelephony EventKit EventKitUI

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
