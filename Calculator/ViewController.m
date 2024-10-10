//
//  ViewController.m
//  Calculator
//
//  Created by Mohamed Ayman on 07/07/2024.
//

#import "ViewController.h"

@interface ViewController () {
    double finalResult;
    double tempResult;
    double secondOperand;
    char currentOperator; // for * and /
    char prevOperator;    // for + and -
    BOOL isCalculated;
    BOOL canAddDot;
    BOOL isNumberToBeChanged;
}
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *grayButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *orangeButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *lightGrayButtons;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initButtons];
    [self reset];
}

-(void) initButtons {
    for (UIButton *button in _grayButtons) {
        button.backgroundColor = [UIColor colorNamed: @"darkGrayButton"];
        button.layer.cornerRadius = button.frame.size.height / 2;
    }
    for (UIButton *button in _orangeButtons) {
        button.backgroundColor = [UIColor colorNamed: @"orangeButton"];
        button.layer.cornerRadius = button.frame.size.height / 2;
    }
    for (UIButton *button in _lightGrayButtons) {
        button.tintColor = UIColor.blackColor;
        button.backgroundColor = [UIColor colorNamed: @"lightGrayButton"];
        button.layer.cornerRadius = button.frame.size.height / 2;
    }
}

-(void) reset {
    _resultLabel.text = @"0";
    finalResult = 0;
    tempResult = NAN;
    currentOperator = ' ';
    prevOperator = '+';
    canAddDot = YES;
    isCalculated = NO;
    isNumberToBeChanged = NO;
}

- (IBAction)numberButtons:(UIButton *)sender {
    if (isCalculated) {
        _resultLabel.text = @"0";
        isCalculated = NO;
    }
    if (isNumberToBeChanged) {
        _resultLabel.text = @"0";
        isNumberToBeChanged = NO;
    }
    
    NSString *number = [NSString stringWithFormat:@"%ld", sender.tag];
    if ([_resultLabel.text isEqual:@"0"]) {
        _resultLabel.text = number;
    } else {
        _resultLabel.text = [_resultLabel.text stringByAppendingString: number];
    }
}

- (IBAction)dotButton:(UIButton *)sender {
#warning check these two functions for validity
    if (isCalculated) {
        _resultLabel.text = @"0";
        isCalculated = NO;
    }
    if (isNumberToBeChanged) {
        _resultLabel.text = @"0";
        isNumberToBeChanged = NO;
    }
    if (canAddDot) {
        _resultLabel.text = [_resultLabel.text stringByAppendingString: @"."];
        canAddDot = NO;
    }
}

- (double) getNumber {
    return [_resultLabel.text doubleValue];
}

- (void) setNumber: (double) number {
//This to eliminate unnecessary 0 decimal digits like 3.12000000000
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 10;
    formatter.minimumIntegerDigits = 1;
    formatter.usesSignificantDigits = YES;

    NSString *formattedString = [formatter stringFromNumber: [NSNumber numberWithDouble:number]];
    
    _resultLabel.text = formattedString;
    
//    _resultLabel.text = [NSString stringWithFormat:@"%.2f", number];
}

- (void) operatorPressed: (char) operator {
    isNumberToBeChanged = YES;
    if(operator == '+' || operator == '-') {
#warning to be completed
        if (currentOperator != ' ' /*== '*' || currentOperator == '/'*/) {
            [self stepPriorityCalculation];
            [self addTempToFinalResult];
            currentOperator = ' ';
        } else {
            [self stepNormalCalculation];
        }
        prevOperator = operator;
        [self setNumber:finalResult];
    }
    
    else if(operator == '*' || operator == '/') {
        currentOperator = operator;
        [self stepPriorityCalculation];
        [self setNumber:tempResult];
    }
}

- (void) stepPriorityCalculation {
    switch (currentOperator) {
        case '*':
            if (isnan(tempResult)) {
                tempResult = [self getNumber];
            } else {
                secondOperand = [self getNumber];
                tempResult *= secondOperand;
            }
            break;
        case '/':
            if (isnan(tempResult)) {
                tempResult = [self getNumber];
            } else {
                secondOperand = [self getNumber];
                tempResult /= secondOperand;
            }
            break;
        default:
            break;
    }
}

- (void) stepNormalCalculation {
    switch (prevOperator) {
        case '+':
            finalResult += [self getNumber];
            break;
        case '-':
            finalResult -= [self getNumber];
            break;
        default:
            break;
    }
}

- (void) addTempToFinalResult {
    switch (prevOperator) {
        case '+':
            finalResult += tempResult;
            tempResult = NAN;
            break;
        case '-':
            finalResult -= tempResult;
            tempResult = NAN;
        default:
            break;
    }
}

- (void) equalPressed {
    if (currentOperator != ' ') {
        [self stepPriorityCalculation];
        [self addTempToFinalResult];
    } else {
        if (prevOperator == '+') {
            finalResult += [self getNumber];
        } else if (prevOperator == '-') {
            finalResult -= [self getNumber];
        }
    }
    [self setNumber:finalResult];
    isCalculated = YES;
}

- (IBAction)operationButtons:(UIButton *)sender {
    canAddDot = YES;
    switch (sender.tag) {
        case 11: // =
            [self equalPressed];
            break;
            
        case 12: // +
            [self operatorPressed:'+'];
            break;
            
        case 13: // -
            [self operatorPressed:'-'];
            break;
            
        case 14: // ×
            [self operatorPressed:'*'];
            break;
            
        case 15: // ÷
            [self operatorPressed:'/'];
            break;
            
        case 16: // %
            [self setNumber:[_resultLabel.text doubleValue] / 100.0];
//            _resultLabel.text = [NSString stringWithFormat:@"%f", [_resultLabel.text doubleValue] / 100.0];
            break;
            
        case 17: // +/-
            if ([_resultLabel.text doubleValue] != 0.0) {
                if ([_resultLabel.text characterAtIndex:0] == '-') {
                    _resultLabel.text = [_resultLabel.text substringFromIndex:1];
                } else {
                    _resultLabel.text = [@"-" stringByAppendingString:_resultLabel.text];
                }
            }
            break;
            
        case 18: // AC
            [self reset];
            break;
            
        default:
            break;
    }
}

@end
