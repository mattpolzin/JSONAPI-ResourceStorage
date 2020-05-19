//
//  StoredResource.swift
//  
//
//  Created by Mathew Polzin on 5/18/20.
//

import JSONAPI

/// A `StoredResource` holds a single resource (it calls it "primary")
/// and a reference to a `ResourceStore` that it uses to attempt to resolve
/// any related resources.
@dynamicMemberLookup
public struct StoredResource<JSONAPIModel: JSONAPI.IdentifiableResourceObjectType> {
    private let store: ResourceStore

    public let primary: JSONAPIModel

    // MARK: Attribute Lookup
    /// Access the attribute at the given keypath. This just
    /// allows you to write `resourceObject[\.propertyName]` instead
    /// of `resourceObject.attributes.propertyName.value`.
    public subscript<T: AttributeType>(dynamicMember path: KeyPath<JSONAPIModel.Attributes, T>) -> T.ValueType {
        return primary.attributes[keyPath: path].value
    }

    /// Access the attribute at the given keypath. This just
    /// allows you to write `resourceObject[\.propertyName]` instead
    /// of `resourceObject.attributes.propertyName.value`.
    public subscript<T: AttributeType>(dynamicMember path: KeyPath<JSONAPIModel.Attributes, T?>) -> T.ValueType? {
        return primary.attributes[keyPath: path]?.value
    }

    /// Access the attribute at the given keypath. This just
    /// allows you to write `resourceObject[\.propertyName]` instead
    /// of `resourceObject.attributes.propertyName.value`.
    public subscript<T: AttributeType, U>(dynamicMember path: KeyPath<JSONAPIModel.Attributes, T?>) -> U? where T.ValueType == U? {
        return primary.attributes[keyPath: path].flatMap(\.value)
    }

    // MARK: Direct Keypath Subscript Lookup
    /// Access the storage of the attribute at the given keypath. This just
    /// allows you to write `resourceObject[direct: \.propertyName]` instead
    /// of `resourceObject.attributes.propertyName`.
    /// Most of the subscripts dig into an `AttributeType`. This subscript
    /// returns the `AttributeType` (or another type, if you are accessing
    /// an attribute that is not stored in an `AttributeType`).
    public subscript<T>(direct path: KeyPath<JSONAPIModel.Attributes, T>) -> T {
        // Implementation Note: Handles attributes that are not
        // AttributeType. These should only exist as computed properties.
        return primary.attributes[keyPath: path]
    }

    // MARK: Relationship Lookup
    /// Access a related To-one resource if it is available in the resource store.
    public subscript<OtherEntity: Relatable, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links>(dynamicMember path: KeyPath<JSONAPIModel.Relationships, ToOneRelationship<OtherEntity, MetaType, LinksType>>) -> StoredResource<OtherEntity>? {
        let relativeId = primary.relationships[keyPath: path].id
        return store.storage[ObjectIdentifier(OtherEntity.Identifier.self)].flatMap { $0[relativeId].map { StoredResource<OtherEntity>(store: self.store, primary: $0 as! OtherEntity) } }
    }

    /// Access related To-many resources if they are available in the resource store.
    public subscript<OtherEntity: Relatable, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links>(dynamicMember path: KeyPath<JSONAPIModel.Relationships, ToManyRelationship<OtherEntity, MetaType, LinksType>>) -> [StoredResource<OtherEntity>] {
        let relativeIds = primary.relationships[keyPath: path].ids
        return relativeIds.compactMap { otherId in
            store.storage[ObjectIdentifier(OtherEntity.Identifier.self)].flatMap { resourceHash in
                resourceHash[otherId].map { StoredResource<OtherEntity>(store: self.store, primary: $0 as! OtherEntity) } }
        }
    }

    public init(store: ResourceStore, primary: JSONAPIModel) {
        self.store = store
        self.primary = primary
    }
}
