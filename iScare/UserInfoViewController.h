//
//  UserInfoViewController.h
//  iScare
//
//  Created by Cina on 11/19/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import "iScareModelViewController.h"

@interface UserInfoViewController : iScareModelViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (nonatomic, retain) IBOutlet UITableView *mTableView;

@end
