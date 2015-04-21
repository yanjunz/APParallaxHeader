//
//  BrowserViewController.m
//  APParallaxHeaderDemo
//
//  Created by yjzhuang on 21/4/15.
//  Copyright (c) 2015 Apping AB. All rights reserved.
//

#import "BrowserViewController.h"
#import "UIScrollView+APParallaxHeader.h"

@interface BrowserViewController ()<UITableViewDataSource, UITableViewDelegate, APParallaxViewDelegate> {
    CGFloat _lastOffsetY;
}

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navView = ({
        UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        navView.backgroundColor = [UIColor blueColor];
        navView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:navView];
        navView;
    });
    
    CGFloat top = CGRectGetMaxY(self.navView.frame);
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, self.view.frame.size.width, self.view.frame.size.height - top)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    
    self.headerView = ({
        UIView *headerView = [UIView new];
        headerView.backgroundColor = [UIColor redColor];
        headerView;
    });
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ParallaxImage.jpg"]];
    [imageView setFrame:CGRectMake(0, 0, 320, 160)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.tableView addParallaxWithView:imageView andHeight:160];
    self.tableView.parallaxView.delegate = self;
    _lastOffsetY = -160;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row %i", indexPath.row+1];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    NSLog(@"scrollViewDidScroll %f, %f", scrollView.contentInset.top, scrollView.contentOffset.y);
    CGFloat y = scrollView.contentOffset.y;
    if (y < 0) {
        if (_lastOffsetY >= 0) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect f = self.navView.frame;
                f.size.height = 150;
                self.navView.frame = f;
                f = self.tableView.frame;
                f.size.height = self.view.frame.size.height - 150;
                f.origin.y = 150;
                self.tableView.frame = f;
            }];
            
        }
        if (y > -160) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else {
            scrollView.contentInset = UIEdgeInsetsMake(160, 0, 0, 0);
        }
    }
    else {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (y > 10) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect f = self.navView.frame;
                f.size.height = 100;
                self.navView.frame = f;
                f = self.tableView.frame;
                f.size.height = self.view.frame.size.height - 100;
                f.origin.y = 100;
                self.tableView.frame = f;
            }];
            
        }
    }
    _lastOffsetY = y;
}

#pragma mark - APParallaxViewDelegate

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview before its frame changes
//    NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview after its frame changed
//    NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));
}


@end
