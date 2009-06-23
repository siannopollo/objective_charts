//
//  GoogleChartTest.m
//  workout
//
//  Created by steve on 6/19/09.
//

#import "GoogleChartTest.h"
#import "GoogleChart.h"

@implementation GoogleChartTest

@synthesize chart;

- (void)setUp {
  self.chart = [[GoogleChart alloc] init];
}

- (void)tearDown {
  [self.chart release];
}

- (void)testDefaults {
  STAssertEquals(@"http://chart.apis.google.com/chart", chart.apiUrl, nil);
  STAssertEqualObjects(@"", [chart size], nil);
  STAssertEqualObjects(@"", chart.type, nil);
  STAssertEqualObjects(@"text", chart.dataEncoding, nil);
  STAssertEqualObjects([[NSMutableArray alloc] init], chart.data, nil);
  STAssertEquals((float)1.05, chart.scaleFactor, nil);
  STAssertEqualObjects([[NSMutableArray alloc] init], chart.labels, nil);
  STAssertEqualObjects(@"Top", chart.legend.position, nil);
  STAssertEqualObjects([[NSMutableArray alloc] init], chart.colors, nil);
}

- (void)testChartSize {
  chart.width = 320;
  chart.height = 480;
  STAssertEqualObjects(@"320x480", [chart size], nil);
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chs=320x480", [chart url], nil);
  
  chart.height = 0;
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?", [chart url], nil);
}

- (void)testChartType {
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?", [chart url], nil);
  chart.type = @"Line";
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?cht=lc", [chart url], nil);
  chart.type = @"Vertical Bar";
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?cht=bvs", [chart url], nil);
  chart.type = @"3D Pie";
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?cht=p3", [chart url], nil);
  chart.type = @"Something not available";
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?", [chart url], nil);
}
  
- (void)testChartData {
  chart.scaleFactor = 0.0; // No scaling
  
  [chart.data addObject:[NSArray arrayWithObjects:
                         [NSNumber numberWithInt:1],
                         [NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:10],
                         [NSNumber numberWithInt:100],
                         @"400", nil]];
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chd=t:1,2,10,100,400",
                       [chart url], nil);
  
  [chart.data addObject:[NSArray arrayWithObjects:
                         [NSNumber numberWithInt:99],
                         [NSNumber numberWithInt:-1],
                         [NSNumber numberWithInt:32], nil]];
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chd=t:1,2,10,100,400|99,32",
                       [chart url], nil);
}

// Defaults to 5% greater than largest data value
- (void)testChartScale {
  [chart.data addObject:[NSArray arrayWithObjects:
                         [NSNumber numberWithInt:99],
                         [NSNumber numberWithInt:-1],
                         [NSNumber numberWithInt:32], nil]];
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chd=t:99,32&chds=0,104", [chart url], nil);
  
  [chart.data addObject:[NSArray arrayWithObjects:
                         [NSNumber numberWithInt:1],
                         [NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:10],
                         [NSNumber numberWithInt:100],
                         @"400", nil]];
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chd=t:99,32|1,2,10,100,400&chds=0,420",
                       [chart url], nil);
  
  chart.scaleFactor = 1.14;
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chd=t:99,32|1,2,10,100,400&chds=0,456",
                       [chart url], nil);
  
  chart.scaleFactor = 0.80;
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chd=t:99,32|1,2,10,100,400&chds=0,320",
                       [chart url], nil);
  
  chart.scaleFactor = 0; // No scaling
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chd=t:99,32|1,2,10,100,400",
                       [chart url], nil);
}

- (void)testLabels {
  [chart.labels addObject:@"Label1"];
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chl=Label1", [chart url], nil);
  [chart.labels addObject:@"Label2"];
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chl=Label1|Label2", [chart url], nil);
}

- (void)testAxes {
  chart.scaleFactor = 0;
  [chart.data addObject:[NSArray arrayWithObjects:@"1", @"2", @"10", @"100", @"400", nil]];
  [chart.xAxis.labels setArray:[NSArray arrayWithObjects:@"3/1", @"3/8", @"3/15", @"3/22", @"3/29", nil]];
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chd=t:1,2,10,100,400&chxt=x&chxl=0:|3/1|3/8|3/15|3/22|3/29",
                       [chart url], nil);
  
  chart.scaleFactor = 1.05;
  [chart.yAxis.range setRange:1 min:0 max:[chart maxDataValue]*chart.scaleFactor+1];
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chd=t:1,2,10,100,400&chds=0,420&chxt=x,y&chxl=0:|3/1|3/8|3/15|3/22|3/29&chxr=1,0,420",
                       [chart url], nil);
}

- (void)testLegend {
  chart.legend.labels = [NSArray arrayWithObjects:@"One", @"Two", @"Three", nil];
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chdl=One|Two|Three&chdlp=tv", [chart url], nil);
  
  chart.legend.position = @"Right";
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chdl=One|Two|Three&chdlp=r", [chart url], nil);
}

- (void)testColors {
  [chart.colors addObjectsFromArray:[NSArray arrayWithObjects:@"ff0000", @"00ff00", @"0000ff", nil]];
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?chco=ff0000,00ff00,0000ff", [chart url], nil);
}

- (void)testAllSupportedParameters {
  chart.width = 320;
  chart.height = 480;
  chart.type = @"Line";
  [chart.data addObject:[NSArray arrayWithObjects:@"1", @"2", @"10", @"100", @"400", nil]];
  [chart.labels addObject:@"My data"];
  [chart.xAxis.labels setArray:[NSArray arrayWithObjects:@"3/1", @"3/8", @"3/15", @"3/22", @"3/29", nil]];
  [chart.yAxis.range setRange:1 min:0 max:[chart maxDataValue]*chart.scaleFactor+1];
  chart.legend.labels = [NSArray arrayWithObject:@"Data"];
  [chart.colors addObject:@"00ff000f"];
  
  STAssertEqualObjects(@"http://chart.apis.google.com/chart?cht=lc&chs=320x480&chd=t:1,2,10,100,400&chds=0,420&chl=My data&chxt=x,y&chxl=0:|3/1|3/8|3/15|3/22|3/29&chxr=1,0,420&chdl=Data&chdlp=tv&chco=00ff000f",
                       [chart url], nil);
}

- (void)testExtendedEncoding {
  STAssertEqualObjects(@"", [GoogleChart extendedEncodingFor:-1], nil);
  STAssertEqualObjects(@"", [GoogleChart extendedEncodingFor:4096], nil);
  STAssertEqualObjects(@"AA", [GoogleChart extendedEncodingFor:0], nil);
  STAssertEqualObjects(@"A0", [GoogleChart extendedEncodingFor:52], nil);
  STAssertEqualObjects(@"Bk", [GoogleChart extendedEncodingFor:100], nil);
  STAssertEqualObjects(@"9a", [GoogleChart extendedEncodingFor:3930], nil);
  STAssertEqualObjects(@"..", [GoogleChart extendedEncodingFor:4095], nil);
}

- (void)testTextEncoding {
  STAssertEqualObjects(@"", [GoogleChart textEncodingFor:-1], nil);
  STAssertEqualObjects(@"4096", [GoogleChart textEncodingFor:4096], nil);
  STAssertEqualObjects(@"0", [GoogleChart textEncodingFor:0], nil);
  STAssertEqualObjects(@"52", [GoogleChart textEncodingFor:52], nil);
}

@end
