//
//  HelpQuestionsViewController.h
//  emergen6
//
//  Created by admin on 15/01/2016.
//  Copyright © 2016 Benoit. All rights reserved.
//

#import "XLForm.h"
#import "XLFormViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface HelpQuestionsViewController : XLFormViewController <CLLocationManagerDelegate, XLFormViewControllerDelegate, XLFormDescriptorDelegate>
@property (strong, nonatomic) NSString *alertId;
@end
