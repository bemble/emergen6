//
//  HelpQuestionsViewController.m
//  emergen6
//
//  Created by admin on 15/01/2016.
//  Copyright © 2016 Benoit. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "CLLocationValueTrasformer.h"
#import "MapViewController.h"
#import "ServicesManager.h"
#import "HelpQuestionsViewController.h"

NSString *const kSelectorCateg = @"selectorMap";

NSString *const kSelectorMap = @"selectorMap";
NSString *const kSelectorMapPopover = @"selectorMapPopover";

NSMutableDictionary *formInfos;

XLFormRowDescriptor * locationRow;
XLFormSectionDescriptor * sectionLocalization;

@interface HelpQuestionsViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation HelpQuestionsViewController

- (void)initializeForm
{ 
    [[self.navigationController navigationBar] setHidden:NO];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    formInfos = [[NSMutableDictionary alloc] init];
    
    XLFormDescriptor * form;
    
    XLFormSectionDescriptor * sectionQuestions;
    XLFormSectionDescriptor * section;
    XLFormSectionDescriptor * section2;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Alert Details"];
    
    // Basic Information
    sectionLocalization = [XLFormSectionDescriptor formSection];
    sectionLocalization.footerTitle = @"Tapez pour changer la localisation.";
    [form addFormSection:sectionLocalization];
    
    
    // Selector Push
    locationRow = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorMap rowType:XLFormRowDescriptorTypeSelectorPush title:@"Localisation"];
    locationRow.action.viewControllerClass = [MapViewController class];
    locationRow.valueTransformer = [CLLocationValueTrasformer class];
    locationRow.value = [[CLLocation alloc] initWithLatitude:48.898807 longitude:2.196922];
    [sectionLocalization addFormRow:locationRow];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        // Selector PopOver
        locationRow = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorMapPopover rowType:XLFormRowDescriptorTypeSelectorPopover title:@"Coordinate PopOver"];
        locationRow.action.viewControllerClass = [MapViewController class];
        locationRow.valueTransformer = [CLLocationValueTrasformer class];
        locationRow.value = [[CLLocation alloc] initWithLatitude:48.898807 longitude:2.196922];
        [sectionLocalization addFormRow:locationRow];
    }
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Type d'alerte"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Situation1" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@""];
    row.selectorOptions = @[@"Violence avec armes à feu​",
                            @"Prise d’otages​"];
    
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Situation2" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@""];
    row.selectorOptions = @[@"Explosion",
                            @"Incendies​",
                            @"Intoxica-tions​"];
    
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Situation3" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@""];
    row.selectorOptions = @[@"Noyades inonda-tions​",
                            @"Autres risques​"];
    
    [section addFormRow:row];
    
    
    section2 = [XLFormSectionDescriptor formSectionWithTitle:@"Nombre de victimes"];
    [form addFormSection:section2];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"victimes1" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@""];
    row.selectorOptions = @[@"1 à 10",
                            @"10 à 50",
                            @"Plus de 50"];
    
    [section2 addFormRow:row];
    
    [section2 addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:@"Morts" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Morts visibles"]];
    
    sectionQuestions = [XLFormSectionDescriptor formSectionWithTitle:@"Emmetteur"];
    [form addFormSection:sectionQuestions];
    
    XLFormRowDescriptor* hobbyRow = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorCateg
                                                                          rowType:XLFormRowDescriptorTypeSelectorSegmentedControl
                                                                            title:@"Je suis"];
    hobbyRow.selectorOptions = @[@"Témoins", @"Impliqué", @"Victime"];
    hobbyRow.value = @"Other";
    [sectionQuestions addFormRow:hobbyRow];
    
    
    sectionQuestions = [XLFormSectionDescriptor formSectionWithTitle:@"Quelques questions"];
    sectionQuestions.hidden = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"$%@.value.@count == 0", hobbyRow]];
    sectionQuestions.footerTitle = @"Merci pour vos réponses";
    [form addFormSection:sectionQuestions];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"PlaceType" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"Localisation de l'évènement"];
    row.selectorOptions = @[@"Voie publique"
                            ];
    
    [sectionQuestions addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"PlaceType2" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@""];
    row.selectorOptions = @[@"Appartement privé",
                            @"Ecole / Lycée",
                            @"Salle spectacle"];
    
    [sectionQuestions addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"PlaceType2" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@""];
    row.selectorOptions = @[@"Biblioth. / Cinéma",
                            @"Restaurant / Bar",
                            @"Local Commercial"];
    
    [sectionQuestions addFormRow:row];
    
    self.form = form;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //@"{\"position\":{\"latitude\":\"%@\",\"longitude\":\"%@\" }}"
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[locations lastObject].coordinate.latitude longitude:[locations lastObject].coordinate.longitude];
    locationRow.value = loc;
    [formInfos setObject:[self setCoordinates:locationRow.value] forKey:@"position"];
    
    [ServicesManager sendFormWithData:formInfos AndDelegate:self];
    [self.tableView reloadData];
}

-(NSMutableDictionary *)setCoordinates:(CLLocation *)loc {
    NSMutableDictionary *locDict = [[NSMutableDictionary alloc] init];
    [locDict setObject:[NSString stringWithFormat:@"%f", loc.coordinate.latitude] forKey:@"latitude"];
    [locDict setValue:[NSString stringWithFormat:@"%f", loc.coordinate.longitude] forKey:@"longitude"];
    return locDict;
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    if (formRow.tag == kSelectorMap || formRow.tag == kSelectorMapPopover) {
        [formInfos setObject:[self setCoordinates:locationRow.value] forKey:@"position"];
    } else {
        NSString *key = (NSString *)formRow.tag;
        [formInfos setValue:newValue forKey:key];
    }

    [self.navigationItem setPrompt:nil];
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

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(savePressed:)];
}


-(void)savePressed:(UIBarButtonItem * __unused)button
{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    
    
    [ServicesManager sendFormWithData:formInfos AndDelegate:self];
    
    [self.navigationItem setPrompt:@"Alerte envoyée"];
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
