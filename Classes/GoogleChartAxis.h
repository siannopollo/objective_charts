//
//  GoogleChartAxis.h
//  workout
//
//  Created by steve on 6/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleChartAxisRange: NSObject {
  int index;
  int min;
  int max;
  int interval;
}

@property (nonatomic, assign) int index;
@property (nonatomic, assign) int min;
@property (nonatomic, assign) int max;
@property (nonatomic, assign) int interval;

- (void)setRange:(int)indexValue min:(int)minimumValue max:(int)maximumValue;
- (BOOL)isValid;
- (NSString *)formattedRange;
@end

@interface GoogleChartAxis : NSObject {
  NSMutableArray *labels;
  NSString *type;
  GoogleChartAxisRange *range;
}

@property (nonatomic, retain) NSMutableArray *labels;
@property (nonatomic, readonly, retain) NSString *type;
@property (nonatomic, assign) GoogleChartAxisRange *range;

- (BOOL)isValid;
@end

@interface GoogleChartXAxis : GoogleChartAxis
@end
@interface GoogleChartYAxis : GoogleChartAxis
@end
@interface GoogleChartTopAxis : GoogleChartAxis
@end
@interface GoogleChartRightAxis : GoogleChartAxis
@end

@interface GoogleChartAxis (hidden)
- (NSString *)axisType;
@end