//
//  GoogleChart.m
//  workout
//
//  Created by steve on 6/19/09.
//

#import "GoogleChart.h"
#import "GoogleChartAxis.h"
#import "GoogleChartLegend.h"

@implementation GoogleChart

@synthesize apiUrl, width, height, type, data, dataEncoding, scaleFactor, labels,
            xAxis, yAxis, topAxis, rightAxis, legend, colors;

//  Implements the extended encoding scheme for the API
+ (NSString *)extendedEncodingFor:(int)value {
  if (value < 0 || value > 4095) return @"";
  
  NSString *characters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-.";
  int length = [characters length];
  unichar firstCharacter = [characters characterAtIndex:value/length];
  unichar secondCharacter = [characters characterAtIndex:value%length];
  return [NSString stringWithFormat:@"%C%C", firstCharacter, secondCharacter];
}

//  Plain text encoding, which just passes values through as their string versions
+ (NSString *)textEncodingFor:(int)value {
  if (value < 0) return @"";
  return [NSString stringWithFormat:@"%d", value];
}

- (id)init {
  if (self = [super init]) {
    self->apiUrl = @"http://chart.apis.google.com/chart";
    self.type = @"";
    self.data = [[NSMutableArray alloc] init];
    self.dataEncoding = @"text";
    self.scaleFactor = 1.05;
    self.labels = [[NSMutableArray alloc] init];
    
    self.xAxis = [[GoogleChartXAxis alloc] init];
    self.yAxis = [[GoogleChartYAxis alloc] init];
    self.topAxis = [[GoogleChartTopAxis alloc] init];
    self.rightAxis = [[GoogleChartRightAxis alloc] init];
    self.legend = [[GoogleChartLegend alloc] init];
    
    self.colors = [[NSMutableArray alloc] init];
  }
  return self;
}

//  Formatted string of <width>x<height>
- (NSString *)size {
  if (width == 0 || height == 0) return @"";
  return [NSString stringWithFormat:@"%dx%d", width, height];
}

//  Returns the encoded chart type for the chart url. Based off of the 'type' property.
//  If 'type' is not set or something not in the below dictionary, this returns an empty string.
- (NSString *)chartType {
  id value = [[NSDictionary dictionaryWithObjectsAndKeys:
               @"", @"",
               @"lc", @"Line",
               @"ls", @"Sparkline",
               @"lxy", @"Variable Line",
               @"bhs", @"Horizontal Bar",
               @"bvs", @"Vertical Bar",
               @"bhg", @"Grouped Horizontal Bar",
               @"bvg", @"Grouped Vertical Bar",
               @"p", @"Pie",
               @"p3", @"3D Pie",
               @"pc", @"Concentric Pie",
               nil] objectForKey:[self type]];
  if (value == nil) value = @"";
  return value;
}

//  Formats the items in the 'data' property for the data parameter in the chart url (chd).
//  This assumes that the 'data' property has one or more arrays in it, like so:
//    [[data set 1], [data set 2]]
//
//  This also runs each item in each data set through the encoding set in the 'encoding' property.
- (NSString *)formattedData {
  NSString *result = [NSString stringWithFormat:@"%C:", [dataEncoding characterAtIndex:0]];
  NSArray *dataSet; NSMutableArray *dataSetStrings, *dataSetString; NSInvocation *invocation;
  dataSetStrings = [[NSMutableArray alloc] init];
  SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@EncodingFor:", dataEncoding]);
  
  for (dataSet in data) {
    dataSetString = [[NSMutableArray alloc] init];
    for (id item in dataSet) {
      invocation = [NSInvocation invocationWithMethodSignature:[[self class] methodSignatureForSelector:selector]];
      [invocation setSelector:selector];
      int arg = [item intValue];
      [invocation setArgument:&arg atIndex:2];
      [invocation invokeWithTarget:[self class]];
      NSString *value; [invocation getReturnValue:&value];
      if ([value length] > 0) [dataSetString addObject:value];
      [value release];
    }
    [dataSetStrings addObject:[dataSetString componentsJoinedByString:@","]];
  }
  result = [NSString stringWithFormat:@"%@%@", result, [dataSetStrings componentsJoinedByString:@"|"]];
  if ([result length] == 2) result = @"";
  
  return result;
}

//  Returns the scaling parameter for the chart url (chds) based on the maximum value in the 'data' property
//  multiplied by the 'scalingFactor' property. If 'scalingFactor' is set to 0, this returns an empty string.
- (NSString *)scaling {
  if ([data count] == 0 || scaleFactor == 0.0) return @"";
  return [NSString stringWithFormat:@"0,%.0f", [self maxDataValue]*scaleFactor];
}

//  Returns the label parameter for the chart url (chl) based on the 'labels' property.
//  Note: The 'chl' parameter seems to take precedence over any labels set for the 'xAxis' object.
- (NSString *)dataLabels {
  if ([labels count] == 0) return @"";
  return [labels componentsJoinedByString:@"|"];
}

//  Spins through all four possible axes (x, y, top, right) and collects which axes should be shown and
//  any labels and ranges that may have been set for them.
- (NSString *)axisData {
  if ([data count] == 0) return @"";
  
  NSArray *axes = [NSArray arrayWithObjects:xAxis, yAxis, topAxis, rightAxis, nil];
  NSMutableArray *typeValues = [[NSMutableArray alloc] init];
  NSMutableArray *labelValues = [[NSMutableArray alloc] init];
  NSMutableArray *rangeValues = [[NSMutableArray alloc] init];
  
  for (int i = 0; i < [axes count]; i++) {
    GoogleChartAxis *axis = [axes objectAtIndex:i];
    if ([axis isValid]) {
      [typeValues addObject:axis.type];
      if ([axis.labels count] > 0) {
        [labelValues addObject:
         [NSString stringWithFormat:@"%d:|%@", i, [axis.labels componentsJoinedByString:@"|"]]];
      }
      if ([axis.range isValid]) [rangeValues addObject:[axis.range formattedRange]];
    }
  }
  
  if ([typeValues count] == 0) return @"";
  
  NSString *result = [typeValues componentsJoinedByString:@","];
  if ([labelValues count] > 0) {
    result = [NSString stringWithFormat:@"%@&chxl=%@", result, [labelValues componentsJoinedByString:@"|"]];
  }
  if ([rangeValues count] > 0) {
    result = [NSString stringWithFormat:@"%@&chxr=%@", result, [rangeValues componentsJoinedByString:@"|"]];
  }
  return result;
}

//  Returns the colors parameter for the chart url (chco) based on the 'colors' property.
//  According to Google, colors should be 6 character strings in hexadecimal format (RRGGBB) or
//  8 character strings with RGB values and transparency values (RRGGBBTT)
- (NSString *)formattedColors {
  if ([colors count] == 0) return @"";
  return [colors componentsJoinedByString:@","];
}

//  Returns the maximum value present in the 'data' property.
- (int)maxDataValue {
  if ([data count] == 0) return 0;
  
  NSMutableArray *allValues = [[NSMutableArray alloc] init];
  for (NSArray *dataSet in data) {
    for (id item in dataSet) {
      [allValues addObject:[NSNumber numberWithInt:[[NSString stringWithFormat:@"%@", item] intValue]]];
    }
  }
  NSArray *sorted = [allValues sortedArrayUsingSelector:@selector(compare:)];
  return [[sorted objectAtIndex:[sorted count] - 1] intValue];
}

//  Returns the value calculated for a given parameter in the chart url
- (NSString *)valueForUrlParameter:(NSString *)parameter {
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  [dictionary setObject:[self chartType] forKey:@"cht"];
  [dictionary setObject:[self size] forKey:@"chs"];
  [dictionary setObject:[self formattedData] forKey:@"chd"];
  [dictionary setObject:[self scaling] forKey:@"chds"];
  [dictionary setObject:[self dataLabels] forKey:@"chl"];
  [dictionary setObject:[self axisData] forKey:@"chxt"];
  [dictionary setObject:[legend formattedData] forKey:@"chdl"];
  [dictionary setObject:[self formattedColors] forKey:@"chco"];
  
  return [dictionary objectForKey:parameter];
}

//  Returns the fully formatted url for creating a Google chart
- (NSString *)url {
  NSString *parameter, *value;
  NSArray *parameters = [NSArray arrayWithObjects:
                         @"cht", @"chs", @"chd", @"chds", @"chl", @"chxt", @"chdl", @"chco", nil];
  NSMutableArray *urlParameters = [[NSMutableArray alloc] init];
  
  for (parameter in parameters) {
    value = [self valueForUrlParameter:parameter];
    if ([value length] > 0) {
      [urlParameters addObject:[NSString stringWithFormat:@"%@=%@", parameter, value]];
    }
  }
  [parameter release]; [value release];
  
  return [NSString stringWithFormat:@"%@?%@", apiUrl, [urlParameters componentsJoinedByString:@"&"]];
}

@end
