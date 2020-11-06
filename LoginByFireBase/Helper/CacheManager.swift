//
//  CacheManager.swift
//  FirebaseDemo
//
//  Created by Jimmy on 2020/11/3.
//  Copyright © 2020 AppCoda. All rights reserved.
//
import Foundation
enum CacheConfiguration
{
    static let maxObjects = 100
    static let maxSize = 1024 * 1024 * 50 //50MB
}

final class CacheManager
{
    static let shared = CacheManager()
    static var cache:NSCache<NSString,AnyObject> =
        {
            let cache = NSCache<NSString,AnyObject>()
            cache.countLimit = CacheConfiguration.maxObjects
            cache.totalCostLimit = CacheConfiguration.maxSize
            return cache
        }()
    private init(){}
    
    func saveIntoCache(object: AnyObject, key: String)
    {
        CacheManager.cache.setObject(object, forKey: key as NSString)
    }
    
    func getFromCache(key: String) -> AnyObject?
    {
        return CacheManager.cache.object(forKey: key as NSString)
    }
}
