//
//  NNPickerController.m
//
//  Created by numanuma08 on 2014/10/13.
//
//

#import "NNPickerController.h"

@interface NNPickerController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NNPickerControllerNumberOfSection numberOfSectionHandler;
@property (nonatomic, copy) NNPickerControllerNumberOfRowInSection numberOfRowInSectionHandler;
@property (nonatomic, copy) NNPickerControllerCellForRowAtIndexPath cellForRowAtIndexPathHandler;
@property (nonatomic, retain) UIView *container;
@property (nonatomic, retain) UIWindow *targetWindow;
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
    UIToolbar *navigationBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), navigationBarHeight)];
    navigationBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didClickCancel:)];
    navigationBar.items = @[flexibleSpace, cancel];
    
    UITableView *contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBar.frame), CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame) / 2)- CGRectGetHeight(navigationBar.frame)) style:UITableViewStylePlain];
    contentView.delegate = self;
    contentView.dataSource = self;
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(navigationBar.frame), CGRectGetHeight(self.view.frame) / 2, CGRectGetWidth(navigationBar.frame), CGRectGetHeight(navigationBar.frame) + CGRectGetHeight(contentView.frame))];
    self.container.alpha = 1.0f;
    [self.container addSubview:navigationBar];
    [self.container addSubview:contentView];
    [self.view addSubview:self.container];
}

- (void)setNumberOfSection:(NNPickerControllerNumberOfSection)numberOfSectionHandler withNumberOfRow:(NNPickerControllerNumberOfRowInSection)numberOfRowHandler withCellForRowAtIndexPath:(NNPickerControllerCellForRowAtIndexPath)cellForRowAtIndexPathHandler
{
    self.numberOfSectionHandler = numberOfSectionHandler;
    self.numberOfRowInSectionHandler = numberOfRowHandler;
    self.cellForRowAtIndexPathHandler = cellForRowAtIndexPathHandler;
}

- (void)showPickerControllerForViewController
{
    self.targetWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.targetWindow.alpha = 1.0f;
    self.targetWindow.backgroundColor = [UIColor clearColor];
    self.targetWindow.rootViewController = self;
    self.targetWindow.windowLevel = UIWindowLevelAlert + 1000;
    [self.targetWindow makeKeyAndVisible];
 
    CGRect goalFrame = self.container.frame;
    CGRect startFrame = CGRectMake(0, CGRectGetMaxY(goalFrame), CGRectGetWidth(goalFrame), CGRectGetHeight(goalFrame));
    self.container.frame = startFrame;
    
    [UIView transitionWithView:self.targetWindow duration:0.3f options:UIViewAnimationOptionTransitionNone|UIViewAnimationOptionCurveEaseOut animations:^{
        self.container.frame = goalFrame;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissPickerController
{
    CGRect startFrame = self.container.frame;
    CGRect goalFrame = CGRectMake(0,  CGRectGetMaxY(self.view.frame), CGRectGetWidth(startFrame), CGRectGetHeight(startFrame));
    
    [UIView transitionWithView:self.targetWindow duration:0.3f options:UIViewAnimationOptionTransitionNone|UIViewAnimationOptionCurveEaseIn animations:^{
        self.container.frame = goalFrame;
    } completion:^(BOOL finished) {
        [self.targetWindow.rootViewController.view removeFromSuperview];
        self.targetWindow.rootViewController = nil;
        
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
