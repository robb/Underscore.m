# Underscore.m

## About Underscore.m

Underscore.m is an Objective-C library inspired by [underscore.js][js].

First, you wrap your `NSDictionary` and `NSArray` using the provided macros.

    // e.g.
    NSDictionary *dictionary     = [NSDictionary dictionaryWithAllKindsOfStuff];
    USDictionaryWrapper *wrapper = _dict(dictionary);

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

[js]: http://documentcloud.github.com/underscore

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

## Documentation

### NSArray

_To facilitate chaining, all methods that return an array automatically wrap it._

- `first`  
  Returns the first element of the array or `nil` if it is empty.

- `last`  
  Returns the last element of the array or `nil` if it is empty

- `head(NSUInteger n)`  
  Returns the first `n` elements or all of them, if there are less than `n`
  elements in the array.  

- `tail(NSUInteger n)`  
  Returns the last `n` elements or all of them, if there are less than `n`
  elements in the array.  

- `flatten`  
  Flattens the array.  

- `without(NSArray *values)`  
  Returns all elements not contained in `values`.  

- `shuffle`  
  Returns a shuffled copy of the array.  

- `reduce(id memo, UnderscoreReduceBlock block)`
- `reduceRight(id memo, UnderscoreReduceBlock block)`  
  Reduces the array to a single value.

- `each(UnderscoreArrayIteratorBlock block)`  
  Calls `block` once with every element of the array.  
  Returns itself, this allows for better chaining.

- `map(UnderscoreArrayMapBlock block)`  
  Calls `block` once with every element of the array.  
  If the block returns `nil`, the object is removed from the array, otherwise
  the return-value replaces the object.

- `pluck(NSString *keyPath)`  
  Returns an array containing the objects' values for the for the given key
  path.

- `find(UnderscoreTestBlock test)`  
  Returns the first object in the array that passes the `test`.

- `filter(UnderscoreTestBlock test)`  
  Returns an array containing all the elements that pass the `test`.

- `reject(UnderscoreTestBlock test)`  
  Returns an array containing all the elements that fail the `test`.

- `all(UnderscoreTestBlock test)`  
  Returns `YES` if all of the elements pass the `test`.

- `any(UnderscoreTestBlock test)`  
  Returns `YES` if any of the elements pass the `test`.

### NSDictionary

_To facilitate chaining, all methods that return a dictionary automatically wrap it._

- `keys`  
  Returns a wrapped array containing all the dictionary's keys.

- `values`  
  Returns a wrapped array containing all the dictionary's values.

- `each(UnderscoreDictionaryIteratorBlock block)`  
  Calls `block` once with every key-value-pair of the dictionary.  
  Returns itself, this allows for better chaining.

- `map(UnderscoreDictionaryMapBlock block)`  
  Calls `block` once with every key-value-pair of the dictionary.  
  If the block returns `nil`, the key-value-pair is removed from the array,
  otherwise the return-value replaces the value.

- `pick(NSArray *keys)`  
  Returns a dictionary that only contains the keys contained in `keys`.

- `extend(NSDictionary *source)`  
  Returns a dictionary that by copying over keys and values from `source`.
  Keys and values will be overwritten.

- `defaults(NSDictionary *defaults)`  
  Returns a dictionary that by copying over keys and values from `defaults`.
  Keys and values will __not__ be overwritten.

- `filterKeys(UnderscoreTestBlock test)`  
  Returns a dictionary that only contains the key-value-pairs whose keys pass
  the `test`.

- `filterValues(UnderscoreTestBlock test)`  
  Returns a dictionary that only contains the key-value-pairs whose values pass
  the `test`.

- `rejectKeys(UnderscoreTestBlock block)`  
  Returns a dictionary that only contains the key-value-pairs whose keys fail
  the `test`.

- `rejectValues(UnderscoreTestBlock block)`  
  Returns a dictionary that only contains the key-value-pairs whose values fail
  the `test`.

### etc.

_Convenient helpers, these are all class methods of `Underscore`_

- `negate(UnderscoreTestBlock block)`  
  Negates the `block` it is passed.

- `isEqual(id obj)`  
  Returns a block that returns `YES` whenever it is called with an object equal
  to `obj`.

- `isArray`  
  A block that returns `YES` if it is called with an NSArray.

- `isDictionary`  
  A block that returns `YES` if it is called with an NSDictionary.

- `isNull`  
  A block that returns `YES` if it is called with an NSNull.

- `isNumber`  
  A block that returns `YES` if it is called with an NSNumber.

- `isString`  
  A block that returns `YES` if it is called with an NSString.
