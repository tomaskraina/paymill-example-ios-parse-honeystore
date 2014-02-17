//
//  PMLStoreViewController.m
//  Honey Store
//
//  Created by Vladimir Marinov on 17.12.13.
//  Copyright (c) 2013 г. PAYMILL. All rights reserved.
//

#import "PMLStoreViewController.h"
#import "PMLProductDetailsViewController.h"
#import "PMLStoreController.h"
#import "MBProgressHUD.h"
#import "PMLProductTableViewCell.h"
#import <PayMillSDK/PMSDK.h>
#import <Parse/PFUser.h>
#import <Parse/Parse.h>

@interface PMLStoreViewController () {
   
}
@end

@implementation PMLStoreViewController


- (void)awakeFromNib
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		}
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    [super viewDidLoad];
 	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                      target:self action:@selector(refreshObjects:)];
	self.navigationItem.leftBarButtonItem = refreshButton;
    self.productsTable.backgroundColor = [UIColor whiteColor];
  }
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([PMLStoreController sharedInstance].Products == Nil){
        [self refreshObjects:nil];
    }
     
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions

- (void)refreshObjects:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[PMLStoreController sharedInstance] getItemsWithComplte:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.productsTable reloadData];
    }];
}
- (void)orderProduct:(UIButton*)button{
	[self performSegueWithIdentifier:@"OrderProductSeque" sender:button];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PMLProductTableViewCell rowHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [PMLStoreController sharedInstance].Products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"productTableCell";
    // load from NIB
    PMLProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
	PMLProduct *product = [PMLStoreController sharedInstance].Products[indexPath.row];
    [cell configureProduct:product];
    [cell.orderButton addTarget:self action:@selector(orderProduct:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderButton.tag = indexPath.row;
    [cell setUserInteractionEnabled:YES];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.tag = indexPath.row;
 	[self performSegueWithIdentifier:@"OrderProductSeque" sender:tableView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"OrderProductSeque"]) {
		UIControl *senderControl = (UIControl*)sender;
		PMLProduct *product = [PMLStoreController sharedInstance].Products[senderControl.tag];
 		PMLProductDetailsViewController *cvc = (PMLProductDetailsViewController *)[segue destinationViewController];
		[cvc setSelectedProduct: product];
    }
}

@end
