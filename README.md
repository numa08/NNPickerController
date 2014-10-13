# NNPickerController

<!-- [![CI Status](http://img.shields.io/travis/numa08/NNPickerController.svg?style=flat)](https://travis-ci.org/numa08/NNPickerController)
[![Version](https://img.shields.io/cocoapods/v/NNPickerController.svg?style=flat)](http://cocoadocs.org/docsets/NNPickerController)
[![License](https://img.shields.io/cocoapods/l/NNPickerController.svg?style=flat)](http://cocoadocs.org/docsets/NNPickerController)
[![Platform](https://img.shields.io/cocoapods/p/NNPickerController.svg?style=flat)](http://cocoadocs.org/docsets/NNPickerController) -->


NNPickerController is library for UI. Application user can picke one of element by this UI.

![](http://i.gyazo.com/e5c627ea1a5e218e3e60c20af547451a.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Implementation

On your UIViewController, you write that code,


```obj-c

NSArray *elementsArray ... // Tha element will be picked by PickerController
// Allocate and Initialize

NNPickerController *picker = [[NNPickerController alloc] init];

// Picker's cancel button was clicked handler;
picker.cancelHandler = ^(NNPickerController *picker) {
    [picker dismissPickerController];
};

// Element was picked handler
picker.finishPickingHandler = ^(NNPickerController *picker, UITableView *tableView,NSIndexPath *indexPath){
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.elementLabel.text = elementsArray[indexPath.row];
    [picker dismissPickerController];
};

// Configuration for Picker Controller
[picker setNumberOfSection:^NSInteger{
    return 1;
} withNumberOfRow:^NSInteger(NSInteger section) {
    return elementsArray.count;
} withCellForRowAtIndexPath:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%@/%@", @(indexPath.row),@(indexPath.section)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell != nil) {
        return cell;
    }
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.textLabel.text = elementsArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}];

// show picker controller
[picker showPickerControllerForViewController];
```

## Installation

NNPickerController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "NNPickerController"

## Author

numa08, n511287@gmail.com

## License

NNPickerController is available under the MIT license. See the LICENSE file for more info.

