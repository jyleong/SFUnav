//
//  TabBarController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-17.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate=self;
    self.tabBarController.tabBar.delegate=self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"tabOrder"];
    NSArray* tabBarItems=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (tabBarItems)
    {
        [self.tabBarController.tabBar setItems:tabBarItems animated:YES];
        NSLog(@"Loading changed Order%@",tabBarItems);
    }

}

-(void) saveUserState
{
    NSLog(@"Save user state");
}


-(void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed
{
    NSLog(@"tab bar customizer");
    if (changed)
    {
        NSLog(@"tab bar customizer");
        NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:items];
        [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"tabOrder"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"%@",self.tabBarController.viewControllers);
        [self.tabBarController setViewControllers:items animated:YES];
    }
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
/*
 //
 //  TabBarController.m
 //  SFUnavapp
 //
 //  Created by Arjun Rathee on 2015-03-15.
 //  Copyright (c) 2015 Team NoMacs. All rights reserved.
 //
 
 #import "TabBarController.h"
 
 @interface TabBarController ()
 
 @end
 
 @implementation TabBarController
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 tab=self.tabBar;
 // Do any additional setup after loading the view.
 }
 -(void) viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 NSLog(@"Bye view");
 }
 -(void) viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 
 NSLog(@"YO!!");
 
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 NSData *data = [defaults objectForKey:@"tabOrder"];
 NSArray* tabBarItems=[NSKeyedUnarchiver unarchiveObjectWithData:data];
 if (tabBarItems)
 {   [self.tabBarController.tabBar setItems:tabBarItems];
 NSLog(@"Loading changed Order%@",self.tabBarController.viewControllers);
 }
 }
 -(void) saveUserState
 {
 NSLog(@"Save user state");
 }
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }
 
 //Tells the delegate that the tab bar customization sheet is about to be displayed.
 - (void)tabBarController:(UITabBarController *)tabBarController
 willBeginCustomizingViewControllers:(NSArray *)viewControllers
 {
 NSLog(@"WORK WORK!!!!!");
 }
 
 //This method is called in response to the user tapping the Done button on the sheet but before the sheet is dismissed.
 - (void)tabBarController:(UITabBarController *)tabBarController
 didEndCustomizingViewControllers:(NSArray *)viewControllers
 changed:(BOOL)changed
 {
 // Collect the view controller order
 NSMutableArray *titles = [NSMutableArray array];
 for (UIViewController *vc in viewControllers)
 [titles addObject:vc.title];
 
 [[NSUserDefaults standardUserDefaults]setObject:titles forKey:@"tabOrder"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 
 
 }
 
 //Tells the delegate that the user selected an item in the tab bar.
 - (void)tabBarController:(UITabBarController *)controller
 didSelectViewController:(UIViewController *)viewController
 {
 // Store the selected tab
 //        NSNumber *tabNumber = [NSNumber numberWithInt:[controller selectedIndex]];
 
 //[[NSUserDefaults standardUserDefaults]setObject:self.viewControllers forKey:@"tabOrder"];
 // [[NSUserDefaults standardUserDefaults] synchronize];
 NSLog(@"Saving changed order");
 }
 
 //-(void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed
 //{
 //    if (changed)
 //    {
 //        NSUserDefaults *tabBarOrder= [NSUserDefaults standardUserDefaults];
 //        [tabBarOrder setObject:items forKey:@"tabbar_items"];
 //    }
 //}
 /*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//@end
