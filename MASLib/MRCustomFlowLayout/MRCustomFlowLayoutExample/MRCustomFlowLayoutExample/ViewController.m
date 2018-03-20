//
//  ViewController.m
//  CollectionTest
//
//  Created by Federico Gasperini on 14/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "ViewController.h"
#import "MRGridLayout.h"
#import "MRCalendarFlowLayout.h"
#import "MRInfiniteGridLayout.h"
#import "MRGreedyPartitionLayout.h"

@interface ViewController () <MRCalendarDelegate, MRGreedyPartitionLayoutDelegate>

@property (weak, nonatomic) IBOutlet MRCalendarFlowLayout* calendarLayout;
@property (weak, nonatomic) IBOutlet MRGridLayout* gridLayout;
@property (weak, nonatomic) IBOutlet MRInfiniteGridLayout* infiniteLayout;
@property (weak, nonatomic) IBOutlet MRGreedyPartitionLayout* bestPackLayout;
@property (weak, nonatomic) IBOutlet UILabel* checkValue;

@end

@implementation ViewController

-(void)viewDidLoad
{
   free(NULL);
   [super viewDidLoad];
   
//   self.infiniteLayout.collectionView.contentInset =
//   UIEdgeInsetsMake(0, 50, 0, 50);
   
//   self.calendarLayout.collectionView.contentInset =
//   UIEdgeInsetsMake(0, 50, 0, 50);

   if (self.gridLayout.cols > 1)
      self.gridLayout.collectionView.contentInset =
      UIEdgeInsetsMake(0, 50, 0, 50);

   if (self.gridLayout.cols > 1)
      self.gridLayout.data = [@"Because there is no object instance you can ask if it responds to a message selector, Because there is no object instance you can ask if it responds to a message selector, and you already Because there is no object instance you can ask if it responds to a mess and you sage selector, and you already know" componentsSeparatedByString:@" "];
   else
      self.gridLayout.data = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7"];
   self.checkValue.text = @"";
   self.infiniteLayout.data = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7"];
   self.bestPackLayout.data = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19"];
   
   srand48(time(0));
}

-(void)setData:(id)s
{
   
}

-(void)calendarDidSelectDate:(nonnull NSDate*)date
{
   self.checkValue.text = [date description];
}

-(void)calendarDidShowMonth:(NSInteger)m ofYear:(NSInteger)y
{
   self.checkValue.text = [NSString stringWithFormat:@"%@/%@", @(m), @(y)];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   self.checkValue.text = [self.gridLayout itemAtIndexPath:indexPath];
}

-(CGFloat)collectionViewLayout:(MRGreedyPartitionLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
   switch (indexPath.item)
   {
      case 0:
         return 100;
         break;
         
      case 1:
         return 60;
         break;
         
      case 2:
      case 3:
      case 4:
         return 80;
         break;
         
      default:
         return 60 * (2 / (2 - indexPath.item % 2));//MAX(60, 230 * drand48());
         break;
   }
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
   if (collectionView.collectionViewLayout == self.bestPackLayout)
   {
      [cell.contentView setBackgroundColor:[UIColor greenColor]];
      cell.contentView.layer.cornerRadius = 8;
      cell.contentView.clipsToBounds = YES;
      [[cell.contentView subviews].firstObject setText:self.bestPackLayout.data[indexPath.item]];
   }
   if (collectionView.collectionViewLayout == self.gridLayout)
   {
      cell.contentView.backgroundColor = indexPath.section % 2 ? [UIColor redColor] : [UIColor yellowColor];
   }
}


@end
