//
//  XMLTree.m
//
//  Created by Nils on 25.06.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "XMLTree.h"


@implementation XMLNode


// initializes the node
- (id)init {
	self = [super init];
	
	mName = nil;
	mAttributes = nil;
	mNodes = nil;
	mParentNode = nil;
	
	return self;
}


/*!
    @method     - (void)addSubNode:(NSString *)name withAttributes:(NSDictionary *)attributes
    @abstract   (Add a subnode to this node)
    @discussion (Adds a subnode to the receiver (this node) with the name given in "name" and the attributes given in "attributes" (may be nil))
*/
- (void)addSubNode:(NSString *)name withAttributes:(NSDictionary *)attributes {
	// var
	// begin
	if ( !mNodes ) mNodes = [NSMutableArray new];
	[ [mNodes addObject:[XMLNode new]] autorelease ];
	[ (XMLNode *)[mNodes lastObject] setName:name ];
	[ (XMLNode *)[mNodes lastObject] setAttributes:attributes ];
	[ (XMLNode *)[mNodes lastObject] setParentNode:self ];
}


- (void)insertSubNode:(NSString *)name 
	withAttributes:(NSDictionary *)attributes 
	atIndex:(UInt32)index
{
// var
	UInt32	i = 0;
	
// bgein
	if (mNodes) {
		[ [mNodes insertObject:[XMLNode new] atIndex:index] autorelease];
		[ [self node:index] setName:name ];
		[ [self node:index] setAttributes:attributes ];
		[ [self node:index] setParentNode:self ];
	}
}


- (void)moveSubNode:(UInt32)subNodeIndex toIndex:(UInt32)index {
// var
	XMLNode *	subNodeCopy = [ [[self node:subNodeIndex] copy] autorelease ];
	
// begin
	[ self removeSubNode:subNodeIndex ];
	[ self insertSubNode:[subNodeCopy name] 
		   withAttributes:[subNodeCopy attributes] 
		   atIndex:index
	];
}


// Removes the direct subnode (and all it's subnodes) at the given index
- (void)removeSubNode:(UInt32)index {
// var
// begin
	if ( index < [self count] )
		[mNodes removeObjectAtIndex:index];
}


/*!
    @method     - (XMLNode *)node:(UInt32)index
    @abstract   (Returns the direct sub node with the given index.)
    @discussion (Returns the direct sub node with the index "index". Returns nil if no node was found)
*/
- (XMLNode *)node:(UInt32)index {
	if (index < [mNodes count]) {
		return [mNodes objectAtIndex:index];
	} else {
		return nil;
	}
}


/*!
    @method     - (XMLNode *)nodeByName:(NSString *)nodeName
    @abstract   (Returns the first sub node with the given name)
    @discussion (Returns the first found direct (!) sub node with the name "nodeName". Returns nil if no node is found.)
*/
- (XMLNode *)nodeByName:(NSString *)nodeName {
// var
	UInt32		i = 0;
	XMLNode *	result = nil;
	
// begin
	while ( (i < [self count]) && 
			(![ [[self node:i] name] isEqualToString:nodeName]) ) 
	{
		i++;
	}
	
	if ( [self node:i] && 
		 [[[self node:i] name] isEqualToString:nodeName] ) 
	{
		result = [self node:i];
	}

	return result;
}


/*!
    @method     - (NSString *)xmlString
    @abstract   (Returns the String for the node and sub nodes)
    @discussion (The resulting string is an XML string of the receiver (the node) and all of it's sub nodes)
*/
- (NSString *)xmlString {
// var
	NSMutableString *		result = [NSMutableString stringWithString:@""];
	NSMutableString *		attributes = [NSMutableString stringWithString:@""];
	NSArray *		attribKeys = nil;
	UInt32			i = 0;
	
// begin
	if ([self parentNode]) [result appendString:@"\t"];
	if ( mAttributes && ([mAttributes count] > 0) ) {
		attribKeys = [mAttributes allKeys];
		for (i = 0; i < [attribKeys count]; i++) {
			[ attributes appendFormat:@" %@=\"%@\"", 
						 [attribKeys objectAtIndex:i], 
						 [mAttributes objectForKey:[attribKeys objectAtIndex:i]]
			];
		}
	} 
	if ( [self hasChildren] ) {
		[result appendFormat:@"<%@%@>\n", mName, attributes];
		for (i = 0; i < [mNodes count]; i++) {
			[ result appendString:[[mNodes objectAtIndex:i] xmlString] ];
		}
		[result appendFormat:@"</%@>\n", mName];
	} else {
		[result appendFormat:@"<%@%@ />\n", mName, attributes];
	}
	
	return result;
}


// Returns the Number of direct sub nodes from this node
- (UInt32)count {
	if ( !mNodes ) {
		return 0;
	} else {
		return [mNodes count];
	}
}


// If the node has sub nodes returns YES, otherwise NO.
- (BOOL)hasChildren {
	return [self count] > 0;
}


// Get the Value for the Node's (Element's) Attribute
- (NSString *)attributeValue:(NSString *)attributeName {
	return [mAttributes valueForKey:attributeName];
}

// Set the Value for the Node's (Element's) Attribute.
// If the Attribute doesn't exist, it is created.
- (void)setValue:(NSString *)valueString toAttribute:(NSString *)attributeName {
	[mAttributes setValue:valueString forKey:attributeName];
}


- (void)dealloc {
	if ([self hasChildren]) {
		[mNodes release];
//		while ( [mNodes count] > 0 )
//			[ [mNodes lastObject] release ];
//		[mNodes removeLastObject];
	}
	
//	[ super release ];	
}


// *** ACCESSORS ***
- (NSString *)name {
	return mName;
}

- (void)setName:(NSString *)name {
	mName = [name copy];
}

- (NSDictionary *)attributes {
	return mAttributes;
}

- (void)setAttributes:(NSDictionary *)attributes {
	mAttributes = [attributes copy];
}

- (XMLNode *) parentNode {
	return mParentNode;
}

- (void)setParentNode:(XMLNode *)parentNode {
	mParentNode = parentNode;
}

@end



// *** IMPLEMENTATION OF XMLTree ***

@implementation XMLTree

- (id)init {
	self = [super init];

	mRootNode = [XMLNode new];
	mCurrentNode = nil;

	return self;
}


- (id)initWithXMLFile:(NSString *)filePath {
// var
	BOOL			success = NO;
	NSURL *			xmlURL = nil;
	NSXMLParser	*	parser = nil;

// begin
	self = [self init];
	
	// Grow up XML tree		
	if ( [[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByExpandingTildeInPath]] ) {
		xmlURL = [ NSURL fileURLWithPath:[filePath stringByExpandingTildeInPath] ];
		parser = [ [NSXMLParser alloc] initWithContentsOfURL:xmlURL ];
		if (parser) {
			[parser setDelegate:self];
			success = [parser parse];
		}
	}
	
	[parser release];
	
	if ( !success ) {
		[self release];
		self = nil;
	}
	
	return self;
}


- (void)saveToFile:(NSString *)filePath existingFile:(BOOL)overwrite {
// var
	NSMutableString *		xmlData = [NSMutableString stringWithString:
													   @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\n"];
	
// begin
	if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath] && (overwrite) ) {
		[ [NSFileManager defaultManager] removeFileAtPath:filePath handler:nil ];
	}
	[xmlData appendString:[mRootNode xmlString]];
	[xmlData writeToFile:filePath atomically:YES];
}


// *** XML EVENTS ***
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog ([NSString stringWithString:[[parser parserError] localizedDescription]]);
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
// var
	
// begin
	if ( mCurrentNode == nil ) { // Create root element (first element)
		if ( !mRootNode ) mRootNode = [XMLNode new];
		mCurrentNode = mRootNode;
		[ mCurrentNode setName:elementName ];
		[ mCurrentNode setAttributes:attributeDict ];
	} else {
		[mCurrentNode addSubNode:elementName withAttributes:attributeDict];
		mCurrentNode = [ mCurrentNode node:[mCurrentNode count] -1 ];
	}
}

- (void)parser:(NSXMLParser *)parser 
	didEndElement:(NSString *)elementName 
	namespaceURI:(NSString *)namespaceURI 
	qualifiedName:(NSString *)qName 
{
	mCurrentNode = [mCurrentNode parentNode];
}


- (void)dealloc {
	[mRootNode release];
}


// *** ACCESSORS ***
- (XMLNode *)rootNode {
	return mRootNode;
}


@end
