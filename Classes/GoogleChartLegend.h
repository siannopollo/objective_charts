//
//  GoogleChartLegend.h
//  workout
//
//  Created by steve on 6/23/09.
//

#import <Foundation/Foundation.h>

@interface GoogleChartLegend : NSObject {
  NSString *position;
  NSArray *labels;
}
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) NSArray *labels;

- (NSString *)formattedData;
@end

@interface GoogleChartLegend (hidden)
- (NSString *)encodedPosition;
@end