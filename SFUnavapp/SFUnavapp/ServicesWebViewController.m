//
//  ServicesWebViewController.m
//  SFUnavapp
//  Team NoMacs
//  Created by Arjun Rathee on 2015-02-14.
//
//	Edited by Arjun Rathee
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "ServicesWebViewController.h"
#import "ServicesTableViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green: ((float)((rgbValue & 0xF00) >> 8))/255.0 blue: ((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ServicesWebViewController ()
{
    bool loggedIn;
}

@property (weak, nonatomic) IBOutlet UIWebView *currentlink;

@end

@implementation ServicesWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=_currentURL.serviceName;
    //_currentlink.delegate=self;
    //Loads the url provided in custom object and assigns the title to the navigation bar
    NSURL *url= [NSURL URLWithString:_currentURL.serviceURL];
    NSURLRequest *requestObj= [NSURLRequest requestWithURL:url];
    [_currentlink loadRequest:requestObj];
    NSLog(@"string url%@",url);
    self.navigationController.navigationBar.topItem.title = @""; // line to hide back button text
    [[UIToolbar appearance] setBarTintColor:UIColorFromRGB(0xB5111B)];
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
    
    if (autoLogin)
        loggedIn=NO;
    else
        loggedIn=YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webview
{
    NSLog(@"did finish load");
    if (([_currentURL.serviceName isEqualToString:@"goSFU (SIS)"]) && (loggedIn==NO))
    {
        NSLog(@"found sis FOR AUTOLOGIN");
        NSString *js= [NSString stringWithFormat:
                       @"var x= document.getElementsByClassName('PSPUSHBUTTON')"
                       @"x[6].name"
                        ];
        while([[_currentlink stringByEvaluatingJavaScriptFromString:js] isEqualToString:@"Submit"])
        {
            NSLog(@"returning");
            
        }
        //[self injectJavatoSIS];
    }
}

-(void) injectJavatoSIS
{
//    NSString *js= [NSString stringWithFormat:
//         @"var x= document.getElementsByClassName('PSPUSHBUTTON')"
//         @"x[6].name"
//         ];
//    //inject javascript code
//    //http://www.kirupa.com/html5/running_your_code_at_the_right_time.htm
//    if ([[_currentlink stringByEvaluatingJavaScriptFromString:js] isEqualToString:@"Submit"])
//    {
//        NSLog(@"Element not found");
//        [self webViewDidFinishLoad:_currentlink];
//        return;
//        
//    }
    NSLog(@"prepare to inject");
    NSString *js= [NSString stringWithFormat:
         @"var user=document.getElementById('user');"
         @"user.value='%@';"
         @"var pwd= document.getElementById('pwd');"
         @"pwd.value='%@';"
         @"var form=document.getElementById('login');"
         @"form.submit();",username,password
         ];
        NSLog(@"injecting into sis");
    [_currentlink stringByEvaluatingJavaScriptFromString:js];
    //NSLog(@"%@",[_currentlink stringByEvaluatingJavaScriptFromString:js]);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
