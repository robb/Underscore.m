# Underscore.m

## About Underscore.m

Underscore.m is an Objective-C library inspired by [underscore.js][js].

First, you wrap your `NSDictionary` and `NSArray` using the provided macros.

    // e.g.
    NSDictionary *dictionary = [NSDictionary dictionaryWithAllKindsOfStuff];
    USDictionary *wrapper    = _dict(dictionary);

Now, you can manipulate the dictionary using Underscore.m's various methods.
For each step, Underscore.m will create a copy of the data type, so you don't
have to worry about side effects.

    NSArray *capitalized = _dict(dictionary)
      .values
      .filter(Underscore.isString)
      .map(^NSString *(NSString *string) {
        return [string capitalizedString];
      })
      .unwrap;

## Real world example

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

[js]: documentcloud.github.com/underscore
