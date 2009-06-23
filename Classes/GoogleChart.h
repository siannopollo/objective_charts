//
//  GoogleChart.h
//  workout
//
//  Created by steve on 6/19/09.
//

#import <Foundation/Foundation.h>
#import "GoogleChartAxis.h"
#import "GoogleChartLegend.h"

@class GoogleChartAxis;
@class GoogleChartLegend;

@interface GoogleChart : NSObject {
  NSString *apiUrl;
  int width;
  int height;
  NSString *type;
  NSMutableArray *data;
  NSString *dataEncoding;
  float scaleFactor;
  NSMutableArray *labels;
  GoogleChartAxis *xAxis;
  GoogleChartAxis *yAxis;
  GoogleChartAxis *topAxis;
  GoogleChartAxis *rightAxis;
  GoogleChartLegend *legend;
  NSMutableArray *colors;
}

@property (nonatomic, readonly, retain) NSString *apiUrl;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSString *dataEncoding;
@property (nonatomic, assign) float scaleFactor;
@property (nonatomic, retain) NSMutableArray *labels;
@property (nonatomic, retain) GoogleChartAxis *xAxis;
@property (nonatomic, retain) GoogleChartAxis *yAxis;
@property (nonatomic, retain) GoogleChartAxis *topAxis;
@property (nonatomic, retain) GoogleChartAxis *rightAxis;
@property (nonatomic, retain) GoogleChartLegend *legend;
@property (nonatomic, retain) NSMutableArray *colors;

+ (NSString *)extendedEncodingFor:(int)value;
+ (NSString *)textEncodingFor:(int)value;
- (NSString *)size;
- (NSString *)url;
- (NSString *)chartType;
- (NSString *)scaling;
- (NSString *)dataLabels;
- (NSString *)axisData;
- (NSString *)formattedColors;
- (int)maxDataValue;
@end

@interface GoogleChart (hidden)
- (NSString *)valueForUrlParameter:(NSString *)parameter;
- (NSString *)formattedData;
@end
