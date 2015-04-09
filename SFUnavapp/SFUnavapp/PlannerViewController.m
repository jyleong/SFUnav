//
//  PlannerViewController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-31.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "PlannerViewController.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) //1
#define baseURL [NSString stringWithFormat:@"http://www.sfu.ca/bin/wcm/course-outlines?year=current"]

@interface PlannerViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *semesterPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *departmentPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *coursePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *sectionPicker;
- (IBAction)semesterDone:(id)sender;
- (IBAction)deptDone:(id)sender;
- (IBAction)courseDone:(id)sender;

@end

NSMutableArray *currentCourses;
NSMutableArray *registrationCourses;

@implementation PlannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentCourses=[self loadCustomObjectWithKey:@"currentCourses"];
    registrationCourses=[self loadCustomObjectWithKey:@"registrationCourses"];
    if (currentCourses==nil)
        currentCourses=[[NSMutableArray alloc]init];

    if (registrationCourses==nil)
        registrationCourses=[[NSMutableArray alloc]init];

    _semesterNames=[[NSMutableArray alloc]init];
    [_semesterNames addObject:@"Current"];
    [_semesterNames addObject:@"Registration"];
    _deptNames=[[NSMutableArray alloc]init];
    _courseNames=[[NSMutableArray alloc]init];
    _sectionNames=[[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _deptDone.hidden=YES;
    _courseDone.hidden=YES;
    _sectionDone.hidden=YES;
    self.navigationController.title=@"Browse";
    self.navigationController.navigationBar.topItem.title = @"";
    
}
//First call loads Department titles
- (void)fetchedDept:(NSData *)responseData {
    //parse out the json data
    if (responseData==nil)
        return;
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
    _deptDone.hidden=NO;
    [_departmentPicker setUserInteractionEnabled:YES];
    _courseDone.hidden=YES;
    _sectionPicker.hidden=YES;
    _sectionDone.hidden=YES;
    _coursePicker.hidden=YES;
    
}
//Called after confirming department, loads course names
- (void)fetchedCourse:(NSData *)responseData {
    //parse out the json data
    if (responseData==nil)
        return;
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
    _deptDone.hidden=YES;
    [_departmentPicker setUserInteractionEnabled:NO];
    _coursePicker.hidden=NO;
    _courseDone.hidden=NO;
    _sectionDone.hidden=YES;
    [_coursePicker setUserInteractionEnabled:YES];
}

- (void)fetchedSections:(NSData *)responseData {
    //parse out the json data
    if (responseData==nil)
        return;
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
    _sectionPicker.hidden=NO;
    _sectionDone.hidden=NO;
    _courseDone.hidden=YES;
    [_coursePicker setUserInteractionEnabled:NO];
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
    if (pickerView==_semesterPicker)
        return [_semesterNames count];
    else if (pickerView==_departmentPicker)
    return [_deptNames count];
    else if (pickerView==_coursePicker)
        return [_courseNames count];
    return [_sectionNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (pickerView==_semesterPicker)
    {
        return [_semesterNames objectAtIndex:row];
    }
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
- (IBAction)semesterDone:(id)sender {
    _semesterChoice=[_semesterNames objectAtIndex:[_semesterPicker selectedRowInComponent:0]];
    dispatch_async(kBgQueue, ^{
        NSString *apiURL=[NSString stringWithFormat:
                          @"%@"
                          @"&term=%@",baseURL,_semesterChoice
                          ];
        apiURL=[apiURL lowercaseString];
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiURL]];
        [self performSelectorOnMainThread:@selector(fetchedDept:)withObject:data waitUntilDone:YES];
    });
}

- (IBAction)deptDone:(id)sender {
    _deptChoice=[_deptNames objectAtIndex:[_departmentPicker selectedRowInComponent:0]];
    dispatch_async(kBgQueue, ^{
        NSString *apiURL=[NSString stringWithFormat:
                          @"%@"
                          @"&term=%@"
                          @"&dept=%@",baseURL,_semesterChoice,[_deptNames objectAtIndex:[_departmentPicker selectedRowInComponent:0]]
                          ];
        apiURL=[apiURL lowercaseString];
        NSLog(@"%@",apiURL);
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiURL ]];
        [self performSelectorOnMainThread:@selector(fetchedCourse:)withObject:data waitUntilDone:YES];
    
       });
}

- (IBAction)courseDone:(id)sender {
    _courseChoice=[_courseNames objectAtIndex:[_coursePicker selectedRowInComponent:0]];
    dispatch_async(kBgQueue, ^{
    NSString *apiURL=[NSString stringWithFormat:
                          @"%@"
                          @"&term=%@"
                          @"&dept=%@"
                          @"&number=%@",baseURL,_semesterChoice,_deptChoice,[_courseNames objectAtIndex:[_coursePicker selectedRowInComponent:0]]
                          ];
        apiURL=[apiURL lowercaseString];
        NSLog(@"%@",apiURL);
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiURL]];
        [self performSelectorOnMainThread:@selector(fetchedSections:)withObject:data waitUntilDone:YES];

    });

}

#pragma mark - Prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqual:@"detailsView"])
    {
        _sectionChoice=[_sectionNames objectAtIndex:[_sectionPicker selectedRowInComponent:0]];
        CourseDetailViewController *fivc=[segue destinationViewController];
        fivc.courseTerm=_semesterChoice;
        fivc.courseDept=_deptChoice;
        fivc.courseNumber=_courseChoice;
        fivc.courseSection=_sectionChoice;
        fivc.hidesBottomBarWhenPushed=YES;
    }
    
}

- (NSMutableArray *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

#pragma mark -memory management
-(void) dealloc
{
    
    [_semesterNames removeAllObjects];
    [_deptNames removeAllObjects];
    [_courseNames removeAllObjects];
    [_sectionNames removeAllObjects];
    
}

@end
