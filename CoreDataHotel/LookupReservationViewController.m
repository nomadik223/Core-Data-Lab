//
//  LookupReservationViewController.m
//  CoreDataHotel
//
//  Created by Kent Rogers on 4/27/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//


#import "LookupReservationViewController.h"

#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"

#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"

#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

#import "AutoLayout.h"

#import "AppDelegate.h"

@interface LookupReservationViewController () <UITableViewDataSource, UISearchBarDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *reservationDetails;
@property(strong, nonatomic) UISearchBar *searchBar;
//@property(strong, nonatomic) NSArray *searchResult;
@property(strong, nonatomic) NSMutableArray *filteredReservation;

@end


@implementation LookupReservationViewController

BOOL isSearching;

- (NSArray *)reservationDetails {
    if (!_reservationDetails) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        
        NSError *reservationError;
        
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
        
        NSArray *reservationDetails = [context executeFetchRequest:request error:&reservationError];
        
        if (reservationError) {
            NSLog(@"There was a reservation fetch error.");
        }
        _reservationDetails = reservationDetails;
        
    }
    return _reservationDetails;
}

- (void)loadView {
    
    [super loadView];
    
    [self setupViewLayout];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tableView reloadData];
    
}

- (void)setupViewLayout {
    
    self.searchBar = [[UISearchBar alloc]init];
    self.tableView = [[UITableView alloc]init];
    
    self.searchBar.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat frameHeight = (windowHeight - topMargin - statusBarHeight);
    
    NSDictionary *viewDictionary = @{@"searchBar": self.searchBar,
                                     @"tableView": self.tableView};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin], @"frameHeight": [NSNumber numberWithFloat:frameHeight]};
    
    NSString *visualFormatString = @"V:|-topMargin-[searchBar(==topMargin)][tableView(==frameHeight)]|";
    
    [AutoLayout leadingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout trailingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout leadingConstraintFrom:self.tableView toView:self.view];
    [AutoLayout trailingConstraintFrom:self.tableView toView:self.view];
    
    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary forMetricsDictionary:metricsDictionary withOptions:0 withVisualFormat:visualFormatString];
    
}

//MARK: Required methods for UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isSearching) {
        return self.filteredReservation.count;
    }
    else {
        return self.reservationDetails.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    Reservation *reservations;
    if (self.filteredReservation == nil) {
        reservations = self.reservationDetails[indexPath.row];
    } else {
        reservations = self.filteredReservation[indexPath.row];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    
    NSString *formattedStartDateString = [dateFormatter stringFromDate:reservations.startDate];
    
    NSString *formattedEndDateString = [dateFormatter stringFromDate:reservations.endDate];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@: %@ in Room: %i, From: %@ Check-Out: %@", reservations.guest.firstName, reservations.guest.lastName, reservations.room.hotel.name, reservations.room.number, formattedStartDateString, formattedEndDateString];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}


//MARK: searchBar searching logic
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    isSearching = YES;
    if ([searchText isEqualToString:@""]) {
        isSearching = NO;
        self.filteredReservation = nil;
    } else {
        self.filteredReservation = [[NSMutableArray alloc]init];
        self.filteredReservation = [[self.reservationDetails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"guest.lastName CONTAINS[c] %@ OR guest.firstName CONTAINS[c] %@", searchBar.text, searchBar.text]] mutableCopy];
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    self.filteredReservation = nil;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
    isSearching = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text != nil) {
        self.filteredReservation = [[NSMutableArray alloc]init];
        self.filteredReservation = [[self.reservationDetails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"guest.lastName CONTAINS[c] %@ OR guest.firstName CONTAINS[c] %@", searchBar.text, searchBar.text]] mutableCopy];
    }
    isSearching = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    isSearching = NO;
}

@end
