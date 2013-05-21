//
//  MasterViewController.m
//  lecteur
//
//  Created by dev on 02.05.13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "MasterViewController.h"
#import "Parameters.h"
#import "SpellChecker.h"

@interface MasterViewController ()
@property (nonatomic,strong) IBOutlet Parameters *parametersViewController;
@property (nonatomic,strong) IBOutlet SpellChecker *spellcheckerViewController;
@end

@implementation MasterViewController

@synthesize synth, speechSpeedSlider;

bool programON;
float sliderFloatValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.synth = [[NSSpeechSynthesizer alloc] init]; //start with default voice
        //[synth setDelegate:synth.delegate]; //useful?
        [speechSpeedSlider setFloatValue:[synth rate]];
    }
    programON = false;
    sliderFloatValue = [synth rate];
    
    
    return self;
}

//hello, how are you doing?
- (IBAction)buttonStartStopPressed:(id)sender
{
    if (programON == false) {
        programON = true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self ReadClipboard];
        });
    } else programON = false; 
    
}

- (void)ReadClipboard
{
    [synth setVoice:nil];   //sets voice to current voice on the computer
    NSString *PasteboardContent = @" ";
    
    while (programON == true) {
        
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        NSArray *classes = [[NSArray alloc] initWithObjects:[NSString class], nil];
        NSDictionary *options = [NSDictionary dictionary];
        NSArray *copiedItems = [pasteboard readObjectsForClasses:classes options:options];
        
        if ([synth isSpeaking]) {
            //NSLog(@"isReadingClipboard");
            if (programON != true) {
                [synth stopSpeaking];
            }
            if (copiedItems != nil && [copiedItems count] > 0 && [[copiedItems objectAtIndex:0] length] > 0 && ![PasteboardContent isEqualToString:[copiedItems objectAtIndex:0]]) {
                [synth stopSpeaking];
            }
        } else if (copiedItems != nil && [copiedItems count] > 0 && [[copiedItems objectAtIndex:0] length] > 0 && ![PasteboardContent isEqualToString:[copiedItems objectAtIndex:0]]) {
                [synth setRate:sliderFloatValue];
                [synth startSpeakingString:[copiedItems objectAtIndex:0]];
                PasteboardContent = [copiedItems objectAtIndex:0];
        }
        if (copiedItems != nil && [copiedItems count] == 0) {
            [synth stopSpeaking];
        }
        
        usleep(200000);
    }
    
    if ([synth isSpeaking]) [synth stopSpeaking];
}

- (IBAction)valueChangedForspeechSpeedSlider:(id)sender
{
    sliderFloatValue = [speechSpeedSlider floatValue];
}

- (IBAction)buttonInstructionsPressed:(id)sender
{
    // 1. Create the master View Controller
    self.parametersViewController = [[Parameters alloc] initWithNibName:@"Parameters" bundle:nil];
    
    // 2. Add the view controller to the Window's content view
    while ([self.view.subviews count] >0) {
        [[self.view.subviews objectAtIndex:0] removeFromSuperview];
    }
    [self.view addSubview:self.parametersViewController.view];
    self.parametersViewController.view.frame = ((NSView*)self.view).bounds;
    
}

- (IBAction)buttonSpellCheckerPressed:(id)sender
{
    // 1. Create the master View Controller
    self.spellcheckerViewController = [[SpellChecker alloc] initWithNibName:@"SpellChecker" bundle:nil];
    
    // 2. Add the view controller to the Window's content view
    while ([self.view.subviews count] >0) {
        [[self.view.subviews objectAtIndex:0] removeFromSuperview];
    }
    [self.view addSubview:self.spellcheckerViewController.view];
    self.spellcheckerViewController.view.frame = ((NSView*)self.view).bounds;
}

@end
