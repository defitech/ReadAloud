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
}

@property (nonatomic, retain) NSSpeechSynthesizer *synth;
@property (nonatomic, retain) NSURL *urlForSavedFile;
@property (nonatomic, retain) IBOutlet NSTextView *textToBeCorrected;

- (IBAction)buttonBackPressed:(id)sender;
- (IBAction)buttonCorrectPressed:(id)sender;

@end
