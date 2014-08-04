//
//  JSONObject.swift
//  JSONMapper
//
//  Created by Tomek Cejner on 08/07/14.
//  Copyright (c) 2014 Tomek Cejner. All rights reserved.
//

import Foundation

public protocol JSONSerializable {
    
    init(_ c:JSONDeserializationContext)
    
}

public class JSONDeserializationContext : BooleanType {
    
    var source:NSDictionary
    public var valid:Bool
    
    init(source:NSDictionary?) {
        if let dic = source {
            valid = true
            self.source = source!
        } else {
            valid = false
            self.source = NSDictionary.dictionary()
        }
    }

    public var boolValue : Bool {
        get {
            return valid
        }
    }
    
    public func getString(field:String) -> String? {
        return self.source[field] as String?
    }
    
    public func getInt(field:String) -> Int? {
        return self.source[field] as Int?
    }

    public func getFloat(field:String) -> Float? {
        return self.source[field] as Float?
    }
    
    public func getBool(field:String) -> Bool? {
        return self.source[field] as Bool?
    }
    
    public func getObject<T:JSONSerializable>(field:String, ofClass:T.Type) -> T? {
        if let dataField: AnyObject! = source[field] {
            return ofClass(JSONMapper.buildContext(dataField))            
        } else {
            return Optional<T>.None
        }
    }
    
    public func getArray<T>(field:String) -> Array<T> {
        if let nsarray = source[field] as? NSArray {
            var array: [T] = []
            for el in nsarray {
                if let typedElement = el as? T {
                    array.append(typedElement)
                }
            }
            return array

        } else {
            return []
        }
        
    }
    
}

public class JSONMapper {
    public class func context(data:NSData) -> JSONDeserializationContext {
        if let obj:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
            return buildContext(obj)
        } else {
            return buildContext([])
        }
    }
    
    public class func context(stream:NSInputStream) -> JSONDeserializationContext {
        let obj:AnyObject = NSJSONSerialization.JSONObjectWithStream(stream, options: nil, error: nil)
        return buildContext(obj)
    }
    

    class func buildContext(jsonObject:AnyObject) -> JSONDeserializationContext {
        switch (jsonObject) {
            // TODO support arrays as top-level objects
        case let dic as NSDictionary:
            return JSONDeserializationContext(source: dic)
        default:
            return JSONDeserializationContext(source: nil)
        }
        
    }
    
    
}
