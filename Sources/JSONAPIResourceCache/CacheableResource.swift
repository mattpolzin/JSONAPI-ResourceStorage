//
//  CacheableResource.swift
//  
//
//  Created by Mathew Polzin on 5/20/20.
//

import JSONAPI

public protocol CacheableResource {
    associatedtype Cache: ResourceCache

    func cache(in cache: inout Cache)
}

extension JSONAPI.ResourceObject: CacheableResource where
    Description: Materializable,
    Description.IdentifiableType == Self {

    public func cache(in cache: inout Description.ResourceCacheType) {
        cache.upsert(self)
    }
}
