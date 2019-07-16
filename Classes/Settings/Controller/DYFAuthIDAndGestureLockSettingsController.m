//
//  DYFAuthIDAndGestureLockSettingsController.m
//
//  Created by dyf on 2017/8/2.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFAuthIDAndGestureLockSettingsController.h"
#import "DYFAuthIDAndGestureLockSettingsCell.h"
#import "DYFSecurityHelper.h"
#import "DYFGestureSettingsController.h"
#import "UIViewController+Message.h"

@interface DYFAuthIDAndGestureLockSettingsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, assign) BOOL isOwnedLock;

@end

@implementation DYFAuthIDAndGestureLockSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYFSecurityHelper.faceIDAvailable ? @"手势、面容设置" : @"手势、指纹设置";
    self.view.backgroundColor = DYFColorFromRGB(243.f, 243.f, 243.f, 1.f);
    
    [self validateAppLockStatus];
    [self configureNavigationBar];
    
    [self.view addSubview:self.m_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.m_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)configureNavigationBar {
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    //backButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    //[backButton setTitle:@"返回" forState:UIControlStateNormal];
    //[backButton setTitleColor:[UIColor colorWithRed:31/255.0 green:144/255.0 blue:230/255.0 alpha:1.0] forState:UIControlStateNormal];
    [backButton setShowsTouchWhenHighlighted:YES];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(3, -10, 3, 30);
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -20;
    UIBarButtonItem *baclItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[spaceItem, baclItem];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateAppLockStatus {
    BOOL isAuthIDOpen = [DYFSecurityHelper authIDOpen];
    BOOL isGestureOpen = [DYFSecurityHelper gestureCodeOpen];
    return self.isOwnedLock = (isAuthIDOpen || isGestureOpen);
}

- (UITableView *)m_tableView {
    if (!_m_tableView) {
        _m_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _m_tableView.frame = self.view.bounds;
        _m_tableView.delegate = self;
        _m_tableView.dataSource = self;
        _m_tableView.bounces = YES;
        _m_tableView.backgroundColor = [UIColor clearColor];
    }
    return _m_tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.isOwnedLock ? 1 : 0;
    } else {
        return self.isOwnedLock ? 1 : 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AGLSettingsCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AGLSettingsCell";
    
    DYFAuthIDAndGestureLockSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DYFAuthIDAndGestureLockSettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setNeedsLayout];
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.m_textLabel.text = @"开启密码锁定";
        cell.m_switch.on = self.isOwnedLock;
        [cell.m_switch addTarget:self action:@selector(openPasscodeLock:) forControlEvents:UIControlEventValueChanged];
    } else if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.m_textLabel.text = DYFSecurityHelper.faceIDAvailable ? @"开启面容ID解锁" : @"开启Touch ID指纹解锁";
        cell.m_switch.on = [DYFSecurityHelper authIDOpen];
        [cell.m_switch addTarget:self action:@selector(openAuthID:) forControlEvents:UIControlEventValueChanged];
    } else {
        NSString *gestureCode = [DYFSecurityHelper getGestureCode];
        cell.m_textLabel.text = gestureCode.length > 0 ? @"重置手势密码" : @"设置手势密码";
        cell.m_switch.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)openPasscodeLock:(UISwitch *)sender {
    self.isOwnedLock = sender.on;
    
    [self.m_tableView reloadData];
    
    if (!sender.on) {
        [DYFSecurityHelper setGestureCodeOpen:NO];
        [DYFSecurityHelper setAuthIDOpen:NO];
    }
}

- (void)openAuthID:(UISwitch *)sender {
    if (sender.on) {
        @DYFWeakObject(self)
        [DYFSecurityHelper.sharedHelper evaluateAuthID:^(BOOL success, BOOL inputPassword, NSString *message) {
            if (success) {
                [weak_self yf_showMessage:message];
                [DYFSecurityHelper setAuthIDOpen:YES];
            } else {
                [weak_self yf_showMessage:message];
                [weak_self.m_tableView reloadData];
            }
        }];
    } else {
        [DYFSecurityHelper setAuthIDOpen:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        DYFGestureSettingsController *vc = [[DYFGestureSettingsController alloc] init];
        vc.gestureSettingsType = DYFGestureSettingsTypeSet;
        
        [vc gestureSettingsWithCompletion:^(BOOL successful) {
            if (successful) {
                [DYFSecurityHelper setGestureCodeOpen:YES];
            }
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
