# JSONAPI-ResourceStorage

This is a companion library to `mattpolzin/JSONAPI`. `JSONAPI` is a much more well established library; by comparison, this library is more of an experiment. Not a lot of work or testing has gone into this library yet but it might serve as a jumping off place for you.

This package has two modules. 

`JSONAPIResourceCache` is aimed at supporting the use-case where your entity cache is a value-type. All you need to do is create a cache type and conform your resources to `Materializable` in order to get going. This approach is well suited to state-driven development.

`JSONAPIResourceStore` contains a reference-type entity store.

## JSONAPIResourceCache

Without endorsing this degree of force unwrapping, here's a chunk of code in lieu of a properly fleshed out README.
```swift
import JSONAPIResourceCache

// Assuming existing definitions of `Resource1` and `Resource2` 
// `JSONAPI.ResourceObject` types, create a cache type.
struct Cache: Equatable, ResourceCache {
    var widgets: ResourceHash<Resource1>
    var cogs: ResourceHash<Resource2>
}

// extend our resource types to be Materializable
extension Resource1Description: Materializable {
    static var cachePath: WritableKeyPath<Cache, ResourceHash<Resource1>> { \.widgets }
}

extension Resource2Description: Materializable {
    static var cachePath: WritableKeyPath<Cache, ResourceHash<Resource2>> { \.cogs }
}

// decode a `JSONAPI.Document` with a single primary resource of type `Resource1` 
// and included resources for the `relative1` relationship.
let document = ...

// create a resource cache from the response (could be merged with
// an existing local cache pretty easily).
let resourceCache = document.resourceCache()!

// get the primary resource from the document as a ResourceObject
let primaryResource = document.body.primaryResource!.value

// materialize the primary resource's `relative1` relationship from the
// cache.
let relative = (primaryResource ~> \.relative1).materialize(from: resourceCache) 
```

## JSONAPIResourceStore

This reference-type store is not my personal choice for how to manage resources, but it represents a viable option.

Without endorsing this degree of force unwrapping, here's a chunk of code in lieu of a properly fleshed out README.
```swift
import JSONAPIResourceStore

// decode a `JSONAPI.Document` with a signle primary resource of type `Resource1` 
// and included resources for the `relative1` relationship.
let document = ...

// create a resource store
let resourceStore = document.resourceStore()!

// get the primary resource from the document as a ResourceObject
let primaryResource = document.body.primaryResource!.value

// retrieve the primary resource from the store as a `StoredResource`
let resource = resourceStore[primaryResource.id]!

// retrieve the related resource by the name of the relationship
let relative = resource.relative1
```
