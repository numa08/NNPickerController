//
//  NNViewController.m
//  NNPickerController
//
//  Created by numa08 on 10/13/2014.
//  Copyright (c) 2014 numa08. All rights reserved.
//

#import "NNViewController.h"

#import <NNPickerController/NNPickerController.h>

@interface NNViewController ()
@property (weak, nonatomic) IBOutlet UILabel *elementLabel;
@end

@implementation NNViewController

- (IBAction)didClickPick:(id)sender
{
    
    NSArray *girls = @[@"でじこ", @"うさだ", @"ぷちこ", @"ぴよこ", @"ミケ", @"リンナ", @"あかり", @"ゲマ", @"ほっけみりん", @"まじんがっぱ"];
    NNPickerController *picker = [[NNPickerController alloc] init];
    picker.cancelHandler = ^(NNPickerController *picker) {
        [picker dismissPickerController];
    };
    picker.finishPickingHandler = ^(NNPickerController *picker, UITableView *tableView,NSIndexPath *indexPath){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.elementLabel.text = girls[indexPath.row];
        [picker dismissPickerController];
    };
    
    [picker setNumberOfSection:^NSInteger{
        return 1;
    } withNumberOfRow:^NSInteger(NSInteger section) {
        return girls.count;
    } withCellForRowAtIndexPath:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"cell%@/%@", @(indexPath.row),@(indexPath.section)];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell != nil) {
            return cell;
        }
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = girls[indexPath.row];
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        return cell;
    }];
    [picker showPickerControllerForViewController];
}

@end
