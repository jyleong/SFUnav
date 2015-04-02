//
//  PlannerViewController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-31.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "PlannerViewController.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) //1
#define currentDeptURL [NSString stringWithFormat:@"http://www.sfu.ca/bin/wcm/course-outlines?year=current&term=current"]
#define registrationDeptURL [NSString stringWithFormat:@"http://www.sfu.ca/bin/wcm/course-outlines?year=current&term=registration"]

@interface PlannerViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *departmentPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *coursePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *sectionPicker;
- (IBAction)deptDone:(id)sender;
- (IBAction)courseDone:(id)sender;
- (IBAction)sectionDone:(id)sender;


@end

@implementation PlannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _deptNames=[[NSMutableArray alloc]init];
    _courseNames=[[NSMutableArray alloc]init];
    _sectionNames=[[NSMutableArray alloc]init];
    _courseDone.hidden=YES;
    _sectionDone.hidden=YES;
//    _departmentPicker.hidden=true;
//    _coursePicker.hidden=true;
//    _sectionPicker.hidden=true;
    // Do any additional setup after loading the view.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:currentDeptURL]];
        [self performSelectorOnMainThread:@selector(fetchedDept:)withObject:data waitUntilDone:YES];
    });
    
}

- (void)fetchedDept:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    [_deptNames removeAllObjects];
    for (int i=0; i<[json count]; i++)
    {
        [_deptNames addObject:json[i][@"text"]];
    }
    [_departmentPicker reloadAllComponents];
}

- (void)fetchedCourse:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions
                     error:&error];
    [_courseNames removeAllObjects];
    for (int i=0; i<[json count]; i++)
    {
        
        [_courseNames addObject:json[i][@"text"]];

    }
    [_coursePicker reloadAllComponents];
    _courseDone.hidden=NO;
}

- (void)fetchedSections:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions
                     error:&error];
    [_sectionNames removeAllObjects];
    for (int i=0; i<[json count]; i++)
    {
        
        [_sectionNames addObject:json[i][@"text"]];

    }
    [_sectionPicker reloadAllComponents];
    _sectionDone.hidden=NO;
}

- (void)fetchedInfo:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions
                     error:&error];
    
    NSString *info=[[json objectForKey:@"info"] objectForKey:@"description"];

//    UIAlertController * alert=   [UIAlertController
//                                  alertControllerWithTitle:@"My Title"
//                                  message:info
//                                  preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* cancel = [UIAlertAction
//                             actionWithTitle:@"Ok"
//                             style:UIAlertActionStyleDefault
//                             handler:^(UIAlertAction * action)
//                             {
//                                 [alert dismissViewControllerAnimated:YES completion:nil];
//                                 
//                             }];
//    [alert addAction:cancel];
//    [self presentViewController:alert animated:YES completion:nil];

}
#pragma mark - PickerView Modifiers
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
//    if (pickerView==_departmentPicker)
//        return [_deptNames count];
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==_departmentPicker)
    return [_deptNames count];
    else if (pickerView==_coursePicker)
        return [_courseNames count];
    return [_sectionNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (pickerView==_departmentPicker)
    {
        if ([_deptNames count]>row)
        {
            //  NSLog(@"%@",[_deptNames objectAtIndex:row]);
            return [_deptNames objectAtIndex:row] ;
        }
    }
    if (pickerView==_coursePicker)
    {
        if ([_courseNames count]>row)
        {
            //  NSLog(@"%@",[_deptNames objectAtIndex:row]);
            return [_courseNames objectAtIndex:row] ;
        }
    }
    if (pickerView==_sectionPicker)
    {
        if ([_sectionNames count]>row)
        {
            //  NSLog(@"%@",[_deptNames objectAtIndex:row]);
            return [_sectionNames objectAtIndex:row] ;
        }
    }
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - API CALLS
- (IBAction)deptDone:(id)sender {
       dispatch_async(kBgQueue, ^{
        NSString *apiURL=[NSString stringWithFormat:
                          @"%@"
                          @"&dept=%@",currentDeptURL,[_deptNames objectAtIndex:[_departmentPicker selectedRowInComponent:0]]
                          ];
        apiURL=[apiURL lowercaseString];
        NSLog(@"%@",apiURL);
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiURL ]];
        [self performSelectorOnMainThread:@selector(fetchedCourse:)withObject:data waitUntilDone:YES];
    
       });
}

- (IBAction)courseDone:(id)sender {
    dispatch_async(kBgQueue, ^{
    NSString *apiURL=[NSString stringWithFormat:
                          @"%@"
                          @"&dept=%@"
                          @"&number=%@",currentDeptURL,[_deptNames objectAtIndex:[_departmentPicker selectedRowInComponent:0]],[_courseNames objectAtIndex:[_coursePicker selectedRowInComponent:0]]
                          ];
        apiURL=[apiURL lowercaseString];
        NSLog(@"%@",apiURL);
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiURL]];
        [self performSelectorOnMainThread:@selector(fetchedSections:)withObject:data waitUntilDone:YES];

    });

}

- (IBAction)sectionDone:(id)sender {
    dispatch_async(kBgQueue, ^{
    NSString *apiURL=[NSString stringWithFormat:
                          @"%@"
                          @"&dept=%@"
                          @"&number=%@"
                          @"&section=%@",currentDeptURL,[_deptNames objectAtIndex:[_departmentPicker selectedRowInComponent:0]],[_courseNames objectAtIndex:[_coursePicker selectedRowInComponent:0]],[_sectionNames objectAtIndex:[_sectionPicker selectedRowInComponent:0]]
                          ];
    apiURL=[apiURL lowercaseString];
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiURL ]];
    NSLog(@"info url:%@",apiURL);
    [self performSelectorOnMainThread:@selector(fetchedInfo:)withObject:data waitUntilDone:YES];
    });

}
@end
