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
    
    var data : NSData?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let filepath = NSBundle(forClass: JSONMapperTests.self).pathForResource("example", ofType: "json")
        data = NSData.dataWithContentsOfFile(filepath, options: nil, error: nil)

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
        
    class Address : JSONSerializable {
        var city : String?
        var state : String?
        
        @required init(_ c: JSONDeserializationContext) {
            println("Initializing Address with ")
            println(c)
            self.city = c.getString("city")
            self.state = c.getString("state")
        }
    }
    
    class Person : JSONSerializable {
        var name : String?
        var id : Int?
        var address : Address?
        
        init(_ c: JSONDeserializationContext)  {
            self.name = c.getString("name")
            self.id = c.getInt("id")
            self.address = c.getObject("address", ofClass: Address.self)
        }
    }
    
    func testSimple() {
        
        let object = Person(JSONMapper.context(data!))
        
        XCTAssertEqual(object.name!, "John Appleseed", "String field not match")
        let state = object.address?.state
        
        XCTAssertEqual(state!, "CA", "State in nested object do not match")
        println("ADDRESS")
        println (object.address?.state?)
    
    }
    
    func testNestedObject() {
        
    }
    
}
