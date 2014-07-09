//
//  JSONMapperTests.swift
//  JSONMapperTests
//
//  Created by Tomek Cejner on 08/07/14.
//  Copyright (c) 2014 Tomek Cejner. All rights reserved.
//

import XCTest
import JSONMapper

class JSONMapperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    class TrivialObject : JSONSerializable {
        var foo : String
        
        init(c: JSONDeserializationContext) {
            self.foo = c.getString("foo")
//            super.init(c: c)
        }
    }
    
    
    class Person : JSONSerializable {
        var name : String
        
        init(c: JSONDeserializationContext)  {
            self.name = c.getString("name")
        }
    }
    
    func testSimple() {
        let json = " { \"foo\" : \"bar\"  }"
//        let data : NSData = (json as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    
        
        let filepath = NSBundle(forClass: JSONMapperTests.self).pathForResource("example", ofType: "json")
        let data : NSData = NSData.dataWithContentsOfFile(filepath, options: nil, error: nil)
        
        let object = Person(c:JSONMapper.context(data))
        
        XCTAssertEqual(object.name, "John Appleseed", "String field not match")
    
    }
    
}
