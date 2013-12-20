//
//  UnderscoreSpec.m
//  Underscore
//
//  Created by Vasco d'Orey on 16/11/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "Underscore+Strings.h"

SpecBegin(UnderscoreStrings)

describe(@"trim: get rid of unneccessary whitespace characters.", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).trim().unwrap).to.beNil;
        expect(Underscore.stringTrim(nil)).to.beNil;
    });
    
    it(@"should work with empty strings", ^{
        expect(Underscore.string(@"").trim().unwrap).to.equal(@"");
        expect(Underscore.stringTrim(@"")).to.equal(@"");
    });
    
    it(@"should work with leading whitespace", ^{
        expect(Underscore.string(@" underscore strings will be pretty useful").trim().unwrap).to.equal(@"underscore strings will be pretty useful");
        expect(Underscore.stringTrim(@" underscore strings will be pretty useful")).to.equal(@"underscore strings will be pretty useful");
    });
    
    it(@"should work with trailing whitespace", ^{
        expect(Underscore.string(@"underscore strings will be pretty useful ").trim().unwrap).to.equal(@"underscore strings will be pretty useful");
        expect(Underscore.stringTrim(@"underscore strings will be pretty useful ")).to.equal(@"underscore strings will be pretty useful");
    });
    
    it(@"should work without any whitespace", ^{
        expect(Underscore.string(@"underscore").trim().unwrap).to.equal(@"underscore");
        expect(Underscore.stringTrim(@"underscore")).to.equal(@"underscore");
    });
    
    it(@"should work with only whitespace", ^{
        expect(Underscore.string(@"   ").trim().unwrap).to.equal(@" ");
        expect(Underscore.stringTrim(@"   ")).to.equal(@" ");
        expect(Underscore.string(@"  ").trim().unwrap).to.equal(@"");
        expect(Underscore.stringTrim(@"  ")).to.equal(@"");
        expect(Underscore.string(@" ").trim().unwrap).to.equal(@"");
        expect(Underscore.stringTrim(@" ")).to.equal(@"");
    });
});

describe(@"capitalize: uppercase the first letter of a string.", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).capitalize().unwrap).to.beNil;
        expect(Underscore.stringCapitalize(nil)).to.beNil;
    });
    
    it(@"should work with empty strings", ^{
        expect(Underscore.string(@"").capitalize().unwrap).to.equal(@"");
        expect(Underscore.stringCapitalize(@"")).to.equal(@"");
    });
    
    it(@"should behave with lowercase strings", ^{
        expect(Underscore.string(@"hello").capitalize().unwrap).to.equal(@"Hello");
        expect(Underscore.stringCapitalize(@"hello")).to.equal(@"Hello");
    });
    
    it(@"should behave with capitalized strings", ^{
        expect(Underscore.string(@"Hello There").capitalize().unwrap).to.equal(@"Hello There");
        expect(Underscore.stringCapitalize(@"Hello There")).to.equal(@"Hello There");
    });
    
    it(@"should behave with uppercase strings", ^{
        expect(Underscore.string(@"HELLO THERE").capitalize().unwrap).to.equal(@"Hello There");
        expect(Underscore.stringCapitalize(@"HELLO THERE")).to.equal(@"Hello There");
    });
    
    it(@"should keep whitespace intact", ^{
        expect(Underscore.string(@"       HELLO THERE How are you").capitalize().unwrap).to.equal(@"       Hello There How Are You");
        expect(Underscore.stringCapitalize(@"       HELLO THERE How are you")).to.equal(@"       Hello There How Are You");
    });
});

describe(@"lowercase: make all characters in the string lowercase", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).lowercase()).to.beNil;
        expect(Underscore.stringLowercase(nil)).to.beNil;
    });
    
    it(@"should work with empty strings", ^{
        expect(Underscore.string(@"").lowercase().unwrap).to.equal(@"");
        expect(Underscore.stringLowercase(@"")).to.equal(@"");
    });
    
    it(@"should behave with lowercase strings", ^{
        expect(Underscore.string(@"hello").lowercase().unwrap).to.equal(@"hello");
        expect(Underscore.stringLowercase(@"hello")).to.equal(@"hello");
    });
    
    it(@"should behave with capitalized strings", ^{
        expect(Underscore.string(@"Hello There").lowercase().unwrap).to.equal(@"hello there");
        expect(Underscore.stringLowercase(@"Hello There")).to.equal(@"hello there");
    });
    
    it(@"should behave with uppercase strings", ^{
        expect(Underscore.string(@"HELLO THERE").lowercase().unwrap).to.equal(@"hello there");
        expect(Underscore.stringLowercase(@"HELLO THERE")).to.equal(@"hello there");
    });
    
    it(@"should keep whitespace intact", ^{
        expect(Underscore.string(@"       HELLO THERE How are you").lowercase().unwrap).to.equal(@"       hello there how are you");
        expect(Underscore.stringLowercase(@"       HELLO THERE How are you")).to.equal(@"       hello there how are you");
    });
});

describe(@"uppercase: make all characters in the string uppercase", ^{
    it(@"should behave with nil", ^{
        expect(Underscore.string(nil).uppercase()).to.beNil;
        expect(Underscore.stringUppercase(nil)).to.beNil;
    });
    
    it(@"should work with empty strings", ^{
        expect(Underscore.string(@"").uppercase().unwrap).to.equal(@"");
        expect(Underscore.stringUppercase(@"")).to.equal(@"");
    });
    
    it(@"should behave with lowercase strings", ^{
        expect(Underscore.string(@"hello").uppercase().unwrap).to.equal(@"HELLO");
        expect(Underscore.stringUppercase(@"hello")).to.equal(@"HELLO");
    });
    
    it(@"should behave with capitalized strings", ^{
        expect(Underscore.string(@"Hello There").uppercase().unwrap).to.equal(@"HELLO THERE");
        expect(Underscore.stringUppercase(@"Hello There")).to.equal(@"HELLO THERE");
    });
    
    it(@"should behave with uppercase strings", ^{
        expect(Underscore.string(@"HELLO THERE").uppercase().unwrap).to.equal(@"HELLO THERE");
        expect(Underscore.stringUppercase(@"HELLO THERE")).to.equal(@"HELLO THERE");
    });
    
    it(@"should keep whitespace intact", ^{
        expect(Underscore.string(@"       HELLO THERE How are you").uppercase().unwrap).to.equal(@"       HELLO THERE HOW ARE YOU");
        expect(Underscore.stringUppercase(@"       HELLO THERE How are you")).to.equal(@"       HELLO THERE HOW ARE YOU");
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
