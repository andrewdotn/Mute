//
//  AppDelegate.m
//  Mute
//
//  Created by Florian Pichler on 01.01.13.
//  Copyright (c) 2013 TILOA. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>

@interface AppDelegate () {
	NSMenuItem *toggleMuteItem;

	NSImage *on;
	NSImage *onHighlighted;
	NSImage *off;
	NSImage *offHighlighted;

	UInt32 hotKeyCode;
}

@end


OSStatus hotKeyPressedHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData) {
	if ([[NSApplication sharedApplication].delegate respondsToSelector:@selector(mute:)]) {
		[[NSApplication sharedApplication].delegate performSelector:@selector(mute:) withObject:nil];
	}
	return noErr;
}

OSStatus hotKeyReleasedHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData) {
	if ([[NSApplication sharedApplication].delegate respondsToSelector:@selector(unmute:)]) {
		[[NSApplication sharedApplication].delegate performSelector:@selector(unmute:) withObject:nil];
	}
	return noErr;
}

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	mixer = [[Mixer alloc] init];
}

- (void)awakeFromNib {
	on = [NSImage imageNamed:@"on"];
	onHighlighted = [NSImage imageNamed:@"on-highlighted"];
	off = [NSImage imageNamed:@"off"];
	offHighlighted = [NSImage imageNamed:@"off-highlighted"];

	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	self.statusItem.image = on;
	self.statusItem.alternateImage = onHighlighted;
	self.statusItem.highlightMode = YES;
	self.statusItem.action = @selector(toggleMute:);
	//self.statusItem.menu = self.statusMenu;

	toggleMuteItem = [self.statusMenu itemWithTag:1];
	toggleMuteItem.state = NSOffState;
}

- (IBAction)mute:(id)sender {
	if (toggleMuteItem.state == NSOffState) {
		[mixer mute];
		toggleMuteItem.state = NSOnState;
		self.statusItem.image = off;
		self.statusItem.alternateImage = offHighlighted;
	}
}

- (IBAction)unmute:(id)sender {
	if (toggleMuteItem.state != NSOffState) {
		[mixer unmute];
		toggleMuteItem.state = NSOffState;
		self.statusItem.image = on;
		self.statusItem.alternateImage = onHighlighted;
	}
}

- (IBAction)toggleMute:(id)sender {
	if (toggleMuteItem.state == NSOffState) {
		[mixer mute];
		toggleMuteItem.state = NSOnState;
		self.statusItem.image = off;
		self.statusItem.alternateImage = offHighlighted;
		
	} else {
		[mixer unmute];
		toggleMuteItem.state = NSOffState;
		self.statusItem.image = on;
		self.statusItem.alternateImage = onHighlighted;
	}
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[mixer unmute];
}

@end
