# Underscore.m

## About Underscore.m

Underscore.m is a small utility library to facilitate working with common data structures in Objective-C.  
It tries to encourage chaining by eschewing the square bracket]]]]]].  
It is inspired by the awesome [underscore.js][js].

[js]: http://documentcloud.github.com/underscore

## Real world example

```objective-c
// First, let's compose a twitter search request
NSURL *twitterSearch = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=@SoundCloud&rpp=100"];

// ... then we fetch us some json ...
NSData *data = [NSData dataWithContentsOfURL:twitterSearch];

// ... and parse it.
NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                     options:kNilOptions
                                                       error:NULL];

// This is where the fun starts!
NSArray *tweets = [json valueForKey:@"results"];

NSArray *processed = _array(tweets)
    // Let's make sure that we only operate on NSDictionaries, you never
    // know with these APIs ;-)
    .filter(Underscore.isDictionary)
    // Remove all tweets that are in English
    .reject(^BOOL (NSDictionary *tweet) {
        return [[tweet valueForKey:@"iso_language_code"] isEqualToString:@"en"];
    })
    // Create a simple string representation for every tweet
    .map(^NSString *(NSDictionary *tweet) {
        NSString *name = [tweet valueForKey:@"from_user_name"];
        NSString *text = [tweet valueForKey:@"text"];

        return [NSString stringWithFormat:@"%@: %@", name, text];
    })
    .unwrap;
```

## Documentation

Documentation for Underscore.m can be found on [the website](http://underscorem.org).
