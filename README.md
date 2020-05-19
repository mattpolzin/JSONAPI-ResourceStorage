# JSONAPI-ResourceStore

This is a companion library to `mattpolzin/JSONAPI`. `JSONAPI` is a much more well established library; by comparison, this library is more of an experiment.

Not a lot of work or testing has gone into this library. It's not my personal choice for how to manage resources, but it does represent a viable option.

Without endorsing this degree of force unwrapping, here's a chunk of code in lieu of a properly fleshed out README.
```swift
// decode a `JSONAPI.Document` with a primary resource of type `Resource1` 
// and included resources for the `relative1` relationship.
let document = ...

// get the primary resource from the document as a ResourceObject
let primaryResource = document.body.primaryResource!.value

// create a resource store
let resourceStore = document.resourceStore()!

// retrieve the primary resource from the store as a `StoredResource`
let resource = resourceStore[primaryResource.id]!

// retrieve the related resource by the name of the relationship
let relative = resource.relative1
```
