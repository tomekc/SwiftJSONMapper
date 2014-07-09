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
    
    func getBool(field:String) -> Bool? {
        return self.source[field] as Bool?
    }
    
    func getObject<T:JSONSerializable>(field:String, ofClass:T.Type) -> T {
        return ofClass(JSONDeserializationContext(source:source[field] as NSDictionary))
    }
    
    func getArray<T>(field:String) -> Array<T> {
        return source[field] as Array<T>
    }
    
}

class JSONMapper {
    class func context(data:NSData) -> JSONDeserializationContext {

        let obj:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
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
