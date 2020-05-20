//
//  ResourceCache.swift
//  
//
//  Created by Mathew Polzin on 5/19/20.
//

import JSONAPI

public protocol ResourceCache {}

public typealias ResourceHash<E: JSONAPI.IdentifiableResourceObjectType> = [E.Id: E]

public protocol Materializable {
    associatedtype ResourceCacheType: ResourceCache
    associatedtype IdentifiableType: JSONAPI.IdentifiableResourceObjectType where IdentifiableType.Description == Self

    static var cachePath: WritableKeyPath<ResourceCacheType, ResourceHash<IdentifiableType>> { get }
}

extension ResourceCache {
    public subscript<T: JSONAPI.ResourceObjectProxy>(id: T.Id) -> T? where T.Description: Materializable, T.Description.IdentifiableType == T, T.Description.ResourceCacheType == Self {
        get {
            return self[keyPath: T.Description.cachePath][id]
        }
        set {
            self[keyPath: T.Description.cachePath][id] = newValue
        }
    }

    public mutating func upsert<T: JSONAPI.ResourceObjectProxy>(_ resource: T) where T.Description: Materializable, T.Description.IdentifiableType == T, T.Description.ResourceCacheType == Self {
        self[resource.id] = resource
    }

    public mutating func upsert<T: JSONAPI.ResourceObjectProxy>(_ resources: [T]) where T.Description: Materializable, T.Description.IdentifiableType == T, T.Description.ResourceCacheType == Self {
        for resource in resources {
            upsert(resource)
        }
    }
}

extension JSONAPI.Id where
    IdentifiableType: JSONAPI.ResourceObjectProxy,
    IdentifiableType.Description: Materializable,
    IdentifiableType.Description.IdentifiableType == IdentifiableType,
    IdentifiableType.Description.IdentifiableType.EntityRawIdType == RawType {

    public func materialize(from cache: IdentifiableType.Description.ResourceCacheType) -> Self.IdentifiableType? {
        return cache[keyPath: Self.IdentifiableType.Description.cachePath][self]
    }
}
