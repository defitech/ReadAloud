//
//  MasterViewController.h
//  lecteur
//
//  Created by dev on 02.05.13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MasterViewController : NSViewController {
    NSSpeechSynthesizer *synth;
    IBOutlet NSSlider *speechSpeedSlider;
    IBOutlet  NSTextView *instructions;
    IBOutlet NSButton *buttonHideInstructions;
}

@property (nonatomic, retain) NSSpeechSynthesizer *synth;
@property (nonatomic, retain) IBOutlet NSSlider *speechSpeedSlider;
@property (nonatomic, retain) IBOutlet NSTextView *instructions;
@property (nonatomic, retain) IBOutlet NSButton *buttonHideInstructions;

- (IBAction)buttonStartStopPressed:(id)sender;
- (IBAction)valueChangedForspeechSpeedSlider:(id)sender;
- (IBAction)buttonInstructionsPressed:(id)sender;
- (IBAction)buttonHideInstructionsPressed:(id)sender;

@end
