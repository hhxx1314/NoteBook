//
//  WeeklyListTableViewController.h
//  
//
//  Created by dz on 16/1/9.
//
//

#import <UIKit/UIKit.h>
#import "WeeklyListTableViewModel.h"
#import "FeedViewController.h"
@interface WeeklyListTableViewController : FeedViewController

@property (nonatomic,strong) WeeklyListTableViewModel *viewModel;

@end
