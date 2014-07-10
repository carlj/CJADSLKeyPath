#CJADSLKeyPath
CJADSLKeyPath is a easy to use Category for accessing values with a special keyPath 

##Installation
Just drag&drop the ```NSObject+DSLKeyPath.h.h``` file in your XCode Project. 
For global usage you can import the ```NSObject+DSLKeyPath.h.h``` in your projects ```-Prefix.pch``` file.

##Usage
First check out the example Project for further examples

``` objc
NSDictionary *object = @{
                             @"test" : @"foo",
                             @"nested" : @{
                                     @"name" : @"bar",
                                     @"items" : @[
                                             @{ @"value1" : @"0" , @"value2" : @"foo"},
                                             @{ @"value1" : @"1" , @"value2" : @"foo"},
                                             @{ @"value1" : @"2" , @"value2" : @"foo"},
                                             @{ @"value1" : @"3" , @"value2" : @"foo"},
                                             ]
                                     }
                             };
    
NSArray *values = [object valueForDSLKeyPath:@"nested.items[*].value1"];
NSLog(@"%@", values);
// prints out: 0, 1, 2, 3

NSString *value = [object valueForDSLKeyPath:@"nested.items[0].value1"];
NSLog(@"%@", value);
// prints out: 0
```

##License
MIT License