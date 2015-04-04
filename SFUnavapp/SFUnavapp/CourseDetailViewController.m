//
//  CourseDetailViewController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-04-03.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "CourseDetailViewController.h"
#define baseURL [NSString stringWithFormat:@"http://www.sfu.ca/bin/wcm/course-outlines?year=current"]
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define onlineDisplayBaseURL [NSString stringWithFormat:@"https://www.sfu.ca/outlines.html?"]
@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _moreDetails.layer.cornerRadius = 4;
    _moreDetails.layer.borderWidth = 0;
    _moreDetails.layer.borderColor = [UIColor clearColor].CGColor;
    _moreDetails.hidden=YES;
    _nodePath=@"";
    _courseTimesText=@"";
    _instructorNameText=@"";
    _examTimesText=@"";
    _courseTitle.text=[[NSString stringWithFormat:@"%@ %@",_courseDept,_courseNumber] uppercaseString];
    [self genData];
}

- (void)fetchedInfo:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray *info=[json objectForKey:@"courseSchedule"];
    
    for (int i=0;i<[info count];i++)
    {
        _courseTimesText=[_courseTimesText stringByAppendingFormat:
                          @"%@ "
                          @"from: %@ "
                          @"to %@\n"
                          @"At: %@ "
                          @"%@ on "
                          @"%@ Campus\n",[info[i] objectForKey:@"days"],[info[i] objectForKey:@"startTime"],[info[i] objectForKey:@"endTime"],[info[i] objectForKey:@"buildingCode"],[info[i] objectForKey:@"roomNumber"],[info[i] objectForKey:@"campus"]];
        
    }
    _courseTimes.text=_courseTimesText;
    [_courseTimes flashScrollIndicators];
    
    info=[json objectForKey:@"instructor"];
    for (int i=0;i<[info count];i++)
    {
        _instructorNameText=[_instructorNameText stringByAppendingFormat:
                          @"%@ \n",[info[i] objectForKey:@"name"]];
    }
    _instructorName.text=_instructorNameText;
    
    info=[json objectForKey:@"examSchedule"];
    //18 characters at end have useless data for startDate
    for (int i=0;i<[info count];i++)
    {
        _examTimesText=[_examTimesText stringByAppendingFormat:
                          @"%@ "
                          @"from: %@ "
                          @"to %@\n"
                          @"At: %@ "
                          @"%@ on "
                          @"%@ Campus\n",[[info[i] objectForKey:@"startDate"] substringToIndex:[[info[i] objectForKey:@"startDate"] length]-18],[info[i] objectForKey:@"startTime"],[info[i] objectForKey:@"endTime"],[info[i] objectForKey:@"buildingCode"],[info[i] objectForKey:@"roomNumber"],[info[i] objectForKey:@"campus"]];
        
    }
    _examTimes.text=_examTimesText;
    NSDictionary *info2=[json objectForKey:@"info"];
    NSString *temp=[info2 objectForKey:@"nodePath"];
    _nodePath=[NSString stringWithFormat:@"%@%@",onlineDisplayBaseURL,temp];
    
    _moreDetails.hidden=NO;
}

-(void) genData{
    dispatch_async(kBgQueue, ^{
        NSString *apiURL=[NSString stringWithFormat:
                          @"%@"
                          @"&term=%@"
                          @"&dept=%@"
                          @"&number=%@"
                          @"&section=%@",baseURL,_courseTerm,_courseDept,_courseNumber,_courseSection
                          ];
        apiURL=[apiURL lowercaseString];
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiURL ]];
        NSLog(@"info url:%@",apiURL);
        [self performSelectorOnMainThread:@selector(fetchedInfo:)withObject:data waitUntilDone:YES];
    });
}


- (IBAction)moreDetailsPress:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_nodePath]];
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

@end
