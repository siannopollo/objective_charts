//
//  GoogleChartLegend.m
//  workout
//
//  Created by steve on 6/23/09.
//

#import "GoogleChartLegend.h"

//  Object representing the legend on a Google chart. These shouldn't need to be instantiated since each
//  GoogleChart object already has one of these.
@implementation GoogleChartLegend

@synthesize position, labels;

- (id)init {
  if (self = [super init]) {
    self.position = @"Top";
    self.labels = [[NSMutableArray alloc] init];
  }
  return self;
}

//  Returns the data for the legend parameter in the chart url (chdl) based on the values set in the
//  'labels' property.
- (NSString *)formattedData {
  if ([labels count] == 0) return @"";
  
  return [NSString stringWithFormat:@"%@&chdlp=%@",
          [labels componentsJoinedByString:@"|"], [self encodedPosition]];
}

//  Converts the English position (one of 'Top', 'Bottom', 'Left' or 'Right') to the value used in the
//  parameter for the chart url (chdlp).
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
