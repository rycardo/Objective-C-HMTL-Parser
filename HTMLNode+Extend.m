//
//  HTMLNode+AddedFinds.m
//  BShopDeluxe
//
//  Created by Rycardo Cousteau on 18-01-14.
//  Copyright (c) 2014 4XQ. All rights reserved.
//

#import "HTMLNode+AddedFinds.h"

@implementation HTMLNode (AddedFinds)

- (HTMLNode *)findChildNodeWithMatchingAttributes:(NSDictionary *)attributes
                                allowPartialMatch:(BOOL)partial 
{
    NSArray *children = [self findChildNodesWithMatchingAttributes:attributes allowPartialMatch:partial];
    return [children firstObject];
}

- (NSArray *)findChildNodesWithMatchingAttributes:(NSDictionary *)attributes
                                allowPartialMatch:(BOOL)partial 
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    BOOL first = YES;
    
    for ( NSString *key in attributes ) 
    {
        NSString *value = [attributes valueForKey:key];
        
        NSArray *childrenArray = [self findChildrenWithAttribute:key 
                                                    matchingName:value 
                                                    allowPartial:partial];
        
        if ( first ) 
        {
            first = NO;
            [resultArray addObjectsFromArray:childrenArray];
        } 
        else 
        {
            for ( HTMLNode *node in resultArray ) 
            {
                if ( ![childrenArray containsObject:node] ) 
                {
                    [resultArray removeObject:node];
                }
            }
        }
    }
    
    return resultArray;
}

- (HTMLNode *)findChildTag:(NSString *)tagName 
                   ofClass:(NSString *)className 
         allowPartialMatch:(BOOL)partial 
{
    return [self findChildTag:tagName 
       withMatchingAttributes:[NSDictionary dictionaryWithObject:className forKey:@"class"] 
            allowPartialMatch:partial];
}

- (NSArray *)findChildTags:(NSString *)tagName 
                   ofClass:(NSString *)className 
         allowPartialMatch:(BOOL)partial 
{
    return [self findChildTags:tagName 
        withMatchingAttributes:[NSDictionary dictionaryWithObject:className forKey:@"class"] 
             allowPartialMatch:partial];
}

- (HTMLNode *)findChildTag:(NSString *)tagName
    withMatchingAttributes:(NSDictionary *)attributes
         allowPartialMatch:(BOOL)partial 
{
    NSArray *children = [self findChildTags:tagName 
                     withMatchingAttributes:attributes 
                          allowPartialMatch:partial];
    
    return [children firstObject];
}

- (NSArray *)findChildTags:(NSString *)tagName
    withMatchingAttributes:(NSDictionary *)attributes
              allowPartialMatch:(BOOL)partial 
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    // get all child tags
    NSArray *childTags = [self findChildTags:tagName];
    
    for ( HTMLNode *child in childTags ) 
    {
        BOOL allMatch = YES;
        
        for ( NSString *key in attributes ) 
        {
            NSString *value = [attributes objectForKey:key];
            
            NSString *childKeyValue = [child getAttributeNamed:key];
            if ( !childKeyValue ) 
            {
                childKeyValue = @"";
            }
            
            if ( partial ) 
            {
                NSRange range = [childKeyValue rangeOfString:value];
                if ( range.location == NSNotFound ) 
                {
                    allMatch = NO;
                    break;
                }
            } 
            else 
            {
                if ( ![value isEqualToString:childKeyValue] ) 
                {
                    allMatch = NO;
                    break;
                }
            }
        }
        
        if ( allMatch ) 
        {
            [resultArray addObject:child];
        }
    }
    
    return [resultArray copy];
}

- (NSArray *)findInputNodes 
{
    NSArray *inputNodes  = [self findChildTags:@"input"];
    NSArray *textNodes   = [self findChildTags:@"textarea"];
    NSArray *selectNodes = [self findChildTags:@"select"];
    
    NSMutableArray *nodes = [NSMutableArray arrayWithArray:inputNodes];
    [nodes addObjectsFromArray:textNodes];
    [nodes addObjectsFromArray:selectNodes];
    
    return nodes;
}

- (NSArray *)findInputNodesWithMatchingAttributes:(NSDictionary *)attributes
                                allowPartialMatch:(BOOL)partial 
{
    return [self findInputNodes];
}

- (HTMLNode *)findSelectedChild 
{
    HTMLNode *selected = [self findChildTag:@"option" 
                     withMatchingAttributes:[NSDictionary dictionaryWithObject:@"selected" forKey:@"selected"] 
                          allowPartialMatch:NO];
    
    return selected;
}

- (NSDictionary *)getNameAndValueAttributes 
{
    NSString *tagName = [self tagName];
    
    NSString *name;
    NSString *value;
    
    if ( [tagName isEqualToString:@"select"] ) 
    {
        HTMLNode *optionNode = [self findSelectedChild];
        
        name  = [self getAttributeNamed:@"name"];
        value = [optionNode getAttributeNamed:@"value"];
    } 
    else if ( [tagName isEqualToString:@"textarea"] ) 
    {
        name  = [self getAttributeNamed:@"name"];
        value = [self contents];
    } 
    else 
    {
        name  = [self getAttributeNamed:@"name"];
        value = [self getAttributeNamed:@"value"];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", value, @"value", nil];
}
@end
