//
//  RoomsViewController.m
//  CoreDataHotel
//
//  Created by Kent Rogers on 4/25/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "RoomsViewController.h"

#import "AppDelegate.h"

#import "AutoLayout.h"

#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

@interface RoomsViewController () <UITableViewDataSource>

@property(strong, nonatomic)NSArray *allRooms;

@property(strong, nonatomic)UITableView *tableView;

@end

@implementation RoomsViewController

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.tableView];
    
    [AutoLayout fullScreenConstraintsWithVFLForView:self.tableView];
    
    [self setupLayout];
    
    //add tableView as subview and apply constraints
}

- (void)setupLayout{
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.allRooms = [[self.currentHotel rooms] allObjects];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    Room *room = [self.allRooms objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%hd",room.number];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allRooms.count;
}

@end
