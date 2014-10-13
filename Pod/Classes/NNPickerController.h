//
//  NNPickerController.h
//
//  Created by numanuma08 on 2014/10/13.
//
//

#import <UIKit/UIKit.h>
@class  NNPickerController;
typedef NSInteger (^NNPickerControllerNumberOfSection)();
typedef NSInteger (^NNPickerControllerNumberOfRowInSection)(NSInteger section);
typedef UITableViewCell* (^NNPickerControllerCellForRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
typedef void (^NNPickerControllerDidFinishPickingRowAtIndexpath)(NNPickerController *picker, UITableView *tableView, NSIndexPath *indexPsath);
typedef void (^NNPickerControllerDidCancel)(NNPickerController *picker);

@interface NNPickerController : UIViewController
@property (nonatomic, copy) NNPickerControllerDidFinishPickingRowAtIndexpath finishPickingHandler;
@property (nonatomic, copy) NNPickerControllerDidCancel cancelHandler;
- (void)setNumberOfSection:(NNPickerControllerNumberOfSection)numberOfSectionHandler withNumberOfRow:(NNPickerControllerNumberOfRowInSection)numberOfRowHandler withCellForRowAtIndexPath:(NNPickerControllerCellForRowAtIndexPath)cellForRowAtIndexPathHandler;
- (void)showPickerControllerForViewController;
- (void)dismissPickerController;
@end