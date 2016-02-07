//
//  photoControllerViewController.m
//  emergen6
//
//  Created by yann breleur on 16/01/2016.
//  Copyright © 2016 Benoit. All rights reserved.
//

#import "photoControllerViewController.h"

@interface photoControllerViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation photoControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)takePhoto:(id)sender
{
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated: YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
