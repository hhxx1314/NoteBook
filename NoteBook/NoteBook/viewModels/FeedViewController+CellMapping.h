//
//  FeedViewController+CellMapping.h
//  NoteBook
//
//  Created by Mac on 16/5/4.
//  Copyright © 2016年 dz. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController (CellMapping)
+ (Class) getDefaultRegisteredCellClassForViewModelClass:(Class)cellVieModelClass;
@end
