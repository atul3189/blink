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

#import "BKPubKeyDetailsViewController.h"
#import "UIDevice+DeviceName.h"
#import "BKDefaults.h"
#import "BKiCloudSyncHandler.h"

@interface BKPubKeyDetailsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *fingerPrint;
@property (weak, nonatomic) IBOutlet UITextField *comments;
@end

@implementation BKPubKeyDetailsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  _name.text = _pubkey.ID;
  _fingerPrint.text = [BKPubKey fingerprint:_pubkey.publicKey];
  _comments.text = [NSString stringWithFormat:@"%@@%@", [BKDefaults defaultUserName] , [UIDevice getInfoTypeFromDeviceName:BKDeviceInfoTypeDeviceName]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
  if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound && !_isConflictCopy) {
    [self performSegueWithIdentifier:@"unwindFromDetails" sender:self];
  }
  [super viewWillDisappear:animated];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if (textField == _name) {
    if ([string isEqualToString:@" "]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  if(_pubkey.iCloudConflictCopy || _isConflictCopy){
    return NO;
  }
  return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)copyPublicKey:(id)sender
{
  UIPasteboard *pb = [UIPasteboard generalPasteboard];
  [pb setString:_pubkey.publicKey];
}

- (IBAction)copyPrivateKey:(id)sender
{
  UIPasteboard *pb = [UIPasteboard generalPasteboard];
  [pb setString:_pubkey.privateKey];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"unwindFromDetails"]) {
    if (_name.text.length && ![_name.text isEqualToString:_pubkey.ID]) {
      [BKPubKey updateCard:_pubkey.ID withId:_name.text withiCloudId:_pubkey.iCloudRecordId andLastModifiedTime:[NSDate date]];
      _pubkey.ID = _name.text;
      [BKPubKey saveIDS];
    }
  }
}

# pragma mark - UITableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if(indexPath.section == 1){
    if(indexPath.row == 0){
      BKPubKeyDetailsViewController *iCloudCopyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"keyDetails"];
      iCloudCopyViewController.isConflictCopy = YES;
      iCloudCopyViewController.pubkey = _pubkey.iCloudConflictCopy;
      [self.navigationController pushViewController:iCloudCopyViewController animated:YES];
    } else if (indexPath.row == 1){
      if(_pubkey.iCloudRecordId){
        [[BKiCloudSyncHandler sharedHandler]deleteRecord:_pubkey.iCloudRecordId ofType:BKiCloudRecordTypeKeys];
      }
      [BKPubKey saveCard:_pubkey.ID privateKey:_pubkey.iCloudConflictCopy.privateKey publicKey:_pubkey.iCloudConflictCopy.publicKey];
      [BKPubKey updateCard:_pubkey.ID  withId:_pubkey.ID withiCloudId:_pubkey.iCloudConflictCopy.iCloudRecordId andLastModifiedTime:_pubkey.iCloudConflictCopy.lastModifiedTime];
      [BKPubKey markCard:_pubkey.ID forRecord:[BKPubKey recordFromKey:_pubkey] withConflict:NO];
      [[BKiCloudSyncHandler sharedHandler]checkForReachabilityAndSync:nil];
      [self.navigationController popViewControllerAnimated:YES];
    } else if(indexPath.row == 2){
      [[BKiCloudSyncHandler sharedHandler]deleteRecord:_pubkey.iCloudConflictCopy.iCloudRecordId ofType:BKiCloudRecordTypeKeys];
      if(!_pubkey.iCloudRecordId){
        [BKPubKey markCard:_pubkey.iCloudConflictCopy.ID forRecord:[BKPubKey recordFromKey:_pubkey] withConflict:NO];
      }
      [[BKiCloudSyncHandler sharedHandler]checkForReachabilityAndSync:nil];
      [self.navigationController popViewControllerAnimated:YES];
    }
  }
}

- (BOOL)showConflictSection{
  return (_pubkey.iCloudConflictDetected.boolValue && _pubkey.iCloudConflictCopy);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 1 && ![self showConflictSection]) {
    //header height for selected section
    return 0.1;
  } else {
    //keeps all other Headers unaltered
    return [super tableView:tableView heightForHeaderInSection:section];
  }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if (section == 1 && ![self showConflictSection]) {
    //header height for selected section
    return 0.1;
  } else {
    // keeps all other footers unaltered
    return [super tableView:tableView heightForFooterInSection:section];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if(section == 0){
    if (![self showConflictSection] && !_isConflictCopy) {
      return 1;
    } else {
      return 2;
    }
  }
  else if (section == 1) { //Index number of interested section
    if (![self showConflictSection]) {
      return 0; //number of row in section when you click on hide
    } else {
      return 3; //number of row in section when you click on show (if it's higher than rows in Storyboard, app will crash)
    }
  } else {
    return [super tableView:tableView numberOfRowsInSection:section]; //keeps inalterate all other rows
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  if(section == 1 && ![self showConflictSection]){
    return @"";
  }else{
    return [super tableView:tableView titleForHeaderInSection:section];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
  if(section == 1 && ![self showConflictSection]){
    return @"";
  }else{
    return [super tableView:tableView titleForFooterInSection:section];
  }
}

@end
