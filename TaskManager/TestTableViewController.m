//
//  TestTableViewController.m
//  TaskManager
//
//  Created by Omid Ghomeshi on 9/6/14.
//  Copyright (c) 2014 Personal. All rights reserved.
//

#import "TestTableViewController.h"
#import "Parse/Parse.h"

@interface TestTableViewController ()

@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) UITableViewCell *prototypeCell;

@end

@implementation TestTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.dataList = @[@"first", @"second", @"Third", @"Fourth", @"Fifth", @"Sixth", @"Seventh", @"Eigth", @"Ninth", @"Tenth"];
    
    //self.tableView.allowsMultipleSelection = YES;
    
    UIAlertView *avLoad = [[UIAlertView alloc] initWithTitle:@"Logging In"
                                                     message:@"Please Wait..."
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil, nil];
    [avLoad show];
    
    PFQuery *projectQuery = [PFQuery queryWithClassName:@"Project"];
    
    [projectQuery whereKey:@"Archived" equalTo:[NSNumber numberWithBool:NO]];
    [projectQuery whereKey:@"Trash" equalTo:[NSNumber numberWithBool:NO]];
    [projectQuery setLimit:1000];
    [projectQuery orderByAscending:@"DueDate"];
    
    [projectQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            
            [avLoad dismissWithClickedButtonIndex:0 animated:YES];
            self.dataList = [objects copy];
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
            });
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //tableView.allowsMultipleSelection = YES;
    self.prototypeCell = [tableView dequeueReusableCellWithIdentifier:@"testReuse" forIndexPath:indexPath];
    
    [self.prototypeCell setNeedsUpdateConstraints];
    [self.prototypeCell updateConstraintsIfNeeded];
    
    PFObject *project = (PFObject*) self.dataList[indexPath.row];
    
    /*if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testReuse"];
     }*/
    //cell.textLabel.text =  (NSString*) self.dataList[indexPath.row];
    
    UILabel* label = (UILabel *) [self.prototypeCell.contentView viewWithTag:1];
    NSString *projectName = project[@"Name"];
    [label setText:projectName];
    
    UILabel* label2 = (UILabel *) [self.prototypeCell.contentView viewWithTag:2];
    NSDate *projectDate = project[@"DueDate"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a 'at' MM.dd.yyyy"];
    NSString *projectDateStr = [dateFormat stringFromDate:projectDate];
    [label2 setText:projectDateStr];
    
    UIImageView* image = (UIImageView *) [self.prototypeCell.contentView viewWithTag:4];
    NSString* colorString = project[@"Color"];
    
    float width = image.frame.size.width;
    float height = image.frame.size.height;
    
    UIImage *circleColor;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextSetFillColorWithColor(ctx, [self getColorFromString:colorString].CGColor);
    CGContextFillEllipseInRect(ctx, rect);
    
    CGContextRestoreGState(ctx);
    circleColor = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [image setImage:circleColor];
    
    return self.prototypeCell;
}

- (UIColor*) getColorFromString:(NSString*)colorString
{
    if ([colorString isEqualToString:@"Yellow"]) {
        return [UIColor yellowColor];
    }
    else if ([colorString isEqualToString:@"Orange"]) {
        return [UIColor orangeColor];
    }
    else if ([colorString isEqualToString:@"Blue"]) {
        return [UIColor blueColor];
    }
    else if ([colorString isEqualToString:@"Purple"]) {
        return [UIColor purpleColor];
    }
    else if ([colorString isEqualToString:@"Red"]) {
        return [UIColor redColor];
    }
    else if ([colorString isEqualToString:@"Green"]) {
        return [UIColor greenColor];
    }
    else {
        return [UIColor blackColor];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //UIImageView* image = (UIImageView *) [self.prototypeCell.contentView viewWithTag:4];
    //[image setBackgroundColor:[UIColor purpleColor]];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
