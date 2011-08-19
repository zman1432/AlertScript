#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <libactivator/libactivator.h>
#import <stdlib.h>

@interface AlertScript : NSObject<LAListener, UIAlertViewDelegate, UITextViewDelegate>
{ 
@private
  UIAlertView *av;
  UITextView *scriptField;
  NSString *script;
}
@end

@implementation AlertScript

- (BOOL)dismiss {
  if (av) {	  
    [av dismissWithClickedButtonIndex:[av cancelButtonIndex] animated:YES];
    [scriptField release];
    [script release];
    [av release];
    av = nil;
    return YES;
  } else {
    return NO;
  }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [av release];
    av = nil;
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
av = [[UIAlertView alloc] initWithTitle:@"AlertScript" message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Execute", nil];

scriptField = [[UITextView alloc] initWithFrame:CGRectMake(30, 40, 223, 92)];
scriptField.delegate = self;
scriptField.editable = YES;
scriptField.scrollEnabled = YES;
scriptField.autocorrectionType = UITextAutocorrectionTypeNo;
scriptField.autocapitalizationType = UITextAutocapitalizationTypeNone;

[av addSubview:scriptField];

[av show]; 

[event setHandled:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1)
  {
      script = scriptField.text;

      [script writeToFile:@"/var/mobile/Library/AlertScript/AlertScript" atomically:YES encoding:NSUTF8StringEncoding error:nil];
      system("AlertScriptMain >> /var/mobile/Library/AlertScript/stdlog.log 2>> /var/mobile/Library/AlertScript/stdlog.log");
      UIAlertView *pwnMessage = [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Your script has been executed." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
      [pwnMessage show];
      [av release];
      av = nil;
  }
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event
{
	[self dismiss];
}

- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event
{
	  [self dismiss];
}

- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event
{
	    if ([self dismiss])
	       [event setHandled:YES];	    
}

- (void)dealloc
{
	[scriptField release];
	[script release];
	[av release];
	[super dealloc];
	[super dealloc];
}

+ (void)load
{
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	  
[[LAActivator sharedInstance] registerListener:[self new] forName:@"com.fhsjaagshs.alertscript"];
[pool release];
}

@end