//
//  BKReArrangeSmartKeysViewController.m
//  Blink
//
//  Created by Atul M on 21/02/17.
//  Copyright © 2017 Carlos Cabañero Projects SL. All rights reserved.
//

#import "BKReArrangeSmartKeysViewController.h"
#import "BKSmartKeysConfig.h"
#import "SmartKeysView.h"

@interface BKReArrangeSmartKeysViewController ()

@end

@implementation BKReArrangeSmartKeysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.config.keyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"smartKeysConfigCell" forIndexPath:indexPath];
  SmartKey *key = [self.config.keyList objectAtIndex:indexPath.row];
  cell.textLabel.text = key.name;
    // Configure the cell...
    
    return cell;
}


- (IBAction)didTapOnEditButton:(id)sender{
  [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
  [self.config.keyList insertObject: [self.config.keyList objectAtIndex:sourceIndexPath.row] atIndex:destinationIndexPath.row];
  [self.config.keyList removeObjectAtIndex:(sourceIndexPath.row + 1)];
  [BKSmartKeysConfig saveConfig:self.config.configName withKeyList:self.config.keyList];
}

@end
