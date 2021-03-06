//
//  WeeklyListTableViewModel.m
//  NoteBook
//
//  Created by Mac on 16/5/7.
//  Copyright © 2016年 dz. All rights reserved.
//

#import "WeeklyListTableViewModel.h"
#import "WeeklyListCellViewModel.h"
#import "FeedViewModel+MultipleSections.h"
#import "FeedViewController+Refresh.h"
#import "DDLog.h"

@interface WeeklyListTableViewModel ()

@property (nonatomic,strong) RACCommand *getweeklyListCommand;
@property (nonatomic,strong) SWGWeeklyListResponses *weeklyListResponses;


@end

@implementation WeeklyListTableViewModel

+ (instancetype) viewModel {
    return [[self alloc] initWithSectionCount:1];
}
- (instancetype) initWithSectionCount:(NSInteger) count {
    self = [super initWithSectionCount:count];
    if (self) {
        @weakify(self)
        _getweeklyListCommand = [NoteBookWeeklyService.service weeklyListCommandEnable:nil];
        [_getweeklyListCommand.responses subscribeNext:^(SWGWeeklyListResponses *response) {
            @strongify(self)
            [self updateFromGetWeeklyListResponse:response];
        }];
        [_getweeklyListCommand.errors subscribeNext:^(NSError *error) {
//            DDLogError(@"Error while get resume browse history:%@", error);
        }];
        
        self.headerExecuting = _getweeklyListCommand.executing;
        self.hudExecutingSignals = @[_getweeklyListCommand.executing];
        
        self.placeHolderText = @"暂无博客";
        [[RACSignal combineLatest:@[RACObserve(self, weeklyListResponses)]] subscribeNext:^(id _) {
            @strongify(self)
            NSInteger requestCount = ((self.weeklyListResponses.data!=nil)?[self.weeklyListResponses.data count]:0);
            self.showPlaceHolderView = (requestCount == 0);
        }];
        
    }
    return self;
}

- (void) loadAtHead {
    SWGWeeklyListRequest *request = [[SWGWeeklyListRequest alloc] init];
    request.uid = UserModel.currentUser.uid;
    [_getweeklyListCommand execute:request];
}

- (void)updateFromGetWeeklyListResponse:(SWGWeeklyListResponses*)response {
    self.weeklyListResponses = response;
    [self resetModelSections:@[[self WeeklyListModels]]];
}

- (NSMutableArray*)WeeklyListModels {
    NSMutableArray *modelAry = [NSMutableArray array];
    
    [modelAry addObjectsFromArray:_weeklyListResponses.data];
    
    return modelAry;
}



- (void) registerCellViewModelClasses {
    [super registerCellViewModelClasses];
    
    [self registerCellViewModelClass:WeeklyListCellViewModel.class forModelClass:SWGWeekly.class];
}

@end
