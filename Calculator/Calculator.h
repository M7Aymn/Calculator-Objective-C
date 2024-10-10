//
//  Calculator.h
//  Calculator
//
//  Created by Mohamed Ayman on 08/07/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Calculator : NSObject
-(double) add: (double) first to: (double) second;
-(double) sub: (double) first from: (double) second;
-(double) mul: (double) first by: (double) second;
-(double) div: (double) first by: (double) second;
@end

NS_ASSUME_NONNULL_END
