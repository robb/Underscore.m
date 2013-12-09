//
//  UnderscoreSpec.m
//  Underscore
//
//  Created by Vasco d'Orey on 16/11/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "Underscore+Strings.h"

static NSString *stringWithLeadingWhitespace = @"       underscore strings will be pretty useful";
static NSString *stringWithTrailingWhitespace = @"underscore strings will be pretty useful       ";
static NSString *stringWithWhitespaceInTheMiddle = @"underscore    strings     will   be      pretty     useful";
static NSString *stringWithCrazyWhitespace = @"     underscore        strings          will      be     pretty          useful                   ";
static NSString *stringWithoutWhitespace = @"underscorestringswillbeprettyuseful";
static NSString *goodString = @"underscore strings will be pretty useful";
static NSString *onlyWhitespaceString = @"                               ";
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
    
    it(@"should work with whitespace in the middle of the string", ^{
        expect(Underscore.string(stringWithWhitespaceInTheMiddle).trim().unwrap).equal(goodString);
        expect(Underscore.stringTrim(stringWithWhitespaceInTheMiddle)).to.equal(goodString);
    });
    
    it(@"should work with crazy whitespace", ^{
        expect(Underscore.string(stringWithCrazyWhitespace).trim().unwrap).equal(goodString);
        expect(Underscore.stringTrim(stringWithCrazyWhitespace)).to.equal(goodString);
    });
    
    it(@"should work without any whitespace", ^{
        expect(Underscore.string(stringWithoutWhitespace).trim().unwrap).equal(stringWithoutWhitespace);
        expect(Underscore.stringTrim(stringWithoutWhitespace)).to.equal(stringWithoutWhitespace);
    });
    
    it(@"should work with only whitespace", ^{
        expect(Underscore.string(onlyWhitespaceString).trim().unwrap).equal(emptyString);
        expect(Underscore.stringTrim(onlyWhitespaceString)).to.equal(emptyString);
    });
});

describe(@"capitalize: uppercase the first letter of a string.", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).capitalize()).to.beNil;
        expect(Underscore.stringCapitalize(nil)).to.beNil;
    });
});

describe(@"lowercase: make all characters in the string lowercase", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).lowercase()).to.beNil;
        expect(Underscore.stringLowercase(nil)).to.beNil;
    });
});

describe(@"uppercase: make all characters in the string uppercase", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).uppercase()).to.beNil;
        expect(Underscore.stringUppercase(nil)).to.beNil;
    });
});

describe(@"split: split the string into an array with the components separated by the given separator", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).split(nil)).to.beNil;
        expect(Underscore.stringSplit(nil, nil)).to.beNil;
    });
});

describe(@"join: joins the given array adding a whitespace character between each component", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.array(nil).join()).to.beNil;
        expect(Underscore.stringJoin(nil)).to.beNil;
    });
});

SpecEnd
