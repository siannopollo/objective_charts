//
//  GoogleChartAxis.m
//  workout
//
//  Created by steve on 6/22/09.
//

#import "GoogleChartAxis.h"

//  Superclass for all axis types. These shouldn't be instantiated.
@implementation GoogleChartAxis

@synthesize labels, type, range;

- (id)init {
  if (self = [super init]) {
    self->type = [self axisType];
    self.labels = [[NSMutableArray alloc] init];
    self.range = [[GoogleChartAxisRange alloc] init];
  }
  return self;
}

//  Return the axis type parameter for the chart url (chxt)
- (NSString *)axisType {return @"";}

//  Returns YES or NO based on whether the axis has any data to be included in the
//  chart url (chxt, chxl and chxr)
- (BOOL)isValid {
  if ([labels count] > 0 || [range isValid]) return YES;
  else return NO;
}
@end

//  The 4 different types of axes. You should never need to instantiate these since each GoogleChart object
//  already has each axis set to one of these types of objects.
@implementation GoogleChartXAxis
- (NSString *)axisType {return @"x";}
@end
@implementation GoogleChartYAxis
- (NSString *)axisType {return @"y";}
@end
@implementation GoogleChartTopAxis
- (NSString *)axisType {return @"t";}
@end
@implementation GoogleChartRightAxis
- (NSString *)axisType {return @"r";}
@end

//  A object representing the range on a given axis. Each new axis object already has it's range set,
//  so you shouldn't need to instantiate one of these.
@implementation GoogleChartAxisRange

@synthesize index, min, max, interval;

//  A convenience method for setting the index, max and min all at once.
- (void)setRange:(int)indexValue min:(int)minimumValue max:(int)maximumValue {
  self.index = indexValue;
  self.min = minimumValue;
  self.max = maximumValue;
}

//  Returns YES or NO based on whether the range has any data that should be included in the chart url (chxr).
- (BOOL)isValid {
  if (index >= 0 && ((min == 0 && max != 0) || (max == 0 && min != 0) || (min != 0 && max != 0))) return YES;
  else return NO;
}

//  Data to use in the chart url parameter 'chxr'.
- (NSString *)formattedRange {
  if (interval > 0) return [NSString stringWithFormat:@"%d,%d,%d,%d", index, min, max, interval];
  else return [NSString stringWithFormat:@"%d,%d,%d", index, min, max];
}
@end
