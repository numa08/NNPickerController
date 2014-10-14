//
//  NNPickerController.m
//
//  Created by numanuma08 on 2014/10/13.
//
//

#import "NNPickerController.h"

#import <objc/runtime.h>

static const char kASKey_Window;

@interface NNPickerController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NNPickerControllerNumberOfSection numberOfSectionHandler;
@property (nonatomic, copy) NNPickerControllerNumberOfRowInSection numberOfRowInSectionHandler;
@property (nonatomic, copy) NNPickerControllerCellForRowAtIndexPath cellForRowAtIndexPathHandler;
@property (nonatomic, retain) UITableView *contentView;
@property (nonatomic, retain) UIToolbar *navigationBar;
- (void)didClickCancel:(id)sender;
@end

@implementation NNPickerController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *background = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    background.alpha = 0.6f;
    background.backgroundColor = [UIColor grayColor];
    [self.view addSubview:background];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat navigationBarHeight = 0.0f;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        navigationBarHeight = 44.0f;
    } else if (UIInterfaceOrientationIsLandscape(orientation)) {
        navigationBarHeight = 32.0f;
    }
    self.navigationBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) / 2, CGRectGetWidth(self.view.frame), navigationBarHeight)];
    self.navigationBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didClickCancel:)];
    self.navigationBar.items = @[flexibleSpace, cancel];
    [self.view addSubview:self.navigationBar];
    
    self.contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame) / 2)- CGRectGetHeight(self.navigationBar.frame)) style:UITableViewStylePlain];
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    [self.view addSubview:self.contentView];
}

- (void)setNumberOfSection:(NNPickerControllerNumberOfSection)numberOfSectionHandler withNumberOfRow:(NNPickerControllerNumberOfRowInSection)numberOfRowHandler withCellForRowAtIndexPath:(NNPickerControllerCellForRowAtIndexPath)cellForRowAtIndexPathHandler
{
    self.numberOfSectionHandler = numberOfSectionHandler;
    self.numberOfRowInSectionHandler = numberOfRowHandler;
    self.cellForRowAtIndexPathHandler = cellForRowAtIndexPathHandler;
}

- (void)showPickerControllerForViewController
{
    CGRect goalFrame = [UIScreen mainScreen].bounds;
    CGRect startFrame = CGRectMake(0, CGRectGetHeight(goalFrame), CGRectGetWidth(goalFrame), CGRectGetHeight(goalFrame));
    
    UIWindow *targetWindow = [[UIWindow alloc] initWithFrame:startFrame];
    targetWindow.alpha = 1.0f;
    targetWindow.backgroundColor = [UIColor clearColor];
    targetWindow.rootViewController = self;
    targetWindow.windowLevel = UIWindowLevelAlert + 1000;
    [targetWindow makeKeyAndVisible];
    
    objc_setAssociatedObject([UIApplication sharedApplication], &kASKey_Window, targetWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [UIView transitionWithView:targetWindow duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
        targetWindow.frame = goalFrame;
        targetWindow.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissPickerController
{
    UIWindow *targetWindow = objc_getAssociatedObject([UIApplication sharedApplication], &kASKey_Window);
    CGRect startFrame = targetWindow.frame;
    CGRect goalFrame = CGRectMake(0, CGRectGetHeight(startFrame), CGRectGetWidth(startFrame), CGRectGetHeight(startFrame));
    [UIView transitionWithView:targetWindow duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
        targetWindow.frame = goalFrame;
    } completion:^(BOOL finished) {
        [targetWindow.rootViewController.view removeFromSuperview];
        targetWindow.rootViewController = nil;
        
        objc_setAssociatedObject([UIApplication sharedApplication], &kASKey_Window, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        UIWindow *nextWindow = [[UIApplication sharedApplication].delegate window];
        [nextWindow makeKeyAndVisible];
    }];
}

# pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.numberOfRowInSectionHandler == NULL) {
        return 0;
    }
    return self.numberOfRowInSectionHandler(section);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.numberOfSectionHandler == NULL) {
        return 0;
    }
    return self.numberOfSectionHandler();
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellForRowAtIndexPathHandler == NULL) {
        return [[UITableViewCell alloc] init];
    }
    return self.cellForRowAtIndexPathHandler(tableView, indexPath);
}

# pragma mark Tableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finishPickingHandler == NULL) {
        return;
    }
    self.finishPickingHandler(self, tableView, indexPath);
}

# pragma mark - Private Methods
- (void)didClickCancel:(id)sender
{
    if (self.cancelHandler == NULL) {
        return;
    }
    self.cancelHandler(self);
}

@end
