//
//  AvailabilityViewController.m
//  CoreDataHotel
//
//  Created by Kent Rogers on 4/25/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "AutoLayout.h"

#import "AppDelegate.h"

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

- (NSFetchedResultsController *)availableRooms{
    
    if (!_availableRooms) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        request.predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", self.endDate, self.startDate];
        
        NSError *roomError;
        NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&roomError];
        
        if (roomError) {
            NSLog(@"Error happened while retrieving all rooms from Core Data");
        }
        
        NSMutableArray *unavailableRooms = [[NSMutableArray alloc]init];
        
        for (Reservation *reservation in results) {
            [unavailableRooms addObject:reservation.room];
        }
        
        NSFetchRequest *roomRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
        roomRequest.predicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", unavailableRooms];
        
        NSSortDescriptor *roomSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hotel.name" ascending:YES];
        NSSortDescriptor *roomNumberSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
        
        roomRequest.sortDescriptors = @[roomSortDescriptor, roomNumberSortDescriptor];
        
        NSError *availableRoomError;
        //        _availableRooms = [appDelegate.persistentContainer.viewContext executeFetchRequest:roomRequest error:&availableRoomError];
        
        _availableRooms = [[NSFetchedResultsController alloc] initWithFetchRequest:roomRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"hotel.name" cacheName:nil];
        
        [_availableRooms performFetch:&availableRoomError];
    }
    
    return _availableRooms;
}

- (void)loadView{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds, $%0.2f per night)", currentRoom.number, currentRoom.beds, currentRoom.rate];
    
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
