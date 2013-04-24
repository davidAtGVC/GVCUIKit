/*
 * GVCXMLFormSectionModel.m
 * 
 * Created by David Aspinall on 2013-04-24. 
 * Copyright (c) 2013 __MyCompanyName__. All rights reserved.
 *
 */

#import "GVCXMLFormSectionModel.h"
#import "GVCXMLFormLabelModel.h"
#import "GVCXMLFormQuestionModel.h"


@interface GVCXMLFormSectionModel ()

@end

@implementation GVCXMLFormSectionModel

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
	}
	
    return self;
}

- (void)addTitle:(GVCXMLFormLabelModel *)title;
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(title);
					GVC_DBC_FACT_NOT_EMPTY([title language]);
					)
	
	// implementation
	if ( [self titleDictionary] == nil )
	{
		[self setTitleDictionary:[[NSMutableDictionary alloc] init]];
	}
	
	
	[[self titleDictionary] setObject:title forKey:[title language]];
	
	GVC_DBC_ENSURE(
				   GVC_DBC_FACT_NOT_EMPTY([self titleDictionary]);
				   )
}

- (NSArray *)titleLanguages
{
	return [[self titleDictionary] allKeys];
}

- (NSString *)titleForLanguage:(NSString *)lang
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_EMPTY(lang);
					)
	
	NSString *title = nil;
	// implementation
	if ( [self titleDictionary] != nil )
	{
		GVCXMLFormLabelModel *label = [[self titleDictionary] objectForKey:lang];
		if ( label == nil )
		{
			label = [[self titleDictionary] objectForKey:GVCXMLFormLabelModel_DEFAULT_LANG];
		}
		
		if ( label != nil)
		{
			title = [label textContent];
		}
	}
	
	GVC_DBC_ENSURE(
	)
	return title;
}

- (void)addQuestion:(GVCXMLFormQuestionModel *)question;
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(question);
					)
	
	// implementation
	if ( [self questionArray] == nil )
	{
		[self setQuestionArray:[[NSMutableArray alloc] init]];
	}
	[[self questionArray] addObject:question];
	
	GVC_DBC_ENSURE(
				   GVC_DBC_FACT_NOT_EMPTY([self questionArray]);
				   )
}

- (void)writeForm:(GVCXMLGenerator *)outputGenerator
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_EMPTY([self nodeName]);
					GVC_DBC_FACT_NOT_NIL(outputGenerator);
					)
	
	// implementation
	[outputGenerator openElement:[self nodeName]];
	for (GVCXMLFormLabelModel *label in [[self titleDictionary] allValues])
	{
		[label writeForm:outputGenerator];
	}
	for (GVCXMLFormQuestionModel *question in [self questionArray])
	{
		[question writeForm:outputGenerator];
	}

	[outputGenerator closeElement];
	
	GVC_DBC_ENSURE(
	)
}


/** GVC Form Protocol */
- (NSString *)sectionTitle
{
	return [self titleForLanguage:@"en"];
}

- (void)setSectionTitle:(NSString *)sectionTitle
{
	
}

/**
 * an array of the GVCFormEntry = GVCFormQuestion/GVCFormOptionalGroup
 */
- (NSArray *)entryArray
{
	return [self questionArray];
}

- (NSArray *)entriesPassingAllConditions:(id <GVCFormSubmission>)submission
{
	return [self questionArray];
}

- (id <GVCFormQuestion>)questionForKeyword:(NSString *)keyword
{
	id <GVCFormQuestion> question = nil;
	for ( id <GVCFormEntry> entry in [self entryArray])
	{
		if ( [entry conformsToProtocol:@protocol(GVCFormQuestion)] == YES)
		{
			if ( [[(id <GVCFormQuestion>)entry keyword] isEqualToString:keyword] == YES )
			{
				question = (id <GVCFormQuestion>)entry;
				break;
			}
		}
	}
	
	return question;
}


@end
