//
//  main.m
//  CaulySample
//
//  Created by FutureStreamNetworks on 12. 3. 19..
//  Copyright (c) 2012년 FutureStreamNetworks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int ret = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	[pool release];
	return ret;
}
