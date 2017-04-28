//
//  HotelServices.m
//  CoreDataHotel
//
//  Created by Kent Rogers on 4/28/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

@import Crashlytics;

#import "HotelServices.h"
#import "AppDelegate.h"

#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"

#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"

@implementation HotelServices

+ (NSFetchedResultsController *)availableRoomsWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate{
    NSFetchedResultsController *rooms;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
    request.predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", endDate, startDate];
    
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
    
    rooms = [[NSFetchedResultsController alloc]initWithFetchRequest:roomRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"hotel.name" cacheName:nil];
    
    [rooms performFetch:&availableRoomError];
    
    return rooms;
}

+ (void)saveNewReservationInRoom:(Room *)room
                       startDate:(NSDate *)startDate
                         endDate:(NSDate *)endDate
                       firstName:(NSString *)firstName
                        lastName:(NSString *)lastName
                           email:(NSString *)email
         andNavigationController:(UINavigationController *)navigation{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    if (firstName != nil && lastName != nil) {
        
        Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:context];
        
        reservation.startDate = startDate;
        reservation.endDate = endDate;
        reservation.room = room;
        
        //room.reservation = [room.reservation setByAddingObject:reservation];
        
        reservation.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:context];
        
        reservation.guest.firstName = firstName;
        reservation.guest.lastName = lastName;
        reservation.guest.email = email;
    } else {
        return NSLog(@"Name field was nil");
    }
    
    NSError *saveError;
    [context save:&saveError];
    
    if (saveError) {
        NSLog(@"Save error is %@", saveError);
        NSDictionary *attributeDictionary = @{@"Save Error" : saveError.localizedDescription};
        [Answers logCustomEventWithName:@"Save Reservation Error" customAttributes:attributeDictionary];
    } else {
        NSLog(@"Save reservation successful!");
        [Answers logCustomEventWithName:@"Saved New Reservation" customAttributes:nil];
        [navigation popToRootViewControllerAnimated:YES];
    }
    
    
}

@end
