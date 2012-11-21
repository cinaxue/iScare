//
//  UserInfoViewController.m
//  iScare
//
//  Created by Cina on 11/19/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoAvator.h"
#import "SelectHeightViewController.h"
#import "SelectWeightViewController.h"
#import "Tools.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController
@synthesize mTableView;

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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mTableView reloadData];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingFormat:@"/Settings.plist"];
    NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];

    if (actionSheet.tag == 0) { // gender
        if (buttonIndex==0) {
            [aDic setValue:[NSNumber numberWithBool:YES] forKey:@"UserGender"];
            [[Tools sharedTools] setMUserGender:YES];
        }else if (buttonIndex == 1)
        {
            [aDic setValue:[NSNumber numberWithBool:NO] forKey:@"UserGender"];
            [[Tools sharedTools] setMUserGender:NO];
        }
    }else
    {
        if (buttonIndex==0) {
            [aDic setValue:@"公斤" forKey:@"MeasureUnit"];
            [[Tools sharedTools] setMMeasureUnit:@"公斤"];
        }else if (buttonIndex == 1)
        {
            [aDic setValue:@"斤" forKey:@"MeasureUnit"];
            [[Tools sharedTools] setMMeasureUnit:@"磅"];
        }
    }
    [aDic writeToFile:path atomically:YES];
    [self.mTableView reloadData];
}

-(void)goSelectSex:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"女",@"男", nil];
    actionSheet.cancelButtonIndex = 1;
    actionSheet.tag =0;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

-(void)goSelectMeasureUnit:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择测量单位" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"公斤",@"磅", nil];
    actionSheet.tag =1;
    actionSheet.cancelButtonIndex = 1;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

-(void)goSelectHeight:(id)sender
{
    SelectHeightViewController *addWeightViewController = [[SelectHeightViewController alloc] initWithNibName:@"SelectHeightViewController" bundle:nil];
    addWeightViewController.title = @"Select Hight";
    [self.navigationController pushViewController:addWeightViewController animated:YES];
    [addWeightViewController release];
}

-(void)goSelectWeight:(id)sender
{
    SelectWeightViewController *addWeightViewController = [[SelectWeightViewController alloc] initWithNibName:@"SelectWeightViewController" bundle:nil];
    addWeightViewController.title = @"Select Weight";
    [self.navigationController pushViewController:addWeightViewController animated:YES];
    [addWeightViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }else
        return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Normal";
    static NSString *CellIdentifierHead = @"Head";
    
    if (indexPath.row != 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text = @"身高";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f%@", [Tools sharedTools].mUserHight,@"cm"];
                break;
            case 2:
                cell.textLabel.text = @"体重";
                if ([Tools sharedTools].mUserWeights.count > 0) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f%@", [[[[Tools sharedTools].mUserWeights lastObject] valueForKey:@"weight"] floatValue],[Tools sharedTools].mMeasureUnit];
                }else{
                    float defaultWeight = 80.0f;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f%@", defaultWeight,[Tools sharedTools].mMeasureUnit];
                }
                break;
            case 3:
                cell.textLabel.text = @"性别";
                if ([Tools sharedTools].mUserGender == YES) {
                    cell.detailTextLabel.text = @"女";
                }else
                    cell.detailTextLabel.text = @"男";

                break;
            case 4:
                cell.textLabel.text = @"测量单位";
                cell.detailTextLabel.text = [Tools sharedTools].mMeasureUnit;
                break;
            default:
                cell.textLabel.text = @"身高";
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f%@", [Tools sharedTools].mUserHight,@"cm"];
                break;
        }
        
        return cell;
    }
    
    // get cell
    UserInfoAvator *cell =(UserInfoAvator*) [tableView dequeueReusableCellWithIdentifier:CellIdentifierHead];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoAvator" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    cell.mName.text = @"Cina";
  
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
            [self goSelectHeight:nil];
            break;
        
        case 2:
            [self goSelectWeight:nil];
            break;
        
        case 3:
            [self goSelectSex:nil];
            break;
        
        case 4:
            [self goSelectMeasureUnit:nil];
            break;
            
        default:
            break;
    }
}

@end
