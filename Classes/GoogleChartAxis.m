//
//  GoogleChartAxis.m
//  workout
//
//  Created by steve on 6/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GoogleChartAxis.h"

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

- (NSString *)axisType {return @"";}

- (BOOL)isValid {
  if ([labels count] > 0 || [range isValid]) return YES;
  else return NO;
}
@end

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

@implementation GoogleChartAxisRange

@synthesize index, min, max, interval;

- (void)setRange:(int)indexValue min:(int)minimumValue max:(int)maximumValue {
  self.index = indexValue;
  self.min = minimumValue;
  self.max = maximumValue;
}

- (BOOL)isValid {
  if (index >= 0 && ((min == 0 && max != 0) || (max == 0 && min != 0) || (min != 0 && max != 0))) return YES;
  else return NO;
}

- (NSString *)formattedRange {
  if (interval > 0) return [NSString stringWithFormat:@"%d,%d,%d,%d", index, min, max, interval];
  else return [NSString stringWithFormat:@"%d,%d,%d", index, min, max];
}
@end
