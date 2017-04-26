//
//  BookViewController.h
//  CoreDataHotel
//
//  Created by Kent Rogers on 4/26/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room+CoreDataClass.h"

@interface BookViewController : UIViewController

@property(strong, nonatomic)NSDate *startDate;
@property(strong, nonatomic)NSDate *endDate;
@property(strong, nonatomic)Room *selectedRoom;

@end
