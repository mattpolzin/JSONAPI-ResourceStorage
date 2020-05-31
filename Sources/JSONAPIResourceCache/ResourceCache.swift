//
//  ResourceCache.swift
//  
//
//  Created by Mathew Polzin on 5/19/20.
//

import JSONAPI

/// A `Dictionary` of `ResourceObjects` keyed by their Ids.
public typealias ResourceHash<E: JSONAPI.IdentifiableResourceObjectType> = [E.Id: E]

/// A type that defines dictionaries
/// for each type of resource it can cache.
///
/// This structure can really be anything that exposes properties of type `ResourceHash`.
/// Then, a `ResourceObjectDescription` points to the correct hash in its `Materializable`
/// conformance.
///
/// It is recommended that you make this type `Equatable` because that is a lot of the power of this
/// value-type driven approach.
/// ```
/// typealias Dog = JSONAPI.ResourceObject<...>
/// typealias Cat = JSONAPI.ResourceObject<...>
///
/// struct Cache: ResourceCache {
///     var dogs: ResourceHash<Dog>
///     var cats: ResourceHash<Cat>
/// }
/// ```
public protocol ResourceCache {
    init()
}

/// A `ResourceObjectDescription` can be made `Materializable`
/// to make it more ergonomic to retrieve values of that resource type from
/// a cache when you have (a) an Id for the resource and (b) the cache.
///
/// ```
/// enum DogDescription: JSONAPI.ResourceObjectDescription {
///     ...
/// }
///
/// typealias Dog = JSONAPI.ResourceObject<DogDescription, ...>
///
/// struct Cache: ResourceCache {
///     var dogs: ResourceHash<Dog>
/// }
///
/// extension DogDescription: Materializable {
///     static var cachePath: WritableKeyPath<Cache, ResourceHash<Dog>> { \.dogs }
/// }
///
/// // Wherever you have a Dog.Id and Cache...
/// let dogId: Dog.Id = ...
/// let cache: Cache = ...
///
/// let dog = dogId.materialize(from: cache)
/// // equivalently: dog = cache[dogId]
/// ```
public protocol Materializable {
    associatedtype ResourceCacheType: ResourceCache
    associatedtype IdentifiableType: JSONAPI.IdentifiableResourceObjectType where IdentifiableType.Description == Self

    /// The key path pointing to a dictionary of resources of the
    /// given type keyed by their Ids.
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

    /// Update or insert (upsert) the given resource.
    public mutating func upsert<T: JSONAPI.ResourceObjectProxy>(_ resource: T) where T.Description: Materializable, T.Description.IdentifiableType == T, T.Description.ResourceCacheType == Self {
        self[resource.id] = resource
    }

    /// Update or insert (upsert) the given resources.
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

    public func materialized(from cache: IdentifiableType.Description.ResourceCacheType) -> Self.IdentifiableType? {
        return cache[keyPath: Self.IdentifiableType.Description.cachePath][self]
    }
}

extension EncodableJSONAPIDocument where
    BodyData.PrimaryResourceBody: SingleResourceBodyProtocol,
    BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    BodyData.IncludeType: CacheableResource,
    BodyData.PrimaryResourceBody.PrimaryResource.Cache == BodyData.IncludeType.Cache {
    public func resourceCache() -> BodyData.IncludeType.Cache? {
        guard let bodyData = body.data else {
            return nil
        }

        var cache = BodyData.IncludeType.Cache()

        bodyData.primary.value.cache(in: &cache)

        for include in bodyData.includes.values {
            include.cache(in: &cache)
        }

        return cache
    }
}

extension EncodableJSONAPIDocument where
    BodyData.PrimaryResourceBody: ManyResourceBodyProtocol,
    BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    BodyData.IncludeType: CacheableResource,
    BodyData.PrimaryResourceBody.PrimaryResource.Cache == BodyData.IncludeType.Cache {
    public func resourceCache() -> BodyData.IncludeType.Cache? {
        guard let bodyData = body.data else {
            return nil
        }

        var cache = BodyData.IncludeType.Cache()

        for resource in bodyData.primary.values {
            resource.cache(in: &cache)
        }

        for include in bodyData.includes.values {
            include.cache(in: &cache)
        }

        return cache
    }
}

extension EncodableJSONAPIDocument where
    BodyData.PrimaryResourceBody: SingleResourceBodyProtocol,
    BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    BodyData.IncludeType == NoIncludes {
    public func resourceCache() -> BodyData.PrimaryResourceBody.PrimaryResource.Cache? {
        guard let bodyData = body.data else {
            return nil
        }

        var cache = BodyData.PrimaryResourceBody.PrimaryResource.Cache()

        bodyData.primary.value.cache(in: &cache)

        return cache
    }
}

extension EncodableJSONAPIDocument where
    BodyData.PrimaryResourceBody: ManyResourceBodyProtocol,
    BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    BodyData.IncludeType == NoIncludes {
    public func resourceCache() -> BodyData.PrimaryResourceBody.PrimaryResource.Cache? {
        guard let bodyData = body.data else {
            return nil
        }

        var cache = BodyData.PrimaryResourceBody.PrimaryResource.Cache()

        for resource in bodyData.primary.values {
            resource.cache(in: &cache)
        }

        return cache
    }
}

// MARK: Success Documents
// success documents can return non-optional caches

extension Document.SuccessDocument where
    BodyData.PrimaryResourceBody: SingleResourceBodyProtocol,
    BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    BodyData.IncludeType: CacheableResource,
    BodyData.PrimaryResourceBody.PrimaryResource.Cache == BodyData.IncludeType.Cache {
    public func resourceCache() -> BodyData.IncludeType.Cache {

        var cache = BodyData.IncludeType.Cache()

        data.primary.value.cache(in: &cache)

        for include in data.includes.values {
            include.cache(in: &cache)
        }

        return cache
    }
}

extension Document.SuccessDocument where
    BodyData.PrimaryResourceBody: ManyResourceBodyProtocol,
    BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    BodyData.IncludeType: CacheableResource,
    BodyData.PrimaryResourceBody.PrimaryResource.Cache == BodyData.IncludeType.Cache {
    public func resourceCache() -> BodyData.IncludeType.Cache {

        var cache = BodyData.IncludeType.Cache()

        for resource in data.primary.values {
            resource.cache(in: &cache)
        }

        for include in data.includes.values {
            include.cache(in: &cache)
        }

        return cache
    }
}

extension Document.SuccessDocument where
    BodyData.PrimaryResourceBody: SingleResourceBodyProtocol,
    BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    BodyData.IncludeType == NoIncludes {
    public func resourceCache() -> BodyData.PrimaryResourceBody.PrimaryResource.Cache {

        var cache = BodyData.PrimaryResourceBody.PrimaryResource.Cache()

        data.primary.value.cache(in: &cache)

        return cache
    }
}

extension Document.SuccessDocument where
    BodyData.PrimaryResourceBody: ManyResourceBodyProtocol,
    BodyData.PrimaryResourceBody.PrimaryResource: CacheableResource,
    BodyData.IncludeType == NoIncludes {
    public func resourceCache() -> BodyData.PrimaryResourceBody.PrimaryResource.Cache {

        var cache = BodyData.PrimaryResourceBody.PrimaryResource.Cache()

        for resource in data.primary.values {
            resource.cache(in: &cache)
        }

        return cache
    }
}
