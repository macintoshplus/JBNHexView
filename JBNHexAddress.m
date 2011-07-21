//
//  JBNHexAddress.m
//  HexView
//
//  Created by Jean-Baptiste Nahan on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JBNHexAddress.h"


@implementation JBNHexAddress

- (id)init{
	return [self initWithView:nil];
}


- (id)initWithView:(id)doc{
	if(self=[super init]){
		zeroPoint = NSMakePoint(0, 0);
		document = doc;
		attributes = [[NSDictionary alloc] initWithObjectsAndKeys:[NSFont fontWithName:@"Courier" size:11], NSFontAttributeName, nil];
		
	}
	return self;
}

- (void)viewBoundsDidChange:(NSNotification *)notification
{
	//NSLog(@"viewBoundsDidChange !");
	if (notification != nil && [notification object] != nil && [[notification object] isKindOfClass:[NSClipView class]]) {
		[self updateLineNumbersForClipView:[notification object] checkWidth:YES];
	}
}


- (void)updateLineNumbersCheckWidth:(BOOL)checkWidth{
	[self updateLineNumbersForClipView:[[document valueForKey:@"asciiScrollView"] contentView] checkWidth:checkWidth];
}


- (void)updateLineNumbersForClipView:(NSClipView *)clipView checkWidth:(BOOL)checkWidth{
	textView = [clipView documentView];
	
	int nbCharByLine = [textView getNbCharByLine];
	
	scrollView = (NSScrollView *)[clipView superview];
	addToScrollPoint = 0;	
	gutterScrollView = [document valueForKey:@"gutterScrollView"];
	//NSLog(@"UpdateLine : gutterScrollView = %@",gutterScrollView);
	
	layoutManager = [textView layoutManager];
	//Récupère la zone visible
	visibleRect = [[scrollView contentView] documentVisibleRect];
	//Récupère les coordonnée du texte visible
	visibleRange = [layoutManager glyphRangeForBoundingRect:visibleRect inTextContainer:[textView textContainer]];
	//Récupère tout le texte
	textString = [textView string];
	//Récupère le texte avant la zone visible
	searchString = [textString substringWithRange:NSMakeRange(0,visibleRange.location)];
	
	//Calcul du nombre de ligne
	for (index = 0, lineNumber = 0; index < visibleRange.location; lineNumber++) {
		index = NSMaxRange([searchString lineRangeForRange:NSMakeRange(index, 0)]);
	}
	
	indexNonWrap = [searchString lineRangeForRange:NSMakeRange(index, 0)].location;
	maxRangeVisibleRange = NSMaxRange([textString lineRangeForRange:NSMakeRange(NSMaxRange(visibleRange), 0)]); // Set it to just after the last glyph on the last visible line 
	numberOfGlyphsInTextString = [layoutManager numberOfGlyphs];
	oneMoreTime = NO;
	if (numberOfGlyphsInTextString != 0) {
		lastGlyph = [textString characterAtIndex:numberOfGlyphsInTextString - 1];
		if (lastGlyph == '\n' || lastGlyph == '\r') {
			oneMoreTime = YES; // Continue one more time through the loop if the last glyph isn't newline
		}
	}
	NSMutableString *lineNumbersString = [[NSMutableString alloc] init];
	
	while (indexNonWrap <= maxRangeVisibleRange) {
		if (index == indexNonWrap) {
			lineNumber++;
			[lineNumbersString appendFormat:@"%06X\n", (lineNumber-1)*nbCharByLine];
		} else {
			[lineNumbersString appendFormat:@"%C\n", 0x00B7];
			indexNonWrap = index;
		}
		
		if (index < maxRangeVisibleRange) {
			[layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&range];
			index = NSMaxRange(range);
			indexNonWrap = NSMaxRange([textString lineRangeForRange:NSMakeRange(indexNonWrap, 0)]);
		} else {
			index++;
			indexNonWrap ++;
		}
		
		if (index == numberOfGlyphsInTextString && !oneMoreTime) {
			break;
		}
	}
	
	[[gutterScrollView documentView] setString:lineNumbersString];
	
	[[gutterScrollView contentView] setBoundsOrigin:zeroPoint]; // To avert an occasional bug which makes the line numbers disappear
	currentLineHeight = (NSInteger)[textView lineHeight];
	if ((NSInteger)visibleRect.origin.y != 0 && currentLineHeight != 0) {
		[[gutterScrollView contentView] scrollToPoint:NSMakePoint(0, ((NSInteger)visibleRect.origin.y % currentLineHeight) + addToScrollPoint)]; // Move currentGutterScrollView so it aligns with the rows in currentTextView
	}
	
}


@end
