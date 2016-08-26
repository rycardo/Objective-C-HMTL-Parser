//
//  HTMLParser+Extend.h
//  4XQ LLC
//
//  Created by 4XQ LLC on 26-08-16.
//  Copyright (c) 2014 4XQ. All rights reserved.
//
//  Extended Ben Reeve's Objective-C-HTML-Parser

#import "HTMLParser.h"

@interface HTMLParser (Extend)

- (HTMLNode *)findChildInNodes:(NSArray *)nodes 
  withAttributesMatchingValues:(NSDictionary *)attributes 
                  allowPartial:(BOOL)partial;

- (NSArray *)findChildTagsOfNode:(HTMLNode *)node 
                     withTagName:(NSString *)tagName 
     andAttributesMatchingValues:(NSDictionary *)attributes 
                    allowPartial:(BOOL)partial;

- (NSArray *)findChildrenOfNode:(HTMLNode *)node 
   withAttributesMatchingValues:(NSDictionary *)attributes 
                   allowPartial:(BOOL)partial;
@end
