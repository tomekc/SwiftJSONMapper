//
//  JSONMapper_OSXTests.swift
//  JSONMapper-OSXTests
//
//  Created by Tomek on 27.07.2014.
//  Copyright (c) 2014 Tomek Cejner. All rights reserved.
//

import Cocoa
import XCTest
import JSONMapper

class JSONMapper_OSXTests: XCTestCase {
    
    var data : NSData?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        data = loadFromFile("example")
        
    }
    
    func loadFromFile(name:String) -> NSData? {
        let filepath = NSBundle(forClass: JSONMapper_OSXTests.self).pathForResource(name, ofType: "json")
        return NSData(contentsOfFile:filepath!, options: nil, error: nil)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    class Address : JSONSerializable {
        var city : String?
        var state : String?
        
        required init(_ c: JSONDeserializationContext) {
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
        var active : Bool?
        var roles : Array<String>
        var rating : Float?
        
        required init(_ c: JSONDeserializationContext)  {
            self.name = c.getString("name")
            self.id = c.getInt("id")
            self.address = c.getObject("address", ofClass: Address.self)
            self.active = c.getBool("active")
            self.roles = c.getArray("roles")
            self.rating = c.getFloat("rating")
        }
    }
    
    func testSimple() {
        
        let object = Person(JSONMapper.context(data!))
        
        XCTAssertEqual(object.name!, "John Appleseed", "String field don't match")
        XCTAssertEqual(object.id!, 9001, "Integer field don't match")
        XCTAssertEqual(object.active!, true, "Boolean don't match")
//        XCTAssertEqual(object.rating!, 3.5, "Float don't match")    
    }
    
    func testNestedObject() {
        let object = Person(JSONMapper.context(data!))
        let state = object.address?.state
        
        XCTAssertEqual(state!, "CA", "State in nested object do not match")
        
    }
    
    func testArray() {
        let object = Person(JSONMapper.context(data!))
        let tab = object.roles
        
        // ["ADMINISTRATOR","EMPLOYEE"]
        //        XCTAssertEqual(tab.count, 2, "Arrays don't match")
        //        XCTAssertEqual(tab[0], "ADMINISTRATOR")
        //        XCTAssertEqual(tab[1], "EMPLOYEE")
    }
    
    func testIncomplete() {
        let dataIncomplete = loadFromFile("example-incomplete")
        let object = Person(JSONMapper.context(dataIncomplete!))
        
        XCTAssertEqual(object.id!, 9001)
        XCTAssert( object.name == .None, "Name should be blank")
        XCTAssertNil( object.address, "Nested object should be blank")
        XCTAssertEqual(object.roles.count, 0)
        
    }
    
    func testMalformedJSON() {
        let dataMalformed = loadFromFile("example-invalid")
        let context = JSONMapper.context(dataMalformed!)
        let person = Person(context)
        
        XCTAssertFalse(context)
        XCTAssertFalse(context.valid)
        XCTAssert(person.name == .None, "Person should be non-blank")
        XCTAssertNil( person.address, "Nested object should be blank")
        XCTAssertEqual(person.roles.count, 0)
        
    }

    
}
