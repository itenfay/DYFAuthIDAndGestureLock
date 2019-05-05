//
//  DYFGestureTouchIDSettingController.m
//
//  Created by dyf on 2017/8/2.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFGestureTouchIDSettingController.h"
#import "DYFGestureTouchIDSettingCell.h"
#import "DYFSecurityHelper.h"
#import "DYFGestureSetController.h"
#import "DYFLoadingObject.h"

#define DYFWeakObject(o) __weak __typeof(self) weak##_##o = o;

@interface DYFGestureTouchIDSettingController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *gtsTableView;
@property (nonatomic, assign) BOOL isOpenPasscodeLock;

@end

@implementation DYFGestureTouchIDSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手势、指纹设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self validatePasscodeLockOpenStatus];
    [self setNavBarButtonItems];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.gtsTableView reloadData];
}

- (void)setNavBarButtonItems {
    UIButton *leftBarButton = [[UIButton alloc] init];
    leftBarButton.frame = CGRectMake(0, 0, 60, 22);
    [leftBarButton setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    leftBarButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [leftBarButton setTitle:@" 返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:31/255.0 green:144/255.0 blue:230/255.0 alpha:1.0] forState:UIControlStateNormal];
    [leftBarButton setShowsTouchWhenHighlighted:YES];
    [leftBarButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validatePasscodeLockOpenStatus {
    BOOL isTouchIDOpen = [DYFSecurityHelper touchIDOpenStatus];
    BOOL isGestureOpne = [DYFSecurityHelper gestureOpenStatus];
    self.isOpenPasscodeLock = (isTouchIDOpen || isGestureOpne);
    return self.isOpenPasscodeLock;
}

- (void)initTableView {
    _gtsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _gtsTableView.frame = self.view.bounds;
    _gtsTableView.delegate = self;
    _gtsTableView.dataSource = self;
    _gtsTableView.bounces = NO;
    _gtsTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_gtsTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.isOpenPasscodeLock ? 1 : 0;
    } else {
        return self.isOpenPasscodeLock ? 1 : 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"GTSettingCell";
    DYFGestureTouchIDSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DYFGestureTouchIDSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mTextLabel.text = @"开启密码锁定";
        cell.mSwitch.on = self.isOpenPasscodeLock;
        [cell.mSwitch addTarget:self action:@selector(openPasscodeLock:) forControlEvents:UIControlEventValueChanged];
    } else if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mTextLabel.text = @"开启Touch ID指纹解锁";
        cell.mSwitch.on = [DYFSecurityHelper touchIDOpenStatus];
        [cell.mSwitch addTarget:self action:@selector(openTouchID:) forControlEvents:UIControlEventValueChanged];
    } else {
        NSString *gestureCode = [DYFSecurityHelper gainGestureCodeKey];
        cell.mTextLabel.text = gestureCode.length > 0 ? @"重置手势密码" : @"设置手势密码";
        cell.mSwitch.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)openPasscodeLock:(UISwitch *)sender {
    self.isOpenPasscodeLock = sender.on;
    [self.gtsTableView reloadData];
    if (!sender.on) {
        [self gestureOpen:NO];
        [self touchIDOpen:NO];
    }
}

- (void)openTouchID:(UISwitch *)sender {
    if (sender.on) {
        DYFWeakObject(self)
        [[DYFSecurityHelper sharedInstance] openTouchID:^(BOOL success, BOOL inputPassword, NSString *message) {
            if (success) {
                [weak_self showPrompt:message isOK:YES];
                [weak_self touchIDOpen:YES];
            } else {
                [weak_self showPrompt:message isOK:NO];
                [weak_self.gtsTableView reloadData];
            }
        }];
    } else {
        [self touchIDOpen:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        DYFGestureSetController *gsController = [[DYFGestureSetController alloc] init];
        gsController.gestureSetType = DYFGestureSetTypeSetting;
        DYFWeakObject(self)
        [gsController gestureSetComplete:^(BOOL success) {
            if (success) {
                [weak_self showPrompt:@"设置手势密码成功" isOK:YES];
                [weak_self gestureOpen:YES];
            }
        }];
        [self.navigationController pushViewController:gsController animated:YES];
    }
}

- (void)touchIDOpen:(BOOL)open {
    [DYFSecurityHelper touchIDOpen:open];
}

- (void)gestureOpen:(BOOL)open {
    [DYFSecurityHelper openGesture:open];
}

- (void)showPrompt:(NSString *)text isOK:(BOOL)isOK {
    if (isOK) {
        [DYFLoadingObject showOK:text];
    } else {
        [DYFLoadingObject showError:text];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
