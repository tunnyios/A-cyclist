//
//  ACHotRoutesCitiesController.h
//  A-cyclist
//
//  Created by tunny on 15/8/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACHotRoutesCitiesController;
@protocol ACHotRoutesCityDelegate <NSObject>

- (void)hotRoutesCityClick:(ACHotRoutesCitiesController *)citiesController cityName:(NSString *)cityName;

@end

@interface ACHotRoutesCitiesController : UITableViewController

@property (nonatomic, weak) id<ACHotRoutesCityDelegate> delegate;

@end
