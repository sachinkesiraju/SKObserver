# SKObserver
Every iOS dev makes a KVO wrapper at some point, here's mine. <br>
SKObserver is an NSObject category that provides a cleaner block based syntax for observing key value changes.

<h2> Setup </h2>
Simply drag and drop the NSObject+SKObserver files into your project and `#import "NSObject+SKObserver.h"` and you're 💯.

<h2> Implementation </h2>
To start observing changes to an object, call the method `sk_addObserverForKeyPath:withBlock:` on your object as follows. The block will return a dictionary containing the changes on the object.
```
[object sk_addObserverForKeyPath:@"keyPath" withBlock:^(NSDictionary <NSKeyValueChangeKey, id>  *change)
{
   NSLog(@"Change %@", change);
}];
```

To stop all observers from listening to changes on the object 
```
[object sk_removeAllObservers];
```

In addition, to remove a specfic observer on the object
```
id observer = [object sk_addObserverForKeyPath:@"keyPath" withBlock:^(NSDictionary <NSKeyValueChangeKey, id>  *change)
{
   NSLog(@"Change %@", change);
}];
//when done observing
[object sk_removeObserver:observer];
```

And that's it! No more long and messy 'observeValueForKeyPath' methods.

<h2> Community </h2>
If you found an issue or would like to improve SKObserver feel free to raise an issue/submit a PR. You can also reach out to me on Twitter <a href="https://twitter.com/_sachink"> @_sachink </a>

For reference on how KVO works, I encourage you to check out this <a href="http://nshipster.com/key-value-observing/"> post </a> before diving into this library.

<h2> License </h2>
SKObserver is available under the MIT License. Check out the <a href = https://github.com/sachinkesiraju/SKObserver/blob/master/LICENSE>LICENSE</a> for more information.
