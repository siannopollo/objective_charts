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
  NSMutableArray *lineStyles;
}

@property (nonatomic, readonly, assign) NSString *apiUrl;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) NSString *type;
@property (nonatomic, assign) NSMutableArray *data;
@property (nonatomic, assign) NSString *dataEncoding;
@property (nonatomic, assign) float scaleFactor;
@property (nonatomic, assign) NSMutableArray *labels;
@property (nonatomic, assign) GoogleChartAxis *xAxis;
@property (nonatomic, assign) GoogleChartAxis *yAxis;
@property (nonatomic, assign) GoogleChartAxis *topAxis;
@property (nonatomic, assign) GoogleChartAxis *rightAxis;
@property (nonatomic, assign) GoogleChartLegend *legend;
@property (nonatomic, assign) NSMutableArray *colors;
@property (nonatomic, assign) NSMutableArray *lineStyles;

+ (NSString *)extendedEncodingFor:(int)value;
+ (NSString *)textEncodingFor:(int)value;
- (NSString *)size;
- (NSString *)url;
- (NSString *)scaling;
- (int)maxDataValue;
@end

@interface GoogleChart (hidden)
- (NSString *)axisData;
- (NSString *)chartType;
- (NSString *)dataLabels;
- (NSString *)formattedData;
- (NSString *)formattedColors;
- (NSString *)formattedLineStyles;
- (NSString *)valueForUrlParameter:(NSString *)parameter;
@end
