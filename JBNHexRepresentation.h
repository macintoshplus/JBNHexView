//
//  JBNHexRepresentation.h
//  HexView
//
//  Created by Jean-Baptiste Nahan on 24/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JBNAsciiTextView.h"


@interface JBNHexRepresentation : NSObject {
	id document;
	
	//textView
	JBNAsciiTextView * textView;
	
	NSPoint zeroPoint;
	NSDictionary *attributes;
	
	NSScrollView *scrollView;
	NSScrollView *hexScrollView;
	NSLayoutManager *layoutManager;
	NSRect visibleRect;
	NSRange visibleRange;
	NSString *textString;
	NSString *searchString;
	
	NSInteger index;
	NSInteger lineNumber;
	
	NSInteger indexNonWrap;
	NSInteger maxRangeVisibleRange;
	NSInteger numberOfGlyphsInTextString;
	BOOL oneMoreTime;
	unichar lastGlyph;
	
	NSRange range;
	NSInteger widthOfStringInGutter;
	NSInteger gutterWidth;
	NSRect currentViewBounds;
	NSInteger gutterY;
	
	NSInteger currentLineHeight;
	
	CGFloat addToScrollPoint;
	
}


- (id)initWithView:(id)doc;
- (void)updateLineNumbersCheckWidth:(BOOL)checkWidth;
- (void)updateLineNumbersForClipView:(NSClipView *)clipView checkWidth:(BOOL)checkWidth;


@end
