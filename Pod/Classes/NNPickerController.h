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

/** Picke One of element. */
@interface NNPickerController : UIViewController
/** The block will be called when, user picke one of element. */
@property (nonatomic, copy) NNPickerControllerDidFinishPickingRowAtIndexpath finishPickingHandler;

/** The block will be called when, user clicke cancel button. */
@property (nonatomic, copy) NNPickerControllerDidCancel cancelHandler;

/** Set datasource. There handler are similar to UITableViewDataSource.
 @ param numberOfSectionHandler This block will be called , when UITableViewDataSource numberOfSectionsInTableView: be called.
 @ param numberOfRowHandler This block will be called, when UITableViewDataSource tableView:numberOfRowsInSection: be called.
 @ param cellForRowAtIndexPathHandler This block will be called, when UITableViewDataSource tableView:cellForRowAtIndexPath:
*/
- (void)setNumberOfSection:(NNPickerControllerNumberOfSection)numberOfSectionHandler withNumberOfRow:(NNPickerControllerNumberOfRowInSection)numberOfRowHandler withCellForRowAtIndexPath:(NNPickerControllerCellForRowAtIndexPath)cellForRowAtIndexPathHandler;

/** Show NNPickerController over your UIViewController*/
- (void)showPickerControllerForViewController;

/** Dismiss NNPickerController.*/
- (void)dismissPickerController;
@end