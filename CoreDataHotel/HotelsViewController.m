//
//  HotelsViewController.m
//  CoreDataHotel
//
//  Created by Kent Rogers on 4/24/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import "HotelsViewController.h"
#import "AutoLayout.h"

#import "AppDelegate.h"

#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

#import "ViewController.h"
#import "RoomsViewController.h"

@interface HotelsViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)NSArray *allHotels;

@property(strong, nonatomic)UITableView *tableView;

@end

@implementation HotelsViewController

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
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
    
    
}

- (NSArray *)allHotels{
    
    if (!_allHotels) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        
        NSError *fetchError;
        
        NSArray *hotels = [context executeFetchRequest:request error:&fetchError];
        
        if (fetchError) {
            NSLog(@"There was an error fetching hotels from the Core Data!");
        }
        
        _allHotels = hotels;
        
    }
    
    return _allHotels;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomsViewController *newRoomsView = [[RoomsViewController alloc]init];
    newRoomsView.currentHotel = self.allHotels[indexPath.row];
    
    [self.navigationController pushViewController:newRoomsView animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    Hotel *hotel = self.allHotels[indexPath.row];
    
    cell.textLabel.text = hotel.name;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allHotels.count;
}

@end
