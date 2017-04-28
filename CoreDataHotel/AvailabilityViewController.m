//
//  AvailabilityViewController.m
//  CoreDataHotel
//
//  Created by Kent Rogers on 4/25/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "AutoLayout.h"

#import "HotelServices.h"

#import "BookViewController.h"

#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"

#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

@interface AvailabilityViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)UITableView *tableView;

@property(strong, nonatomic)NSFetchedResultsController *availableRooms;

@end

@implementation AvailabilityViewController

- (void)loadView{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _availableRooms = [HotelServices availableRoomsWithStartDate:self.startDate andEndDate:self.endDate];
    [self setupTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc]init];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [AutoLayout fullScreenConstraintsWithVFLForView:self.tableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BookViewController *newBookView = [[BookViewController alloc]init];
    
    newBookView.startDate = self.startDate;
    newBookView.endDate = self.endDate;
    newBookView.selectedRoom = [self.availableRooms objectAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:newBookView animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.availableRooms sections]objectAtIndex:section];
    
    return sectionInfo.numberOfObjects;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Room *currentRoom = [self.availableRooms objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds, $%0.2f per night)", currentRoom.number, currentRoom.beds, currentRoom.cost];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.availableRooms.sections.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.availableRooms sections]objectAtIndex:section];
    
    return sectionInfo.name;
}



@end
