////////////////////////////////////////////////////////////////////////////////
//
// B L I N K
//
// Copyright (C) 2016 Blink Mobile Shell Project
//
// This file is part of Blink.
//
// Blink is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Blink is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Blink. If not, see <http://www.gnu.org/licenses/>.
//
// In addition, Blink is also subject to certain additional terms under
// GNU GPL version 3 section 7.
//
// You should have received a copy of these additional terms immediately
// following the terms and conditions of the GNU General Public License
// which accompanied the Blink Source Code. If not, see
// <http://www.github.com/blinksh/blink>.
//
////////////////////////////////////////////////////////////////////////////////

#import "BKSmartKeysConfigViewController.h"
#import "BKReArrangeSmartKeysViewController.h"
#import "BKUserConfigurationManager.h"
#import "BKSmartKeysConfig.h"

@interface BKSmartKeysConfigViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *showWithExternalKeyboard;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation BKSmartKeysConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self setupUI];
}

- (void)setupUI
{
  [_showWithExternalKeyboard setOn:[BKUserConfigurationManager userSettingsValueForKey:BKUserConfigShowSmartKeysWithXKeyBoard]];
}

- (IBAction)didToggleSwitch:(id)sender
{
  UISwitch *toggleSwitch = (UISwitch *)sender;
  [BKUserConfigurationManager setUserSettingsValue:toggleSwitch.isOn forKey:BKUserConfigShowSmartKeysWithXKeyBoard];
}

# pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if(section == 0){
    return 1;
  } else {
    return [BKSmartKeysConfig count]+1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.section == 0){
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"smartKeysSwitchCell" forIndexPath:indexPath];
    UISwitch *showKeyboardSwitch = [cell.contentView viewWithTag:6008];
    [showKeyboardSwitch setOn:[BKUserConfigurationManager userSettingsValueForKey:BKUserConfigShowSmartKeysWithXKeyBoard]];
    return cell;
  } else {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"smartKeysConfigCell" forIndexPath:indexPath];
    if(indexPath.row < [BKSmartKeysConfig count]){
      cell.textLabel.text = [[[BKSmartKeysConfig all]objectAtIndex:indexPath.row]configName];
    } else {
      cell.textLabel.text = @"Add a new configuration";
    }
    return cell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if(indexPath.section == 1){
    self.selectedIndexPath = indexPath;
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([segue.identifier isEqualToString:@"editSmartKeysConfig"]){
    UITableViewCell *cell = (UITableViewCell*)sender;
    BKSmartKeysConfig *selectedConfig = [[BKSmartKeysConfig all]objectAtIndex:self.selectedIndexPath.row];
    BKReArrangeSmartKeysViewController *rearrangeViewController = (BKReArrangeSmartKeysViewController*)segue.destinationViewController;
    rearrangeViewController.config = selectedConfig;    
  }
}

@end
