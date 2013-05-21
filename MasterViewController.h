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
    IBOutlet NSButton *buttonHideInstructions;
    NSURL *urlForSavedFile;
}

@property (nonatomic, retain) NSSpeechSynthesizer *synth;

- (IBAction)buttonStartStopPressed:(id)sender;
@property (nonatomic, retain) IBOutlet NSSlider *speechSpeedSlider;
- (IBAction)valueChangedForspeechSpeedSlider:(id)sender;
- (IBAction)buttonInstructionsPressed:(id)sender;


@end
