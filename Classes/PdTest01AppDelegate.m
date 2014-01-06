//
//  PdTest01AppDelegate.m
//  PdTest01
//
//  Created by Richard Lawler on 10/3/10.
/**
 * This software is copyrighted by Richard Lawler. 
 * The following terms (the "Standard Improved BSD License") apply to 
 * all files associated with the software unless explicitly disclaimed 
 * in individual files:
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * 
 * 1. Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above  
 * copyright notice, this list of conditions and the following 
 * disclaimer in the documentation and/or other materials provided
 * with the distribution.
 * 3. The name of the author may not be used to endorse or promote
 * products derived from this software without specific prior 
 * written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "PdTest01AppDelegate.h"
#import "PdTest01ViewController.h"
#import "PdAudioController.h"
#import <libkern/OSAtomic.h>
#import "Audiobus.h"

@interface PdTest01AppDelegate()
@property (nonatomic, retain) PdAudioController *audioController;
@property (nonatomic, retain) ABAudiobusController *audiobusController;
@property (nonatomic, retain) ABAudiobusAudioUnitWrapper *audiobusAudioUnitWrapper;
@property (nonatomic, retain) ABFilterPort *pdFilterPort;
@end

@implementation PdTest01AppDelegate

@synthesize window;
@synthesize audioController = audioController_;
@synthesize audiobusController = _audiobusController;
@synthesize audiobusAudioUnitWrapper = _audiobusAudioUnitWrapper;
@synthesize pdFilterPort = _pdFilterPort;

- (void) receivePrint:(NSString *)string {
    NSLog(@"ohdohfoshdfoh %@", string);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	self.audioController = [[[PdAudioController alloc] init] autorelease];
    self.audioController.audioUnit.filterActive = YES;
	[self.audioController configurePlaybackWithSampleRate:22050 numberChannels:2 inputEnabled:YES mixingEnabled:YES];
	[PdBase openFile:@"test.pd" path:[[NSBundle mainBundle] resourcePath]];
    [PdBase setDelegate:self];
	[self.audioController setActive:YES];
	[self.audioController print];

    // audiobus stuff
    UInt32 allowMixing = YES;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (allowMixing), &allowMixing);
    self.audiobusController = [[ABAudiobusController alloc]
                               initWithAppLaunchURL:[NSURL URLWithString:@"PdTest01.audiobus://"]                                apiKey:@"MTM5MDI0NzI5MCoqKlBkVGVzdDAxKioqUGRUZXN0MDEuYXVkaW9idXM6Ly8=:W9bMA6N1zNU75Qj5/YMTn53A9Rvjxg5xNoDAc20I3sAt5j84PagXZADEvcWBP8ZV1z2ZkD2jBywj2miB4RrQPDQ2q7BDTiCZSTIE7epJoRhqD/vbw4/wYUckmBl7qlPe"];
    
    ABOutputPort *output = [self.audiobusController addOutputPortNamed:@"Audio Output"
                                                                 title:NSLocalizedString(@"Main App Output", @"")];
    
    self.audiobusAudioUnitWrapper = [[ABAudiobusAudioUnitWrapper alloc]
                                     initWithAudiobusController:self.audiobusController
                                     audioUnit:self.audioController.audioUnit.audioUnit
                                     output:output
                                     input:nil];
    
    self.pdFilterPort = [self.audiobusController addFilterPortNamed:@"pdTestFilter" title:@"pdTestFilter" processBlock:^(AudioBufferList *audio, UInt32 frames, AudioTimeStamp *timestamp) {
        // Filter the audio...
        Float32 *auBuffer = (Float32 *)audio->mBuffers[0].mData;
        int ticks = frames >> log2int([PdBase getBlockSize]);
        [PdBase processFloatWithInputBuffer:auBuffer outputBuffer:auBuffer ticks:ticks];
    }];
    self.pdFilterPort.audioBufferSize = 512; //8 ticks
    self.pdFilterPort.clientFormat = [self.audioController.audioUnit ASBDForSampleRate:22050.0 numberChannels:2];
    [self.audiobusAudioUnitWrapper addFilterPort:self.pdFilterPort];
    
	
	self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
	self.window.rootViewController = [[[PdTest01ViewController alloc] init] autorelease];
    [self.window makeKeyAndVisible];
	return YES;
}


- (void)dealloc {
	self.audioController = nil;
	self.window = nil;
    [self.audiobusAudioUnitWrapper release];
    [self.audiobusController release];
    [self.pdFilterPort release];
    [super dealloc];
}

@end
