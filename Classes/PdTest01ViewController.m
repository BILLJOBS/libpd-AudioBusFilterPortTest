//
//  PdTest01ViewController.m
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

#import "PdTest01ViewController.h"
#import "PdBase.h"

@implementation PdTest01ViewController

- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor blueColor];
    
    UILabel *cutoffLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, 200, 30)];
    [cutoffLabel setText:@"lop~ cutoff"];
    [self.view addSubview:cutoffLabel];
    [cutoffLabel release];
    
    UISlider *cutoffSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 30, self.view.frame.size.width - 60, 30)];
    [cutoffSlider addTarget:self action:@selector(changeCutoff:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:cutoffSlider];
    [cutoffSlider release];
}

- (void) changeCutoff:(UISlider *)slider {
    NSLog(@"%f", slider.value);
    [PdBase sendFloat:slider.value toReceiver:@"cutoff"];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
