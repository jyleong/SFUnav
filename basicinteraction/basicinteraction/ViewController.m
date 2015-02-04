//
//  ViewController.m
//  basicinteraction
//
//  Created by James Leong on 2015-02-03.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UITextField *simpletextField;
@property (weak, nonatomic) IBOutlet UILabel *simpleLabel;

@end

@implementation ViewController

- (IBAction)changeLabel:(id)sender {
    //add code to change label and show it
    NSString *contents = self.simpletextField.text;
    NSString *message = [NSString stringWithFormat:@"Hello James, its %@", contents];
    self.simpleLabel.text = message;
    
    [self.simpletextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField endEditing:YES];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // by any touch action
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
