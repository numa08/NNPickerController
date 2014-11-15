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
@property (nonatomic, retain) UIWindow *targetWindow;
@property (retain, nonatomic) IBOutlet UIView *background;
@property (retain, nonatomic) IBOutlet UIView *container;
- (IBAction)didClickCancel:(id)sender;
@end

@implementation NNPickerController
- (id)init
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"NNPickerController" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"NNPickerController" bundle:bundle];
    self = [storyBoard instantiateViewControllerWithIdentifier:@"NNPickerController"];
    return self;
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
    
    CGFloat goalAlpha = self.background.alpha;
    CGFloat startAlpha = 0.0f;
    self.background.alpha = startAlpha;
    
    [UIView transitionWithView:self.targetWindow duration:0.2f options:UIViewAnimationOptionTransitionNone|UIViewAnimationOptionCurveEaseOut animations:^{
        self.background.alpha = goalAlpha;
    } completion:nil];
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionTransitionNone|UIViewAnimationOptionCurveEaseOut animations:^{
        self.container.frame = goalFrame;
    } completion:nil];

}

- (void)dismissPickerController
{
    CGRect startFrame = self.container.frame;
    CGRect goalFrame = CGRectMake(0,  CGRectGetMaxY(self.view.frame), CGRectGetWidth(startFrame), CGRectGetHeight(startFrame));
    
    
    CGFloat goalAlpha = 0.0f;
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionTransitionNone|UIViewAnimationOptionCurveEaseIn animations:^{
        self.container.frame = goalFrame;
    } completion:nil];
    [UIView transitionWithView:self.targetWindow duration:0.2f options:UIViewAnimationOptionTransitionNone|UIViewAnimationOptionCurveEaseIn animations:^{
        self.background.alpha = goalAlpha;
    } completion:^(BOOL finished) {
        [self.targetWindow.rootViewController.view removeFromSuperview];
        self.targetWindow.rootViewController = nil;
        self.targetWindow = nil;
        
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

# pragma mark - ViewController rotation

// ios7 eariler
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat newWidth;
    CGFloat newHeight;
    CGFloat newYPosition;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        newWidth = CGRectGetWidth(self.view.frame);
        newHeight = CGRectGetHeight(self.view.frame) / 2;
        newYPosition = newHeight;
    } else {
        newWidth = CGRectGetHeight(self.view.frame);
        newHeight = CGRectGetWidth(self.view.frame) / 2;
        newYPosition = newHeight;
    }
}


// ios8 grater
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.container.frame = CGRectMake(0, size.height / 2, size.width, size.height / 2);
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}

# pragma mark - Private Methods
- (IBAction)didClickCancel:(id)sender;
{
    if (self.cancelHandler == NULL) {
        return;
    }
    self.cancelHandler(self);
}
@end
