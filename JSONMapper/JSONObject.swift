//
//  JSONObject.swift
//  JSONMapper
//
//  Created by Tomek Cejner on 08/07/14.
//  Copyright (c) 2014 Tomek Cejner. All rights reserved.
//

import Foundation

protocol JSONSerializable {
    
    init(_ c:JSONDeserializationContext)
    //func _deserialize(c:JSONDeserializationContext)
    
}

class JSONDeserializationContext {
    
    var source:NSDictionary
    
    init(source:NSDictionary) {
        self.source = source
    }
    
    func getString(field:String) -> String? {
        return self.source[field] as String?
    }
    
    func getInt(field:String) -> Int? {
        return self.source[field] as Int?
    }
    
    func getObject<T:JSONSerializable>(field:String, ofClass:T.Type) -> T {
        return ofClass(JSONDeserializationContext(source:source[field] as NSDictionary))
    }
    
}

class JSONMapper {
    class func context(data:NSData) -> JSONDeserializationContext {
        println(data)

        var err:NSErrorPointer?
        var error : NSError?
        // TODO use error pointer
        // Resolve for returning null scenario
        let obj:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        switch (obj) {
            // TODO support arrays as top-level objects
            case let dic as NSDictionary:
                return JSONDeserializationContext(source: dic)
            default:
                return JSONDeserializationContext(source: NSDictionary.dictionary())
        }
    }
    
    class func toObject(data:NSStream) {
        
    }
    
}


/**
 *
 */
class JSONObject {

    init(c:JSONDeserializationContext) {
        
    }
    
    
    // Override this
    func _deserialize(c:JSONDeserializationContext) {
        
    }
    
}