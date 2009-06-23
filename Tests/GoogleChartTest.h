//
//  GoogleChartTest.h
//  workout
//
//  Created by steve on 6/19/09.
//

#import <Foundation/Foundation.h>
#import "GTMSenTestCase.h"

@class GoogleChart;

@interface GoogleChartTest : SenTestCase {
  GoogleChart *chart;
}

@property (nonatomic, retain) GoogleChart *chart;

@end
