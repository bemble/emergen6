//
//  ViewController.m
//  emergen6
//
//  Created by admin on 15/01/2016.
//  Copyright © 2016 Benoit. All rights reserved.
//

#import "ViewController.h"
#import "HelpQuestionsViewController.h"
#import "ServicesManager.h"



@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
- (IBAction)alertButton:(UIButton *)sender;
- (IBAction)profileButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *UrgenceButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) XLFormSectionDescriptor * sectionLocalization;
@property (nonatomic, strong) NSMutableDictionary *formInfos;

@end



@implementation ViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self.navigationController navigationBar] setHidden:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.UrgenceButton.layer.cornerRadius = 8;
    self.UrgenceButton.layer.borderWidth = 0;
    self.UrgenceButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self.navigationController navigationBar] setHidden:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)alertButton:(UIButton *)sender {
//    [[ServicesManager new] sendData];
    [self GotoAlert];
    
}

-(void)GotoAlert
{
    [self performSegueWithIdentifier:@"AlertSegue" sender:nil];
    [[self.navigationController navigationBar] setHidden:NO];
}

- (IBAction)profileButton:(id)sender {
    [self performSegueWithIdentifier:@"ConfigSegue" sender:nil];
    [[self.navigationController navigationBar] setHidden:NO];
}

- (IBAction)takePhoto:(id)sender
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    self.formInfos = [NSMutableDictionary new];
    
    // Lazily allocate image picker controller
    if (!self.imagePickerController) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        
        // If our device has a camera, we want to take a picture, otherwise, we just pick from
        // photo library
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        }else
        {
            [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        // image picker needs a delegate so we can respond to its messages
        [self.imagePickerController setDelegate:self];
    }
    // Place image picker on the screen
    [self presentViewController: self.imagePickerController animated: YES completion: nil];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //@"{\"position\":{\"latitude\":\"%@\",\"longitude\":\"%@\" }}"
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[locations lastObject].coordinate.latitude longitude:[locations lastObject].coordinate.longitude];
    [self.formInfos setObject:[self setCoordinates:loc] forKey:@"position"];
    [self.locationManager stopUpdatingLocation];

}

-(NSMutableDictionary *)setCoordinates:(CLLocation *)loc {
    NSMutableDictionary *locDict = [[NSMutableDictionary alloc] init];
    [locDict setObject:[NSString stringWithFormat:@"%f", loc.coordinate.latitude] forKey:@"latitude"];
    [locDict setValue:[NSString stringWithFormat:@"%f", loc.coordinate.longitude] forKey:@"longitude"];
    return locDict;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *base64String = [self encodeToBase64String:[self resizeImage:image toSize:CGSizeMake (200, 200) ]];
    self.formInfos[@"image"]=base64String;
    [ServicesManager sendFormWithData: self.formInfos AndDelegate:nil];
    [self dismissViewControllerAnimated: YES completion:^{
        [self GotoAlert];
    }];
    
    
}

-(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    float width = size.width;
    float height = size.height;
    
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    if(height < width)
        rect.origin.y = height / 3;
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
