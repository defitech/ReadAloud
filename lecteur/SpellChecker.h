//
//  SpellChecker.h
//  lecteur
//
//  Created by dev on 21.05.13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SpellChecker : NSViewController {
    NSSpeechSynthesizer *synth;
    NSURL *urlForSavedFile;
    IBOutlet NSTextView *textToBeCorrected;
    IBOutlet NSTextView *textCorrected;
}

@property (nonatomic, retain) NSSpeechSynthesizer *synth;
@property (nonatomic, retain) NSURL *urlForSavedFile;
@property (nonatomic, retain) IBOutlet NSTextView *textToBeCorrected;
@property (nonatomic, retain) IBOutlet NSTextView *textCorrected;

- (IBAction)buttonBackPushed:(id)sender;
- (IBAction)buttonCorrectPushed:(id)sender;

@end
