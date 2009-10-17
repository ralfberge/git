//
//  XMLTree.h
//  SoundShaker
//
//  Created by Nils on 01.01.70.
//  Copyright 1970 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GlobalStrings.h>

/*!
    @class		 XMLNode
    @abstract    (Describes one node of an XMLTree object.)
    @discussion  (This object is used by an XMLTree to setup a whole XML tree structure. The rootnode (wich has no parent) contains all other nodes. The rootnode is the first Element found in an XML-file.)
*/
@interface XMLNode : NSObject {
	NSString *			mName;
	NSDictionary *		mAttributes;
	NSMutableArray *	mNodes;
	XMLNode *			mParentNode;
}

- (void)addSubNode:(NSString *)name withAttributes:(NSDictionary *)attributes;
- (void)insertSubNode:(NSString *)name 
	    withAttributes:(NSDictionary *)attributes 
	    atIndex:(UInt32)index;
- (void)moveSubNode:(UInt32)subNodeIndex toIndex:(UInt32)index;
- (void)removeSubNode:(UInt32)subNodeIndex;

- (XMLNode *)node:(UInt32)index;
- (XMLNode *)nodeByName:(NSString *)nodeName;

- (NSString *)attributeValue:(NSString *)attributeName;
- (void)setValue:(NSString *)valueString toAttribute:(NSString *)attributeName;
- (NSString *)xmlString;

- (BOOL)hasChildren;
- (UInt32)count;

// *** ACCESSORS ***
- (NSString *)name;
- (void)setName:(NSString *)name;
- (NSDictionary *)attributes;
- (void)setAttributes:(NSDictionary *)attributes;
- (XMLNode *)parentNode;
- (void)setParentNode:(XMLNode *)parentNode;

@end



/*!
    @class			XMLTree
    @abstract		(Manages an XML Tree-structure)
    @discussion		(Represents XML data as tree-structure. It can be created at runtime or be initialized with an XML file. XMLTree has ONE rootnode. The rootnode is the first element (e.g <rootelement attributes="0"></rootnode>) found in the document. Once an XMLTree has been setup, it can be manipulated as you wish.)
*/
@interface XMLTree : NSObject {
	XMLNode *	mRootNode;
	XMLNode *	mCurrentNode;
}

- (id)initWithXMLFile:(NSString *)filePath;
- (void)saveToFile:(NSString *)filePath existingFile:(BOOL)overwrite;


// *** ACCESSORS ***
- (XMLNode *)rootNode;

@end
