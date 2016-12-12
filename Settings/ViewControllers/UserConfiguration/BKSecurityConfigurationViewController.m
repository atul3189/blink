//
//  BKSecurityConfigurationViewController.m
//  Blink
//
//  Created by Atul M on 12/12/16.
//  Copyright © 2016 Carlos Cabañero Projects SL. All rights reserved.
//

#import "BKSecurityConfigurationViewController.h"
#import "Blink-swift.h"
#import "BKUserConfigurationManager.h"

@interface BKSecurityConfigurationViewController ()<UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UISwitch *toggleAppLock;

@end

@implementation BKSecurityConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
}

- (void)setupUI{
  [_toggleAppLock setOn:[BKUserConfigurationManager userSettingsValueForKey:@"autoLock"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didToggleSwitch:(id)sender{
  UISwitch *toggleSwitch = (UISwitch*)sender;
  if (toggleSwitch == _toggleAppLock){
    NSString *state = nil;
    if([toggleSwitch isOn]){
      state = @"SetPasscode";
    }else{
      state = @"RemovePasscode";
    }
    PasscodeLockViewController *lockViewController = [[PasscodeLockViewController alloc]initWithStateString:state];
    lockViewController.completionCallback = ^{
      [BKUserConfigurationManager setUserSettingsValue:!_toggleAppLock.isOn forKey:@"autoLock"];
      [self setupUI];
    };
    [self.navigationController pushViewController:lockViewController animated:YES];
  }
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self setupUI];
}


@end
