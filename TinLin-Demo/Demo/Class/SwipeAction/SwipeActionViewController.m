//
//  SwipeActionViewController.m
//  Demo
//
//  Created by Mac on 2018/12/14.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "SwipeActionViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface SwipeActionViewController ()

@end

@implementation SwipeActionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shouldPullDownToRefresh = YES;
        self.shouldPullUpToLoadMore = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)configure {
    [super configure];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView reuseIdentifier:BaseTableViewCellID];
    NSInteger row = [self.dataSource[indexPath.row] integerValue];
    cell.textLabel.text = [NSString stringWithFormat:@"Row:%zd",row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    /// 左边
    @weakify(self);
    UIContextualAction *topAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"置顶" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        @strongify(self);
        id obj = self.dataSource[indexPath.row];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.dataSource insertObject:obj atIndex:0];
        [self.tableView beginUpdates];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.tableView endUpdates];
        completionHandler(YES);
    }];
    UIContextualAction *addAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"添加" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        @strongify(self);
        [self.dataSource insertObject:@(self.dataSource.count) atIndex:indexPath.row+1];
        [self.tableView beginUpdates];
        [self.tableView insertRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        completionHandler(YES);
    }];
    addAction.backgroundColor = [UIColor greenColor];
    
    return [UISwipeActionsConfiguration configurationWithActions:@[topAction,addAction]];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    /// 右边
    @weakify(self);
    UIContextualAction *noReadAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"标为未读" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        @strongify(self);
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor redColor];
        completionHandler(YES);
    }];
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        @strongify(self);
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        completionHandler(YES);
    }];
    return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction,noReadAction]];
}

#pragma mark - Refresh

- (void)tableViewDidTriggerHeaderRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12]];
        [self reloadData];
        [self.tableView.mj_header endRefreshing];
        if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
            [self.tableView.mj_footer resetNoMoreData];
        }
    });
}

- (void)tableViewDidTriggerFooterRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dataSource addObjectsFromArray:@[@11,@23,@11,@23]];
        [self reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (self.dataSource.count > 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    });
}

@end
