//
//  SpellChecker.m
//  lecteur
//
//  Created by dev on 21.05.13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "SpellChecker.h"
#import "MasterViewController.h"

@interface SpellChecker ()
@property (nonatomic,strong) IBOutlet MasterViewController *masterViewController;
@end

@implementation SpellChecker

NSTask *task;
float sliderFloatValue;

@synthesize synth, urlForSavedFile, textToBeCorrected, textCorrected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.synth = [[NSSpeechSynthesizer alloc] init]; //start with default voice
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appSettingsPath = [documentsDirectory stringByAppendingPathComponent:@"testAudio.aiff"];
    self.urlForSavedFile = [[NSURL alloc] initFileURLWithPath:appSettingsPath];
    task = nil;
    sliderFloatValue = [synth rate];
    
    
    return self;
}


- (IBAction)buttonCorrectPushed:(id)sender
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self Correct];
    });
    
}

- (void)Correct
{
    [synth setVoice:nil];   //sets voice to current voice on the computer
    NSString *stringToBeCorrected = textToBeCorrected.textStorage.string;
    NSLog(@"string to be corrected:%@", stringToBeCorrected);
    if ([synth isSpeaking]) {
        NSLog(@"program is Reading the text");
    } else if ([stringToBeCorrected length] > 0) {
        //[synth setRate:sliderFloatValue];
        //[synth startSpeakingString:[copiedItems objectAtIndex:0]];
        if ([synth startSpeakingString:stringToBeCorrected toURL:urlForSavedFile]) {
            
            /////////wait for synthesizer to be quiet
            bool finishedReading = false;
            while (finishedReading == false) {
                usleep(300000);
                if (![synth isSpeaking]) finishedReading = true;
            }
            
            /////////prepare and launch commandline for converting the file using flac
            NSTask *task;
            task = [[NSTask alloc] init];
            [task setLaunchPath: @"/usr/local/bin/flac"];
            NSArray *arguments;
            arguments = [NSArray arrayWithObjects: @"-f", @"/Users/dev/Documents/testAudio.aiff", nil];
            [task setArguments: arguments];
            [task launch];
            usleep(300000);
            NSString *homeDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", homeDirectory, @"testAudio.flac"];
            NSLog(@"path:%@",filePath);
            
            
            ///////////request for the google API
            NSData *myData = [NSData dataWithContentsOfFile:filePath];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                            initWithURL:[NSURL
                                                         URLWithString:@"https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=fr-FR"]];
            
            [request setHTTPMethod:@"POST"];
            
            //set headers            
            [request addValue:@"Content-Type" forHTTPHeaderField:@"audio/x-flac; rate=22050"];
            
            [request addValue:@"audio/x-flac; rate=22050" forHTTPHeaderField:@"Content-Type"];
            
            [request setHTTPBody:myData];
            
            [request setValue:[NSString stringWithFormat:@"%ld",(unsigned long)[myData length]] forHTTPHeaderField:@"Content-length"];
            
            NSHTTPURLResponse* urlResponse = nil;
            NSError *error = [[NSError alloc] init];
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
            NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"The answer is: %@",result);
            //usleep(4000000);
            NSRange startOfRangeOfResult = [result rangeOfString:@"utterance"];
            NSRange endOfRangeOfResult = [result rangeOfString:@"confidence"];
            NSRange rangeOResult = NSMakeRange(startOfRangeOfResult.location + startOfRangeOfResult.length + 3, endOfRangeOfResult.location - (startOfRangeOfResult.location + startOfRangeOfResult.length)-6);
            if (rangeOResult.location > 0 && rangeOResult.location < [result length]) {
                NSString *stringResult = [result substringWithRange:rangeOResult];
                textCorrected.string = stringResult;
            } else 
                NSLog(@"problem with range -> range=%li,%li", (unsigned long)rangeOResult.location, (unsigned long)rangeOResult.length);
            
        } else NSLog(@"problem starting to speak out string");
    }
}

- (IBAction)buttonBackPushed:(id)sender
{
    // 1. Create the master View Controller
    self.masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    
    // 2. Add the view controller to the Window's content view
    while ([self.view.subviews count] >0) {
        [[self.view.subviews objectAtIndex:0] removeFromSuperview];
    }
    
    [self.view addSubview:self.masterViewController.view];
    self.masterViewController.view.frame = ((NSView*)self.view).bounds;
}
@end
