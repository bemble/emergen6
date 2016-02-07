//
//  TodayViewController.m
//  Emergen6 Widget
//
//  Created by yann breleur on 15/01/2016.
//  Copyright © 2016 Benoit. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

typedef enum : NSUInteger {
    urlphoto,
    urlVideo,
    urlImage,
    urlAudio,
    urlText,
    urlInfos,
    urlAlerte
} enumTypeUrl;

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}



- (IBAction)photoButton:(id)sender {
    [self p_openApplicationWithUrl:urlphoto];
}

- (IBAction)videoButton:(id)sender {
     [self p_openApplicationWithUrl:urlVideo];
}

- (IBAction)audioButton:(id)sender {
     [self p_openApplicationWithUrl:urlAudio];
}

- (IBAction)textButton:(id)sender {
     [self p_openApplicationWithUrl:urlText];
}

- (IBAction)infosButton:(id)sender {
     [self p_openApplicationWithUrl:urlInfos];
}
- (IBAction)alertButton:(id)sender {
    [self p_openApplicationWithUrl:urlAlerte];
}

#pragma mark - private
-(void)p_openApplicationWithUrl:(enumTypeUrl)type
{
    NSMutableString *stringCustomURL = [@"Emergen6://" mutableCopy];
    switch (type) {
        case urlphoto:
            [stringCustomURL appendString:@"photo"];
            break;
        case urlVideo:
            [stringCustomURL appendString:@"video"];
            break;
        case urlImage:
            [stringCustomURL appendString:@"image"];
            break;
        case urlAudio:
            [stringCustomURL appendString:@"audio"];
            break;
        case urlText:
            [stringCustomURL appendString:@"text"];
            break;
        case urlInfos:
            [stringCustomURL appendString:@"infos"];
            break;
        case urlAlerte:
            [stringCustomURL appendString:@"alerte"];
            break;
        default:
            break;
    }
    NSURL *customURL = [NSURL URLWithString:stringCustomURL];
    [self.extensionContext openURL:customURL completionHandler:nil];
}

@end
