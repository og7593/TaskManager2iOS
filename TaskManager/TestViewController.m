//
//  TestViewController.m
//  TaskManager
//
//  Created by Omid Ghomeshi on 9/6/14.
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import "TestViewController.h"
#import "Parse/Parse.h"

@interface TestViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

//@property (strong, nonatomic) UIColor *color;

//@property (strong, nonatomic) id textFieldDidBeginEditingNotificationObserver;

@end

@implementation TestViewController

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
    
    //[self.button setTitle:@"test" forState:UIControlStateNormal];
    //self.color = [UIColor purpleColor];
    
    //self.userNameText.textColor = [UIColor purpleColor];
    
//    __weak typeof(self) weakSelf = self;
//    self.textFieldDidBeginEditingNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:self.userNameText queue:nil usingBlock:^(NSNotification *note) {
//        __strong typeof(self) strongSelf = weakSelf;
//        
//        if (strongSelf) {
//            strongSelf.userNameText.textColor = self.color;
//        }
//    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //self.userNameText.textColor = [UIColor greenColor];
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self.textFieldDidBeginEditingNotificationObserver];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signIn:(UIButton *)sender {
    
    UIAlertView *avError = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:@"Incorrect Username or Password"
                                                delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil, nil];
    
    UIAlertView *avLoad = [[UIAlertView alloc] initWithTitle:@"Logging In"
                                                     message:@"Please Wait..."
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil, nil];
    
    NSString *userName = self.userNameText.text;
    NSString *password = self.passwordText.text;
    
    if ([userName isEqualToString:@""] || [password isEqualToString:@""]) {
        [avError show];
        return;
    }
    
    [avLoad show];
    [PFUser logInWithUsernameInBackground:userName password:password
                                    block:^(PFUser *user, NSError *error) {
                                        [avLoad dismissWithClickedButtonIndex:0 animated:YES];
                                        if (user) {
                                            // Do stuff after successful login.
                                            [self performSegueWithIdentifier:@"buttonSegue" sender:sender];
                                        } else {
                                            // The login failed. Check error to see why.
                                            [avError show];
                                        }
                                    }];
}
- (IBAction)createAccount:(UIButton *)sender {
}

- (IBAction)forgotPassword:(UIButton *)sender {
}

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"buttonSegue"]) {
        UIViewController *destinationViewController = [segue destinationViewController];
        
        
        
        destinationViewController.view.backgroundColor = [UIColor greenColor];
    }
}*/

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
