//
//  JBNAsciiTextView.m
//  HexView
//
//  Created by Jean-Baptiste Nahan on 23/09/10.
//  Copyright 2010-2014 Jean-Baptiste Nahan. All rights reserved.
//

#import "JBNAsciiTextView.h"
#import "JBNHexView.h"



@implementation JBNAsciiTextView

- (id)initWithFrame:(NSRect)frame {
	
	if(self=[super initWithFrame:frame]){
		lineHeight = [[[self textContainer] layoutManager] defaultLineHeightForFont:[NSFont fontWithName:FONTNAME size:FONTSIZE]];
		
		attributes = [[NSDictionary alloc] initWithObjectsAndKeys:[NSFont fontWithName:FONTNAME size:FONTSIZE], NSFontAttributeName, nil];
		//NSLog(@"attributes = %@", attributes);
		
		
		//largeur d'un caractère
		charWidth = [@"s" sizeWithAttributes:attributes].width;
		
		//largeur de l'espage d'affichage
		width = [self frame].size.width-10;
		//Nombre de caratère dans une ligne
		nbChar = (int)(width/(float)charWidth);
		
		//NSLog(@"frame = w=%f, c=%f, nb=%i", width, charWidth, nbChar);
		
		
		[self setFont:[NSFont fontWithName:FONTNAME size:FONTSIZE]];
		//[self setBackgroundColor:[NSUnarchiver unarchiveObjectWithData:[MTIDEDefault objectForKey:@"editBG"]]];
		//[self setTextColor:[NSUnarchiver unarchiveObjectWithData:[MTIDEDefault objectForKey:@"editText"]]];
		//[self setInsertionPointColor:[NSUnarchiver unarchiveObjectWithData:[MTIDEDefault objectForKey:@"editText"]]];
		[self setContinuousSpellCheckingEnabled:FALSE];
		[self setGrammarCheckingEnabled:FALSE];
		
		[self setVerticallyResizable:YES];
		[self setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
		[self setAutoresizingMask:NSViewWidthSizable];
		[self setAllowsUndo:YES];
		[self setUsesFindPanel:YES];
		[self setAllowsDocumentBackgroundColorChange:NO];
		[self setRichText:NO];
		[self setImportsGraphics:NO];
		[self setUsesFontPanel:NO];
		//NSLog(@"[[[self superview] superview] superview] = %@",[[[self superview] superview] superview]);
		//HexView * hv = [[[self superview] superview] superview];
		//[[[[self superview] superview] superview] addObserver:self forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:nil];
		[self setDelegate:self];
				
	}
	return self;
	
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	//NSLog(@"observeValueForKeyPath !");
	if([keyPath isEqualToString:@"data"]){
		[self refreshContent:object];
	}
	
	
	
}

- (void)refreshContent:(id)object{
	
	NSInteger location = [self convertedSelectedRange].location;
	//NSLog(@"Data has changed ! (%i)", location);
	NSData * d=[object data];
	NSString * s=@"";
	
	unsigned long max2 = [d length];
	unsigned long i;
	nbLine=0;
	int nbCharAdd=0;
	
	char car;
	
	for(i=0;i<max2;i++){
		nbCharAdd++;
		[d getBytes:&car range:NSMakeRange(i, 1)];
		if(![self isPrintableChar:car])
			s = [s stringByAppendingString:@"."];
		else s=[s stringByAppendingFormat:@"%c",car];
		if(nbCharAdd==nbChar){
			s = [s stringByAppendingString:@"\n"];
			nbCharAdd=0;
			nbLine++;
		}
		//if(location==i) location=location+line;
	}
	
	int delta = (int)(location/nbChar);
	
	//NSLog(@"Location = %i ; NB ligne = %i ; new location = %i", location, delta, location+delta);
	
	location = location+delta;
	//Vérifie si la position du curseur ne sort pas du texte
	if([s length]<location){
		//NSLog(@"Sélection Out of Bounds ! (%i)",[s length]);
		location=[s length];
	}
	[self setString:s];
	[self setSelectedRange:NSMakeRange(location, 0)];
	
	
	/* Déclache la mise à jour chez les autres */
	//[[[object hexScrollView] documentView] refreshContent:object];
	[[object hexAddress] updateLineNumbersCheckWidth:YES];
	[[object hexRepresentation] updateLineNumbersCheckWidth:NO];
	
	
}

- (void)setFrame:(NSRect)rect{
	[super setFrame:rect];
	
	//largeur de l'espage d'affichage
	width = [self frame].size.width-10;
	//Nombre de caratère dans une ligne
	nbChar = (int)(width/(float)charWidth);
	
	//NSLog(@"frame = w=%f, c=%f, nb=%i", width, charWidth, nbChar);
	
	[self refreshContent:[[[self superview] superview] superview]];
	
}


- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
	
    // Allow changes only for uncommitted text
	
	//NSLog(@"replacementString = %@",replacementString);
	NSRange r = [self convertedRange:affectedCharRange];
	
	//NSInteger location = r.location;
	JBNHexView * hv = (JBNHexView *)[[[self superview] superview] superview];
	NSMutableData * data = [[NSMutableData alloc] initWithData:[hv data]];
	
	NSData * insert = [replacementString dataUsingEncoding:NSUTF8StringEncoding];
	
	//unsigned char * aBuffer;
	//unsigned long len = [insert length] ;
	//aBuffer = malloc(len);
	
	//NSLog(@"Ajout de %i octet(s)", len);
	
	//[insert getBytes:aBuffer length:len];
	
	//[data replaceBytesInRange:r withBytes:aBuffer length:len];
    [data replaceBytesInRange:r withBytes:[insert bytes]];
	
	//Renvoie les donnée modifiées
	[hv setData:[[NSData alloc] initWithData:data]];
	
	//Supprime la sélection et la place avant la suppression
	[self setSelectedRange:NSMakeRange([self selectedRange].location+[insert length], 0)];
	
	//Libère la variable	
	//[data release];
	
	return false;
}


- (void)deleteForward:(id)sender{
	//NSLog(@"Suppr");
	
	NSRange r = [self convertedSelectedRange];
	JBNHexView * hv = (JBNHexView *)[[[self superview] superview] superview];
	NSMutableData * data = [[NSMutableData alloc] initWithData:[hv data]];
	
	//Ne fait rien si la position == longeur du texte
	if(r.location==[data length]) return;
	
	unsigned char * aBuffer;
	if(r.length==0) r=NSMakeRange(r.location, 1);
	
	[data replaceBytesInRange:r withBytes:aBuffer length:0];
	
	//Supprime la sélection et la place avant la suppression
	[self setSelectedRange:NSMakeRange([self selectedRange].location, 0)];
	
	//Renvoie les donnée modifiées
	[hv setData:[[NSData alloc] initWithData:data]];
	
	//Libère la variable	
	//[data release];
}

- (void)deleteBackward:(id)sender{
	//NSLog(@"Delete");
	
	NSRange r = [self convertedSelectedRange];
	//Ne supprime rien si la sélection est à zero et la location à 0
	if(r.length==0 && r.location==0) return;
	
	JBNHexView * hv = (JBNHexView *)[[[self superview] superview] superview];
	NSMutableData * data = [[NSMutableData alloc] initWithData:[hv data]];
	
	unsigned char * aBuffer;
	if(r.length==0) r=NSMakeRange(r.location-1, 1);
	
	[data replaceBytesInRange:r withBytes:aBuffer length:0];
	
	
	
	//Supprime la sélection et la place avant la suppression
	//NSLog(@"Localisation : %i ; New Localisation : %i", [self selectedRange].location, [self selectedRange].location-r.length);
	
	NSRange rnew = NSMakeRange([self selectedRange].location-r.length, 0);
	//Replace à zéro si la sélection est inférieur à zéro
	if([self selectedRange].location<r.length) rnew.location=0;
	//NSLog(@"New Position : %@", NSStringFromRange(rnew));
	[self setSelectedRange:rnew];
	
	//Renvoie les donnée modifiées
	[hv setData:[[NSData alloc] initWithData:data]];
	
	//Libère la variable	
	//[data release];
	
}

- (void)insertText:(NSString *)aString
{
	
	//NSLog(@"Insert Text : %X %@", [aString characterAtIndex:0], aString);
	NSRange r = [self convertedSelectedRange];
	
	JBNHexView * hv = (JBNHexView *)[[[self superview] superview] superview];
	//Récupère les données
	NSMutableData * data = [[NSMutableData alloc] initWithData:[hv data]];
	
	NSData * insert = [aString dataUsingEncoding:NSUTF8StringEncoding];
	
	unsigned char * aBuffer;
	unsigned long len = [insert length];
	aBuffer = malloc(len);
	
	//NSLog(@"Ajout de %i octet(s)", len);
	
	[insert getBytes:aBuffer length:len];
	
	[data replaceBytesInRange:r withBytes:aBuffer length:len];
    
	//[data replaceBytesInRange:r withBytes:insert.bytes];
	
	[hv setData:[[NSData alloc] initWithData:data]];
	
	//Supprime la sélection et la place après le texte inséré
	[self setSelectedRange:NSMakeRange([self selectedRange].location+[insert length], 0)];
	//Libère la variable	
	//[data release];
}


- (BOOL)isPrintableChar:(unichar)caratere{
	//NSLog(@"Char = %i , %02X", caratere, caratere);
	BOOL response = FALSE;
	//Caratère visible
	if(caratere>=32 && caratere<=126) response=TRUE;
	
	return response;
}


- (NSRange)convertedRange:(NSRange)r{
	
	unsigned long newLocation = 0;
	unsigned long newLength =0;
	
	//Récupère le texte entre le début et le curseur
	NSString * txt = [self string];
	//Texte avant le curseur
	NSString * txtBeforeCursor = [txt substringWithRange:NSMakeRange(0, r.location)];
	//Compter les retour à la ligne
	NSArray * exp = [txtBeforeCursor componentsSeparatedByString:@"\n"];
	//Corrige la position
	newLocation=r.location-([exp count]-1);
	//NSLog(@"\\n avant la sélection = %i ; Real Location %i ; New Position %i", [exp count]-1, r.location, newLocation);
	
	//Vérifie que dans la sélection il n'y pas de retour à la ligne compté
	if(r.length>0){
		NSString * selectedString = [txt substringWithRange:r];
		NSArray * exp2 = [selectedString componentsSeparatedByString:@"\n"];
		newLength = r.length-([exp2 count]-1);
		//NSLog(@"\\n dans la sélection = %i", [exp2 count]-1);
	}
	
	return NSMakeRange(newLocation, newLength);//;
}

- (NSRange)convertedSelectedRange{
	return [self convertedRange:[self selectedRange]];
}


- (int)getNbCharByLine{
	return nbChar;
}

- (int)getNbLine{
	return nbLine;
}

- (int)lineHeight{
	return lineHeight;
}

@end
