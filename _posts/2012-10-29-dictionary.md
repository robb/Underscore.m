---
title:    NSDictionary
category: documentation
---

### NSDictionary

The following methods can be used with `NSDictionary` and `NSMutableDictionary`
instances. With Underscore.m's dictionary methods can use a functional-style
syntax as well as chaining to create powerful expressions.

#### dict `_.dict(NSDictionary *dictionary)`

Wraps a dictionary in an `USDictionaryWrapper`. Use this method if you want to
chain multiple operations together. You will need to call `unwrap` to extract
the result.

{% highlight objectivec %}
NSDictionary *user = Underscore.dict(data)
    .rejectValues(Underscore.isNull)
    .defaults(@{
        @"avatar":          kDefaultAvatar,
        @"backgroundColor": kDefaultBackgroundColor
    })
    .unwrap;
{% endhighlight %}

Since `dict` is meant for chaining, you probably don't need to keep a
reference to the `USDictionaryWrapper`.

#### unwrap `wrapper.unwrap`

Extracts the dictionary of an `USDictionaryWrapper`.

#### keys `_.keys(NSDictionary *dictionary)`

Returns the keys of a dictionary.

{% highlight objectivec %}
NSArray *keys = Underscore.keys(dictionary);
{% endhighlight %}

When called on a `USDictionaryWrapper`, it returns a `USArrayWrapper` to
facilitate chaining.

{% highlight objectivec %}
id key = Underscore.dict(dictionary)
    .keys
    .first;
{% endhighlight %}

#### values `_.values(NSDictionary *dictionary)`

Returns the values of a dictionary.

{% highlight objectivec %}
NSArray *values = Underscore.values(dictionary);
{% endhighlight %}

When called on a `USDictionaryWrapper`, it returns a `USArrayWrapper` to
facilitate chaining.

{% highlight objectivec %}
id value = Underscore.dict(dictionary)
    .values
    .first;
{% endhighlight %}

#### each     `wrapper.each(UnderscoreDictionaryIteratorBlock block)`

#### dictEach `_.each(NSDictionary *dictionary, UnderscoreDictionaryIteratorBlock block)`

Calls `block` once with every key-value pair of the dictionary.
This method returns the same dictionary again, to facilitate chaining.

Functional syntax:

{% highlight objectivec %}
Underscore.dictEach(dictionary, ^(id key, id obj) {
    NSLog(@"%@: %@", key, obj);
});
{% endhighlight %}

Chaining:

{% highlight objectivec %}
Underscore.dict(objects)
    .each(^(id key, id obj) {
        NSLog(@"%@: %@", key, obj);
    });
{% endhighlight %}

#### map     `wrapper.map(UnderscoreDictionaryMapBlock block)`

#### dictMap `_.map(NSDictionary *dictionary, UnderscoreDictionaryMapBlock block)`

Calls `block` once with every key-value pair of he dictionary.
If the block returns `nil`, the key-value-pair is removed from the dictionary.
Otherwise, the return-value replaces the value.

Functional syntax:

{% highlight objectivec %}
Underscore.dictMap(dictionary, ^(id key, id obj) {
    if ([obj isKindOfClass:NSString.class]) {
        return [(NSString *)obj capitalizedString]
    } else {
        return obj;
    }
}
});
{% endhighlight %}

Chaining:

{% highlight objectivec %}
Underscore.dict(dictionary)
    .map(^(id key, id obj) {
        if ([obj isKindOfClass:NSString.class]) {
            return [(NSString *)obj capitalizedString]
        } else {
            return obj;
        }
    });
{% endhighlight %}

#### pick `_.pick(NSDictionary *dictionary, NSArray *keys)`

Returns a copy of `dictionary` that contains only the keys contained in `keys`.

{% highlight objectivec %}
NSDictionary *subset = Underscore.pick(info, @[ @"name", @"email", @"address" ]);
{% endhighlight %}

#### extend `_.extend(NSDictionary *destination, NSDictionary *source)`

Returns a dictionary that contains a union of key-value-pairs of `destination`
and `source`. Key-value-pairs of `source` will have precedence over those taken
from `destination`.

{% highlight objectivec %}
NSDictionary *dictionary = Underscore.extend(user, @{ @"age": @50 });
{% endhighlight %}

#### defaults `_.defaults(NSDictionary *dictionary, NSDictionary *defaults)`

Returns a dictionary that contains a union of key-value-pairs of `dictionary`
and `defaults`. Key-value-pairs of `destination` will have precedence over those
taken from `defaults`.

{% highlight objectivec %}
NSDictionary *dictionary = Underscore.defaults(user, @{ @"avatar": kDefaultAvatar });
{% endhighlight %}

A common use case for `defaults` is sanitizing data with sane defaults.

{% highlight objectivec %}
NSDictionary *user = Underscore.dict(data)
    .rejectValues(Underscore.isNull)
    .defaults(@{
        @"avatar":          kDefaultAvatar,
        @"backgroundColor": kDefaultBackgroundColor
    })
    .unwrap;
{% endhighlight %}

#### filterKeys `_.filterKeys(NSDictionary *dictionary, UnderscoreTestBlock test)`

Returns a dictionary that only contains the key-value-pairs whose keys pass
`test`.

{% highlight objectivec %}
NSDictionary *soundcloudRelated = Underscore.filterKeys(data, ^BOOL (NSString *key) {
    return [key hasPrefix:@"soundcloud-"];
});
{% endhighlight %}

#### filterObjects `_.filterObjects(NSDictionary *dictionary, UnderscoreTestBlock test)`

Returns a dictionary that only contains the key-value-pairse whose values pass
`test`.

{% highlight objectivec %}
NSDictionary *numericValues = Underscore.filterObjects(data, Underscore.isNumber);
{% endhighlight %}

#### rejectKeys `_.rejectKeys(NSDictionary *dictionary, UnderscoreTestBlock test)`

Returns a dictionary that only contains the key-value-pairs whose keys fail
`test`.

{% highlight objectivec %}
NSDictionary *safe = Underscore.rejectKeys(data, ^BOOL (NSString *key) {
    return [blackList containsObject:key];
});
{% endhighlight %}

#### rejectObjects `_.rejectObjects(NSDictionary *dictionary, UnderscoreTestBlock test)`

Returns a dictionary that only contains the key-value-pairs whose values fail
`test`.

{% highlight objectivec %}
NSDictionary *noNulls = Underscore.rejectKeys(data, Underscore.isNull);
{% endhighlight %}
