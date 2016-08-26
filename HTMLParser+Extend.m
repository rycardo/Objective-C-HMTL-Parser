//
//  HTMLParser+Extend.m
//  4XQ LLC
//
//  Created by 4XQ LLC on 26-08-16.
//  Copyright (c) 2014 4XQ. All rights reserved.
//
//  Extended Ben Reeve's Objective-C-HTML-Parser

#import "HTMLParser+Extend.h"

@implementation HTMLParser (Extend)

- (HTMLNode *)findChildInNodes:(NSArray *)nodes 
  withAttributesMatchingValues:(NSDictionary *)attributes 
                  allowPartial:(BOOL)partial 
{
	for ( HTMLNode *node in nodes ) 
	{
		NSArray *foundNodes = [self findChildrenOfNode:node 
                          WithAttributesMatchingValues:attributes 
                                          allowPartial:partial];
		
		if ( [foundNodes count] ) 
		{
			return [foundNodes firstObject];
		}
	}
	return nil;
}

- (NSArray *)findChildTagsOfNode:(HTMLNode *)node 
                     withTagName:(NSString *)tagName 
     andAttributesMatchingValues:(NSDictionary *)attributes 
                    allowPartial:(BOOL)partial 
{
	NSMutableArray *returnTags = [[node findChildTags:tagName] mutableCopy];
	
	[returnTags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
	{
		HTMLNode *tagNode = (HTMLNode *)obj;
		
		for ( NSString *key in attributes ) 
		{
			NSString *value = [attributes objectForKey:key];
			
			if ( !partial ) 
			{
				if ( ![[tagNode getAttributeNamed:key] isEqualToString:value] ) 
				{
					[returnTags removeObject:obj];
				}
			} 
			else 
			{
				NSRange range = [[tagNode getAttributeNamed:key] rangeOfString:value];
				if ( range.location == NSNotFound ) 
				{
					[returnTags removeObject:obj];
				}
			}
		}
	}];
	
	return returnTags;
}

- (NSArray *)findChildrenOfNode:(HTMLNode *)node 
   withAttributesMatchingValues:(NSDictionary *)attributes 
                   allowPartial:(BOOL)partial 
{
	BOOL first = YES;
	
	NSMutableArray *returnNodes = [NSMutableArray array];
	
	for ( NSString *key in attributes ) 
	{
		NSString *value = [attributes objectForKey:key];
		
		NSArray *nodes = [node findChildrenWithAttribute:key
                                            matchingName:value
                                            allowPartial:partial];
		
		if ( first ) 
		{
			first = NO;
			[returnNodes addObjectsFromArray:nodes];
		} 
		else 
		{
			[returnNodes enumerateObjectsUsingBlock:^(id node, NSUInteger index, BOOL *stop) 
			{
				if ( ![nodes containsObject:node] ) 
				{
					// if nodes does not contain a node from returnNodes
					// remove node from returnNodes
					[returnNodes removeObject:node];
				}
			}];
		}
	}
	return returnNodes;
}

@end
