//
//  UnderscoreSpec.m
//  Underscore
//
//  Created by Vasco d'Orey on 16/11/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "Underscore+Strings.h"

static NSString *stringWithLeadingWhitespace = @" underscore strings will be pretty useful";
static NSString *stringWithTrailingWhitespace = @"underscore strings will be pretty useful ";
static NSString *stringWithoutWhitespace = @"underscorestringswillbeprettyuseful";
static NSString *goodString = @"underscore strings will be pretty useful";
static NSString *onlyWhitespaceString = @"                               ";
static NSString *trimmedWhitespaceString = @"                             ";
static NSString *emptyString = @"";

SpecBegin(UnderscoreStrings)

describe(@"trim: get rid of unneccessary whitespace characters.", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).trim().unwrap).to.beNil;
        expect(Underscore.stringTrim(nil)).to.beNil;
    });
    
    it(@"should work with leading whitespace", ^{
        expect(Underscore.string(stringWithLeadingWhitespace).trim().unwrap).to.equal(goodString);
        expect(Underscore.stringTrim(stringWithLeadingWhitespace)).to.equal(goodString);
    });
    
    it(@"should work with trailing whitespace", ^{
        expect(Underscore.string(stringWithTrailingWhitespace).trim().unwrap).to.equal(goodString);
        expect(Underscore.stringTrim(stringWithTrailingWhitespace)).to.equal(goodString);
    });
    
    it(@"should work without any whitespace", ^{
        expect(Underscore.string(stringWithoutWhitespace).trim().unwrap).to.equal(stringWithoutWhitespace);
        expect(Underscore.stringTrim(stringWithoutWhitespace)).to.equal(stringWithoutWhitespace);
    });
    
    it(@"should work with only whitespace", ^{
        expect(Underscore.string(onlyWhitespaceString).trim().unwrap).to.equal(trimmedWhitespaceString);
        expect(Underscore.stringTrim(onlyWhitespaceString)).to.equal(trimmedWhitespaceString);
    });
});

static NSString *uncapitalized = @"hello";
static NSString *allCaps = @"HELLO";
static NSString *capitalized = @"Hello";
static NSString *multipleUncaps = @"hello there";
static NSString *multipleCapitalized = @"Hello There";

describe(@"capitalize: uppercase the first letter of a string.", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).capitalize().unwrap).to.beNil;
        expect(Underscore.stringCapitalize(nil)).to.beNil;
    });
    
    it(@"should behave with lowercase strings", ^{
        expect(Underscore.string(uncapitalized).capitalize().unwrap).to.equal(capitalized);
        expect(Underscore.stringCapitalize(uncapitalized)).to.equal(capitalized);
    });
    
    it(@"should behave with capitalized strings", ^{
        expect(Underscore.string(capitalized).capitalize().unwrap).to.equal(capitalized);
        expect(Underscore.stringCapitalize(capitalized)).to.equal(capitalized);
    });
    
    it(@"should behave with uppercase strings", ^{
        expect(Underscore.string(allCaps).capitalize().unwrap).to.equal(capitalized);
        expect(Underscore.stringCapitalize(allCaps)).to.equal(capitalized);
    });
    
    it(@"should keep whitespace intact", ^{
        expect(@(Underscore.string(stringWithLeadingWhitespace).capitalize().unwrap.length)).to.equal(@(stringWithLeadingWhitespace.length));
        expect(@(Underscore.stringCapitalize(stringWithLeadingWhitespace).length)).to.equal(@(stringWithLeadingWhitespace.length));
    });
});

describe(@"lowercase: make all characters in the string lowercase", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).lowercase()).to.beNil;
        expect(Underscore.stringLowercase(nil)).to.beNil;
    });
    
    it(@"should behave with lowercase strings", ^{
        expect(Underscore.string(uncapitalized).lowercase().unwrap).to.equal(uncapitalized);
        expect(Underscore.stringLowercase(uncapitalized)).to.equal(uncapitalized);
    });
    
    it(@"should behave with capitalized strings", ^{
        expect(Underscore.string(capitalized).lowercase().unwrap).to.equal(uncapitalized);
        expect(Underscore.stringLowercase(capitalized)).to.equal(uncapitalized);
    });
    
    it(@"should behave with uppercase strings", ^{
        expect(Underscore.string(allCaps).lowercase().unwrap).to.equal(uncapitalized);
        expect(Underscore.stringLowercase(allCaps)).to.equal(uncapitalized);
    });
    
    it(@"should keep whitespace intact", ^{
        expect(@(Underscore.string(stringWithLeadingWhitespace).lowercase().unwrap.length)).to.equal(@(stringWithLeadingWhitespace.length));
        expect(@(Underscore.stringLowercase(stringWithLeadingWhitespace).length)).to.equal(@(stringWithLeadingWhitespace.length));
    });
});

describe(@"uppercase: make all characters in the string uppercase", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).uppercase()).to.beNil;
        expect(Underscore.stringUppercase(nil)).to.beNil;
    });
    
    it(@"should behave with lowercase strings", ^{
        expect(Underscore.string(uncapitalized).uppercase().unwrap).to.equal(allCaps);
        expect(Underscore.stringUppercase(uncapitalized)).to.equal(allCaps);
    });
    
    it(@"should behave with capitalized strings", ^{
        expect(Underscore.string(capitalized).uppercase().unwrap).to.equal(allCaps);
        expect(Underscore.stringUppercase(capitalized)).to.equal(allCaps);
    });
    
    it(@"should behave with uppercase strings", ^{
        expect(Underscore.string(allCaps).uppercase().unwrap).to.equal(allCaps);
        expect(Underscore.stringUppercase(allCaps)).to.equal(allCaps);
    });
    
    it(@"should keep whitespace intact", ^{
        expect(@(Underscore.string(stringWithLeadingWhitespace).uppercase().unwrap.length)).to.equal(@(stringWithLeadingWhitespace.length));
        expect(@(Underscore.stringUppercase(stringWithLeadingWhitespace).length)).to.equal(@(stringWithLeadingWhitespace.length));
    });
});

describe(@"split: split the string into an array with the components separated by the spaces", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).split(nil).unwrap).to.beNil;
        expect(Underscore.stringSplit(nil)).to.beNil;
    });
});

describe(@"splitAt: split the string into an array with the components separated by the given string", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).splitAt(nil)).to.beNil;
        expect(Underscore.stringSplitAt(nil, nil)).to.beNil;
    });
});

describe(@"join: joins the given array adding a whitespace character between each component", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.array(nil).join()).to.beNil;
        expect(Underscore.stringJoin(nil)).to.beNil;
    });
});

SpecEnd
