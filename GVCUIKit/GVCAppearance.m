/*
 * GVCAppearance.m
 * 
 * Created by David Aspinall on 2012-11-29. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCAppearance.h"
#import <GVCFoundation/GVCFoundation.h>

#import "UIColor+GVCUIKit.h"

@interface GVCAppearance ()
@property (nonatomic, strong) NSDictionary *jsonDictionary;
@end

@implementation GVCAppearance

GVC_SINGLETON_CLASS(GVCAppearance);


- (id)init
{
	self = [super init];
	if ( self != nil )
	{
	}
	
    return self;
}

- (void)applyDefaultAppearance
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"appearance" ofType:@"json"];
	if ( gvc_IsEmpty(path) == NO )
	{
		NSData *jsonData = [NSData dataWithContentsOfFile:path];
		if (gvc_IsEmpty(jsonData) == NO)
		{
			[self applyAppearance:jsonData];
		}
	}
}

- (void)applyAppearance:(NSData *)jsonData
{
	NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
	
	if ( gvc_IsEmpty(dictionary) == YES )
	{
		GVCLogNSError(GVCLoggerLevel_ERROR, error);
	}
	else
	{
		GVCStack *stack = [[GVCStack alloc] init];
		[self setJsonDictionary:dictionary];
		[self applyAppearanceDictionary:[self jsonDictionary] stackContext:stack];
		[self setJsonDictionary:nil];
	}
}

- (void)applyAppearanceDictionary:(NSDictionary *)dictionary stackContext:(GVCStack *)stack
{
	for (NSString *key in dictionary)
	{
		Class clazz = NSClassFromString(key);
		id obj = [dictionary valueForKey:key];
        
        if (clazz != nil)
		{
			GVC_DBC_FACT_IS_KIND_OF_CLASS(obj, [NSDictionary class]);
			
			[self applyAppearanceClass:clazz dictionary:(NSDictionary *)obj stackContext:stack];
        }
		else
		{
            [self applyAppearanceProperty:key value:obj stackContext:stack];
        }
	}
}

- (void)applyAppearanceClass:(Class)clazz dictionary:(NSDictionary *)dictionary stackContext:(GVCStack *)stack
{
	GVC_DBC_FACT([clazz conformsToProtocol:@protocol(UIAppearance)] || [clazz conformsToProtocol:@protocol(UIAppearanceContainer)]);
	
	Class lastClass = [stack peekObject];
	GVC_DBC_FACT((lastClass == nil) || ([lastClass conformsToProtocol:@protocol(UIAppearanceContainer)] == YES));
	
	if ((lastClass == nil) || ([lastClass conformsToProtocol:@protocol(UIAppearanceContainer)] == YES))
	{
		[stack pushObject:clazz];
		[self applyAppearanceDictionary:dictionary stackContext:stack];
		[stack popObject];
	}
}

- (void)applyAppearanceProperty:(NSString *)property value:(NSObject *)object stackContext:(GVCStack *)stack
{
	GVCLogDebug(@"Looking for %@ on %@ with %@", property, stack, object);
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[property characterAtIndex:0]] == NO);
					GVC_DBC_FACT_NOT_NIL([stack peekObject]);
					GVC_DBC_FACT_NOT_NIL(object);
					GVC_DBC_FACT_CONFORMS_TO_PROTOCOL([stack peekObject], @protocol(UIAppearance))
					)
	
	// implementation
	GVCInvocation *invoker = [[GVCInvocation alloc] initForTargetClass:[stack peekObject]];
	id <UIAppearance>appearanceTarget = [self appearanceForStackContext:stack];
	NSString *regexp = [NSString stringWithFormat:@"^set%@:", [property gvc_StringWithCapitalizedFirstCharacter]];
	[invoker findBestSelectorForMethodPattern:regexp];

	NSArray *arguments = [self argumentValues:object forInvocation:invoker propertyName:property];
	if ( gvc_IsEmpty(arguments) == NO )
	{
		NSInvocation *invocation = [invoker invocationForTarget:appearanceTarget arguments:arguments];
		[invocation invoke];
	}
	
	GVC_DBC_ENSURE()
}

- (NSArray *)colorArgumentValues:(NSObject *)object
{
	NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:10];

	if ( [object isKindOfClass:[NSString class]] == YES)
	{
		NSString *value = (NSString *)object;
		if ([value hasPrefix:@"#"])
		{
			[arguments addObject:[UIColor gvc_ColorFromHexString:value]];
		}
		else
		{
			// must be a color name like 'red'
			[arguments addObject:[UIColor gvc_ColorForColorName:value]];
		}
	}
	else if ([object isKindOfClass:[NSArray class]] == YES)
	{
		// array in the format ( rr, gg, bb ) or an array in an array [["blue"],[rr,gg,bb]]
		NSArray *colorArray = (NSArray *)object;
		if ( [[colorArray objectAtIndex:0] isKindOfClass:[NSArray class]] == YES )
		{
			NSMutableArray *nestedArguments = [NSMutableArray arrayWithCapacity:[colorArray count]];
			for (NSArray *arg in colorArray)
			{
				// each one should be a color
				NSArray *parsed = [self colorArgumentValues:arg];
				if ( gvc_IsEmpty(parsed) == NO )
				{
					[nestedArguments addObjectsFromArray:parsed];
				}
			}
			[arguments addObject:nestedArguments];
		}
		else if ( [colorArray count] == 3 )
		{
			CGFloat red = [[colorArray objectAtIndex:0] floatValue];
			CGFloat green = [[colorArray objectAtIndex:1] floatValue];
			CGFloat blue = [[colorArray objectAtIndex:2] floatValue];
			
			if ( red > 1.0 )
			{
				red = red / 255.0f;
			}
			if ( green > 1.0 )
			{
				green = green / 255.0f;
			}
			if ( blue > 1.0 )
			{
				blue = blue / 255.0f;
			}
			
			[arguments addObject:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
		}
	}

	return arguments;
}

- (NSArray *)argumentValues:(NSObject *)object forInvocation:(GVCInvocation *)invoker propertyName:(NSString *)propertyName
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(object);
					GVC_DBC_FACT_NOT_NIL(invoker);
					GVC_DBC_FACT_NOT_EMPTY(propertyName);
					)
	
	// implementation
	NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:10];
	
	// primary object is at index 2
	NSString *type = [invoker argumentTypeAtIndex:2];
	if ( [type hasPrefix:@"@"] == YES )
	{
		if ( [[propertyName lowercaseString] hasSuffix:@"color"] == YES )
		{
			NSArray *parsed = [self colorArgumentValues:object];
			if ( gvc_IsEmpty(parsed) == NO )
			{
				[arguments addObjectsFromArray:parsed];
			}
		}
		else if ( [[propertyName lowercaseString] hasSuffix:@"image"] == YES )
		{
			if ( [object isKindOfClass:[NSString class]] == YES)
			{
				[arguments addObject:[UIImage imageNamed:(NSString *)object]];
			}
			else if ([object isKindOfClass:[NSArray class]] == YES)
			{
				GVC_DBC_FACT_NOT_EMPTY(object);
				NSString *name = [(NSArray *)object objectAtIndex:0];
				[arguments addObject:[UIImage imageNamed:name]];
			}
			
			if ( [arguments count] < 2)
			{
				// needs 2 arguments
			}
			else if  ( [arguments count] < 3)
			{
				// needs 1 arguments
			}
		}
		else if ( [[propertyName lowercaseString] hasSuffix:@"font"] == YES )
		{
			if ([object isKindOfClass:[NSArray class]] == YES)
			{
				NSArray *array = (NSArray *)object;
				GVC_DBC_FACT([array count] == 2);

				NSString *name = [array objectAtIndex:0];
				CGFloat size = [[array objectAtIndex:1] floatValue];

				if ([name isEqualToString:@"system"] == YES)
				{
					[arguments addObject:[UIFont systemFontOfSize:size]];
				}
				else if ([name isEqualToString:@"bold"] == YES)
				{
					[arguments addObject:[UIFont boldSystemFontOfSize:size]];
				}
				else if ([name isEqualToString:@"italic"] == YES)
				{
					[arguments addObject:[UIFont italicSystemFontOfSize:size]];
				}
				else
				{
					[arguments addObject:[UIFont fontWithName:name size:size]];
				}
			}
			else if ([object isKindOfClass:[NSNumber class]] == YES)
			{
				CGFloat size = [(NSNumber *)object floatValue];
				[arguments addObject:[UIFont systemFontOfSize:size]];
			}
		}
		else if ( [[propertyName lowercaseString] hasSuffix:@"textattributes"] == YES )
		{
			// this can result in multiple invocations
			GVCLogDebug(@"%@ %@", propertyName, object);
		}
	}
	
	GVC_DBC_ENSURE(
//				   GVC_DBC_FACT_NOT_EMPTY(arguments);
				   )
	
	return arguments;
}

- (id <UIAppearance>)appearanceForStackContext:(GVCStack *)stack
{
	NSMutableArray *containers = [[stack allObjects] mutableCopy];
	Class appearanceClass = [containers lastObject];
	[containers removeLastObject];
	
	id <UIAppearance> target = nil;
	switch ([containers count])
	{
		case 0:
			target = [appearanceClass appearance];
			break;

		case 1:
			target = [appearanceClass appearanceWhenContainedIn:[containers objectAtIndex:0], nil];
			break;

		case 2:
			target = [appearanceClass appearanceWhenContainedIn:[containers objectAtIndex:0], [containers objectAtIndex:1], nil];
			break;

		case 3:
			target = [appearanceClass appearanceWhenContainedIn:[containers objectAtIndex:0], [containers objectAtIndex:1], [containers objectAtIndex:2], nil];
			break;

		case 4:
			target = [appearanceClass appearanceWhenContainedIn:[containers objectAtIndex:0], [containers objectAtIndex:1], [containers objectAtIndex:2], [containers objectAtIndex:3], nil];
			break;

		case 5:
			target = [appearanceClass appearanceWhenContainedIn:[containers objectAtIndex:0], [containers objectAtIndex:1], [containers objectAtIndex:2], [containers objectAtIndex:3], [containers objectAtIndex:4],nil];
			break;

		default:
			break;
	}

	return target;
}

@end
