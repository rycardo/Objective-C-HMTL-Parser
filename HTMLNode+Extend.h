//
//  HTMLNode+Extend.h
//  4XQ LLC
//
//  Created by 4XQ LLC on 26-08-16.
//  Copyright (c) 2014 4XQ. All rights reserved.
//
//  Extended Ben Reeve's Objective-C-HTML-Parser

#import "HTMLNode.h"

@interface HTMLNode (Extend)
- (HTMLNode *)findChildNodeWithMatchingAttributes:(NSDictionary *)attributes
                                allowPartialMatch:(BOOL)partial;

- (NSArray *)findChildNodesWithMatchingAttributes:(NSDictionary *)attributes
                                allowPartialMatch:(BOOL)partial;

- (HTMLNode *)findChildTag:(NSString *)tagName
                   ofClass:(NSString *)className
         allowPartialMatch:(BOOL)partial;

- (NSArray *)findChildTags:(NSString *)tagName
                   ofClass:(NSString *)className
         allowPartialMatch:(BOOL)partial;

- (HTMLNode *)findChildTag:(NSString *)tagName
    withMatchingAttributes:(NSDictionary *)attributes
         allowPartialMatch:(BOOL)partial;

- (NSArray *)findChildTags:(NSString *)tagName
    withMatchingAttributes:(NSDictionary *)attributes
         allowPartialMatch:(BOOL)partial;

- (NSArray *)findInputNodes;

- (HTMLNode *)findSelectedChild;

- (NSDictionary *)getNameAndValueAttributes;
@end
