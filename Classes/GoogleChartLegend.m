//
//  GoogleChartLegend.m
//  workout
//
//  Created by steve on 6/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GoogleChartLegend.h"

@implementation GoogleChartLegend

@synthesize position, labels;

- (id)init {
  if (self = [super init]) {
    self.position = @"Top";
    self.labels = [[NSMutableArray alloc] init];
  }
  return self;
}

- (NSString *)formattedData {
  if ([labels count] == 0) return @"";
  
  return [NSString stringWithFormat:@"%@&chdlp=%@",
          [labels componentsJoinedByString:@"|"], [self encodedPosition]];
}

- (NSString *)encodedPosition {
  NSString *value = [[NSDictionary dictionaryWithObjectsAndKeys:
                      @"bv", @"Bottom", @"tv", @"Top", @"r", @"Right", @"l", @"Left",
                      nil] objectForKey:position];
  
  if (value == nil) return @"tv";
  else return value;
}

- (void)dealloc {
  [super dealloc];
  [position release];
  [labels release];
}
@end
