//
//  Calculator.m
//  Calculator
//
//  Created by Mohamed Ayman on 08/07/2024.
//

#import "Calculator.h"

@implementation Calculator
-(double) add: (double) first to: (double) second {
    return first + second;
}
-(double) sub: (double) first from: (double) second{
    return second - first;
}
-(double) mul: (double) first by: (double) second{
    return first * second;
}
-(double) div: (double) first by: (double) second{
    return first / second;
}
@end
