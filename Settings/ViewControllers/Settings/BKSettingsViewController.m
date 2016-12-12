//
//  BKSettingsViewController.m
//  Blink
//
//  Created by Atul M on 01/11/16.
//  Copyright © 2016 Carlos Cabañero Projects SL. All rights reserved.
//

#import "BKSettingsViewController.h"
#import "BKDefaults.h"
#import "BKiCloudSyncHandler.h"
#import "BKiCloudConfigurationViewController.h"
#import "BKTouchIDAuthManager.h"
#import "BKUserConfigurationManager.h"
@interface BKSettingsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *iCloudSyncStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel *autoLockStatusLabel;
@end

@implementation BKSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  self.userNameLabel.text = [BKDefaults defaultUserName];
  self.iCloudSyncStatusLabel.text = [BKUserConfigurationManager userSettingsValueForKey:@"iCloudSync"] == true ? @"On" : @"Off";
  self.autoLockStatusLabel.text = [BKUserConfigurationManager userSettingsValueForKey:@"autoLock"] == true ? @"On" : @"Off";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unwindFromDefaultUser:(UIStoryboardSegue *)sender{
  
}
@end
