//
//  MasterViewController.m
//  lecteur
//
//  Created by dev on 02.05.13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "MasterViewController.h"
#import "wav_to_flac.h"
#import <AudioToolbox/AudioConverter.h>

@interface MasterViewController ()

@end

@implementation MasterViewController

@synthesize synth, speechSpeedSlider, instructions, buttonHideInstructions, urlForSavedFile;

bool programON;
NSTask *task;
float sliderFloatValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.synth = [[NSSpeechSynthesizer alloc] init]; //start with default voice
        //[synth setDelegate:synth.delegate]; //useful?
        [speechSpeedSlider setFloatValue:[synth rate]];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appSettingsPath = [documentsDirectory stringByAppendingPathComponent:@"testAudio.aiff"];
    //NSURL *url=[[NSURL alloc]initFileURLWithPath:appSettingsPath];
    self.urlForSavedFile = [[NSURL alloc] initFileURLWithPath:appSettingsPath];
    programON = false;
    task = nil;
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
            //[synth setRate:sliderFloatValue];
            //[synth startSpeakingString:[copiedItems objectAtIndex:0]];
            if ([synth startSpeakingString:[copiedItems objectAtIndex:0] toURL:urlForSavedFile]) {
                NSString *homeDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", homeDirectory, @"testAudio.flac"];
                NSLog(@"path:%@",filePath);
                
                
                NSData *myData = [NSData dataWithContentsOfFile:filePath];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                                initWithURL:[NSURL
                                                             URLWithString:@"https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US"]];
                
                [request setHTTPMethod:@"POST"];
                
                //set headers
                
                [request addValue:@"Content-Type" forHTTPHeaderField:@"audio/x-flac; rate=16000"];
                
                [request addValue:@"audio/x-flac; rate=16000" forHTTPHeaderField:@"Content-Type"];
                
                [request setHTTPBody:myData];
                
                [request setValue:[NSString stringWithFormat:@"%ld",(unsigned long)[myData length]] forHTTPHeaderField:@"Content-length"];
                
                NSHTTPURLResponse* urlResponse = nil;
                NSError *error = [[NSError alloc] init];
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
                NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                
                NSLog(@"The answer is: %@",result);
                
                /*NSData *myData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/recordTest.flac", urlForSavedFile]];
                //NSString *audio = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/recordTest.flac", recDir]];
                
                
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                                initWithURL:[NSURL
                                                             URLWithString:@"https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US"]];
                
                
                
                
                
                
                [request setHTTPMethod:@"POST"];
                
                //set headers
                
                [request addValue:@"Content-Type" forHTTPHeaderField:@"audio/x-flac; rate=16000"];
                
                [request addValue:@"audio/x-flac; rate=16000" forHTTPHeaderField:@"Content-Type"];
                
                NSString *requestBody = [[NSString alloc] initWithFormat:@"Content=%@", myData];
                
                [request setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding]];
                
                [request setValue:[NSString stringWithFormat:@"%ld",(unsigned long)[myData length]] forHTTPHeaderField:@"Content-length"];
                
                
                
                NSHTTPURLResponse* urlResponse = nil;  
                NSError *error = [[NSError alloc] init];  
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];  
                NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                
                NSLog(@"The answer is: %@",result);*/
            } else NSLog(@"problem starting to speak out string");
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
    [instructions setHidden:false];
    [buttonHideInstructions setHidden:false];
}

- (IBAction)buttonHideInstructionsPressed:(id)sender
{
    [instructions setHidden:true];
    [buttonHideInstructions setHidden:true];
}
@end
