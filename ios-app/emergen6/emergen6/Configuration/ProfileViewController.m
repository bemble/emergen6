//
//  ProfileViewController.m
//  emergen6
//
//  Created by admin on 16/01/2016.
//  Copyright © 2016 Benoit. All rights reserved.
//

#import "XLForm.h"
#import "ProfileViewController.h"
#import "ServicesManager.h"

@interface ProfileViewController ()

@end

NSString *const kName = @"name";
NSString *const kEmail = @"email";
NSString *const kTwitter = @"twitter";
NSString *const kZipCode = @"zipCode";
NSString *const kNumber = @"number";
NSString *const kInteger = @"integer";
NSString *const kDecimal = @"decimal";
NSString *const kPassword = @"password";
NSString *const kPhone = @"phone";
NSString *const kUrl = @"url";
NSString *const kTextView = @"textView";
NSString *const kId = @"id";

NSMutableDictionary *root;


@implementation ProfileViewController



- (NSData *)jsonData {
    
    if ([NSJSONSerialization isValidJSONObject:root]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:root
                                                           options:0
                                                             error:nil];
        return jsonData;
    }
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeForm];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

-(id)initializeForm
{
    NSMutableDictionary *tmp = [self loadFile];
    if (tmp) {
        root = tmp;
    } else {
    
        root = [@{    kId : @"",      kName : @"",          // I´m using literals here for brevity’s sake
                            kEmail : @"",
                            kTwitter : @"@",
                            kPhone : @""} mutableCopy];
    }
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Votre profil"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Informations"];
    section.footerTitle = @"Merci, ceci aidera nos travaux.";
    [formDescriptor addFormSection:section];
    
    // Id
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kId rowType:XLFormRowDescriptorTypeText title:@"Id"];
    row.value = [root valueForKey:kId];
    row.hidden = @"1 = 1";
    [section addFormRow:row];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kName rowType:XLFormRowDescriptorTypeText title:@"Nom"];
    row.value = [root valueForKey:kName];
    [section addFormRow:row];
    
    // Email
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEmail rowType:XLFormRowDescriptorTypeEmail title:@"Email"];
    row.value = [root valueForKey:kEmail];
    [row addValidator:[XLFormValidator emailValidator]];
    [section addFormRow:row];
    
    // Twitter
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTwitter rowType:XLFormRowDescriptorTypeTwitter title:@"Twitter"];
    row.value = [root valueForKey:kTwitter];
    [section addFormRow:row];
    
    // Phone
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPhone rowType:XLFormRowDescriptorTypePhone title:@"Mobile"];
    row.value = [root valueForKey:kPhone];
    [section addFormRow:row];
    
    return [super initWithForm:formDescriptor];
    
}

-(NSMutableDictionary *)loadFile {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"profile.dat"];
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:NULL];
    NSError *jsonError;
    if (!jsonString) {
        return nil;
    }
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    
    return jsonDict;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


-(void)savePressed:(UIBarButtonItem * __unused)button
{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    
    [ServicesManager saveUserWithData:root AndDelegate:self];
    
    [self.navigationItem setPrompt:@"Profile sauvegardé"];
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    NSString *key = (NSString *)formRow.tag;
    [root setValue:newValue forKey:key];
    [self.navigationItem setPrompt:nil];
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
