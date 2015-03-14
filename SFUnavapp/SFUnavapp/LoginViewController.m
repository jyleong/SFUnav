//
//  LoginViewController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-10.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//
#import "TFHpple.h"
#import "LoginViewController.h"
#import "ServicesTableViewController.h"
#import "Reachability.h"

@interface LoginViewController ()
{
    NSString *js;
    BOOL buttonCall;
    BOOL internetStatus;
    
}
@property (strong, nonatomic) UIGestureRecognizer *tapper; // for the gesture to dismiss keyboard when tap out of textfield
@end

@implementation LoginViewController

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
    buttonCall=NO;
    autoLogin=NO;
    _tapper = [[UITapGestureRecognizer alloc]
               initWithTarget:self action:@selector(handleSingleTap:)];
    _tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_tapper];
    [self.view addSubview:_web];
    //[_web setDelegate:self];
    NSURL *url= [NSURL URLWithString:@"https://cas.sfu.ca/cas/login?"];
    NSURLRequest *requestObj= [NSURLRequest requestWithURL:url];
    //    [requestObj setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/536.26.17 (KHTML, like Gecko) Version/6.0.2 Safari/536.26.17" forHTTPHeaderField:@"User-Agent"];
    NSLog(@"Loading webpage\n");
    [_web loadRequest:requestObj];
    
    
}

-(BOOL) checkInternet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        return NO;
    }
    NSLog(@"There IS internet connection");
    return  YES;
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)loginButtonPress:(id)sender {
    
    [_passWord resignFirstResponder];
    [_userName resignFirstResponder];
    internetStatus=[self checkInternet];
    
    buttonCall=YES;
    if (internetStatus==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Internet Connection Required" delegate: self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        autoLogin=NO;
        return;
    }
    
  
    if ([_userName.text isEqualToString:@""] || [_passWord.text isEqualToString:@""])
    {
        _errorDisplay.text=@"Both username and password fields are required";
        return;
    }
    //create javascript code as single string
    js= [NSString stringWithFormat:
    @"var usrname = document.getElementById('username');"
    @"usrname.value='%@';"
    @"var pwd= document.getElementById('password');"
    @"pwd.value='%@';"
    @"var form= document.getElementById('fm1');"
    @"form.submit();",_userName.text,_passWord.text];
    //inject javascript code
    [_web stringByEvaluatingJavaScriptFromString:js];
    [self checkValidInfo];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0)
        [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES]; // so the keyboard will always resign when you click ANYWHERE
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (buttonCall==YES)
    {
        buttonCall=NO;
        
        //[_web stringByEvaluatingJavaScriptFromString:js];
        
        [self checkValidInfo];
    }
}

-(void) checkValidInfo
{

        js= [NSString stringWithFormat:
         @"var success = document.getElementsByTagName('h2');"
         @"success[1].innerHTML"
         ];
        NSLog(@"%@",[_web stringByEvaluatingJavaScriptFromString:js]);
        if([[_web stringByEvaluatingJavaScriptFromString:js] isEqualToString:@"You have successfully logged into the Central Authentication Service."])
        {
            _errorDisplay.text=@"Successfully Logged In";
            NSLog(@"SUCCESS");
            autoLogin=YES;
            username=_userName.text;
            password=_passWord.text;
            return;
        }
        _errorDisplay.text=@"The credentials you provided cannot be determined to be authentic.";
        autoLogin=NO;
    


}

@end
