import JSONAPI

/// A `ResourceStore` can hold JSONAPI `ResourceObjects` of
/// any type.
public final class ResourceStore {
    internal var storage: [ObjectIdentifier: [AnyHashable: Any]]

    public var count: Int {
        return storage.values.reduce(0, { $0 + $1.values.count })
    }

    public init() {
        storage = [:]
    }

    /// Update or insert (upsert) the given resource.
    public func upsert<T: JSONAPI.IdentifiableResourceObjectType>(_ resource: T) {
        upsert([resource])
    }

    /// Update or insert (upsert) the given resources.
    public func upsert<T: JSONAPI.IdentifiableResourceObjectType>(_ resources: [T]) {
        for resource in resources {
            storage[ObjectIdentifier(T.Id.self), default: [:]][resource.id] = resource
        }
    }

    /// Merge another resource store into this one in-place. Values from the other resource store
    /// with the same identifiers will replace values from this resource store.
    public func merge(_ other: ResourceStore) {
        storage.merge(other.storage) { _, new in new }
    }

    public subscript<T: JSONAPI.IdentifiableResourceObjectType>(id: T.Id) -> StoredResource<T>? {
        return storage[ObjectIdentifier(T.Id.self)].flatMap { resourceHash in
            resourceHash[id]
                .map { $0 as! T }
                .map { StoredResource(store: self, primary: $0) }
        }
    }
}

extension EncodableJSONAPIDocument where BodyData.PrimaryResourceBody: SingleResourceBodyProtocol, BodyData.PrimaryResourceBody.PrimaryResource: JSONAPI.IdentifiableResourceObjectType, BodyData.IncludeType: StorableResource {
    public func resourceStore() -> ResourceStore? {
        guard let bodyData = body.data else {
            return nil
        }

        let store = ResourceStore()

        store.upsert(bodyData.primary.value)

        for include in bodyData.includes.values {
            include.store(in: store)
        }

        return store
    }

    public func storedPrimaryResource() -> StoredResource<BodyData.PrimaryResourceBody.PrimaryResource>? {
        guard let bodyData = body.data,
              let resourceStore = resourceStore() else { return nil }
        return StoredResource(store: resourceStore, primary: bodyData.primary.value)
    }
}

extension EncodableJSONAPIDocument where BodyData.PrimaryResourceBody: ManyResourceBodyProtocol, BodyData.PrimaryResourceBody.PrimaryResource: JSONAPI.IdentifiableResourceObjectType, BodyData.IncludeType: StorableResource {
    public func resourceStore() -> ResourceStore? {
        guard let bodyData = body.data else {
            return nil
        }

        let store = ResourceStore()

        for resource in bodyData.primary.values {
            store.upsert(resource)
        }

        for include in bodyData.includes.values {
            include.store(in: store)
        }

        return store
    }

    public func storedPrimaryResources() -> [StoredResource<BodyData.PrimaryResourceBody.PrimaryResource>] {
        guard let bodyData = body.data,
              let resourceStore = resourceStore() else { return [] }
        return bodyData.primary.values.map { StoredResource(store: resourceStore, primary: $0) }
    }
}
