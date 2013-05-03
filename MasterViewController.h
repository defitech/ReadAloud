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
}

@property (nonatomic, retain) NSSpeechSynthesizer *synth;

- (IBAction)buttonStartPressed:(id)sender;
- (IBAction)buttonStopPressed:(id)sender;

@end
