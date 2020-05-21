//
//  Include+StorableResource.swift
//  
//
//  Created by Mathew Polzin on 5/18/20.
//

import Poly
import JSONAPI

public protocol StorableResource {
    func store(in store: ResourceStore)
}

extension NoIncludes: StorableResource {
    public func store(in store: ResourceStore) {}
}

extension Include1: StorableResource where A: JSONAPI.IdentifiableResourceObjectType {
    public func store(in store: ResourceStore) {
        switch self {
        case .a(let resource):
            store.upsert(resource)
        }
    }
}

extension Include2: StorableResource where
    A: JSONAPI.IdentifiableResourceObjectType,
    B: JSONAPI.IdentifiableResourceObjectType {
    public func store(in store: ResourceStore) {
        switch self {
        case .a(let resource):
            store.upsert(resource)
        case .b(let resource):
            store.upsert(resource)
        }
    }
}

extension Include3: StorableResource where
    A: JSONAPI.IdentifiableResourceObjectType,
    B: JSONAPI.IdentifiableResourceObjectType,
    C: JSONAPI.IdentifiableResourceObjectType {
    public func store(in store: ResourceStore) {
        switch self {
        case .a(let resource):
            store.upsert(resource)
        case .b(let resource):
            store.upsert(resource)
        case .c(let resource):
            store.upsert(resource)
        }
    }
}

extension Include4: StorableResource where
    A: JSONAPI.IdentifiableResourceObjectType,
    B: JSONAPI.IdentifiableResourceObjectType,
    C: JSONAPI.IdentifiableResourceObjectType,
    D: JSONAPI.IdentifiableResourceObjectType {
    public func store(in store: ResourceStore) {
        switch self {
        case .a(let resource):
            store.upsert(resource)
        case .b(let resource):
            store.upsert(resource)
        case .c(let resource):
            store.upsert(resource)
        case .d(let resource):
            store.upsert(resource)
        }
    }
}

extension Include5: StorableResource where
    A: JSONAPI.IdentifiableResourceObjectType,
    B: JSONAPI.IdentifiableResourceObjectType,
    C: JSONAPI.IdentifiableResourceObjectType,
    D: JSONAPI.IdentifiableResourceObjectType,
    E: JSONAPI.IdentifiableResourceObjectType {
    public func store(in store: ResourceStore) {
        switch self {
        case .a(let resource):
            store.upsert(resource)
        case .b(let resource):
            store.upsert(resource)
        case .c(let resource):
            store.upsert(resource)
        case .d(let resource):
            store.upsert(resource)
        case .e(let resource):
            store.upsert(resource)
        }
    }
}

extension Include6: StorableResource where
    A: JSONAPI.IdentifiableResourceObjectType,
    B: JSONAPI.IdentifiableResourceObjectType,
    C: JSONAPI.IdentifiableResourceObjectType,
    D: JSONAPI.IdentifiableResourceObjectType,
    E: JSONAPI.IdentifiableResourceObjectType,
    F: JSONAPI.IdentifiableResourceObjectType {
    public func store(in store: ResourceStore) {
        switch self {
        case .a(let resource):
            store.upsert(resource)
        case .b(let resource):
            store.upsert(resource)
        case .c(let resource):
            store.upsert(resource)
        case .d(let resource):
            store.upsert(resource)
        case .e(let resource):
            store.upsert(resource)
        case .f(let resource):
            store.upsert(resource)
        }
    }
}

extension Include7: StorableResource where
    A: JSONAPI.IdentifiableResourceObjectType,
    B: JSONAPI.IdentifiableResourceObjectType,
    C: JSONAPI.IdentifiableResourceObjectType,
    D: JSONAPI.IdentifiableResourceObjectType,
    E: JSONAPI.IdentifiableResourceObjectType,
    F: JSONAPI.IdentifiableResourceObjectType,
    G: JSONAPI.IdentifiableResourceObjectType {
    public func store(in store: ResourceStore) {
        switch self {
        case .a(let resource):
            store.upsert(resource)
        case .b(let resource):
            store.upsert(resource)
        case .c(let resource):
            store.upsert(resource)
        case .d(let resource):
            store.upsert(resource)
        case .e(let resource):
            store.upsert(resource)
        case .f(let resource):
            store.upsert(resource)
        case .g(let resource):
            store.upsert(resource)

        }
    }
}

extension Include8: StorableResource where
    A: JSONAPI.IdentifiableResourceObjectType,
    B: JSONAPI.IdentifiableResourceObjectType,
    C: JSONAPI.IdentifiableResourceObjectType,
    D: JSONAPI.IdentifiableResourceObjectType,
    E: JSONAPI.IdentifiableResourceObjectType,
    F: JSONAPI.IdentifiableResourceObjectType,
    G: JSONAPI.IdentifiableResourceObjectType,
    H: JSONAPI.IdentifiableResourceObjectType {
    public func store(in store: ResourceStore) {
        switch self {
        case .a(let resource):
            store.upsert(resource)
        case .b(let resource):
            store.upsert(resource)
        case .c(let resource):
            store.upsert(resource)
        case .d(let resource):
            store.upsert(resource)
        case .e(let resource):
            store.upsert(resource)
        case .f(let resource):
            store.upsert(resource)
        case .g(let resource):
            store.upsert(resource)
        case .h(let resource):
            store.upsert(resource)
        }
    }
}

extension Include9: StorableResource where
    A: JSONAPI.IdentifiableResourceObjectType,
    B: JSONAPI.IdentifiableResourceObjectType,
    C: JSONAPI.IdentifiableResourceObjectType,
    D: JSONAPI.IdentifiableResourceObjectType,
    E: JSONAPI.IdentifiableResourceObjectType,
    F: JSONAPI.IdentifiableResourceObjectType,
    G: JSONAPI.IdentifiableResourceObjectType,
    H: JSONAPI.IdentifiableResourceObjectType,
    I: JSONAPI.IdentifiableResourceObjectType {
    public func store(in store: ResourceStore) {
        switch self {
        case .a(let resource):
            store.upsert(resource)
        case .b(let resource):
            store.upsert(resource)
        case .c(let resource):
            store.upsert(resource)
        case .d(let resource):
            store.upsert(resource)
        case .e(let resource):
            store.upsert(resource)
        case .f(let resource):
            store.upsert(resource)
        case .g(let resource):
            store.upsert(resource)
        case .h(let resource):
            store.upsert(resource)
        case .i(let resource):
            store.upsert(resource)
        }
    }
}

extension Include10: StorableResource where
    A: JSONAPI.IdentifiableResourceObjectType,
    B: JSONAPI.IdentifiableResourceObjectType,
    C: JSONAPI.IdentifiableResourceObjectType,
    D: JSONAPI.IdentifiableResourceObjectType,
    E: JSONAPI.IdentifiableResourceObjectType,
    F: JSONAPI.IdentifiableResourceObjectType,
    G: JSONAPI.IdentifiableResourceObjectType,
    H: JSONAPI.IdentifiableResourceObjectType,
    I: JSONAPI.IdentifiableResourceObjectType,
    J: JSONAPI.IdentifiableResourceObjectType {
    public func store(in store: ResourceStore) {
        switch self {
        case .a(let resource):
            store.upsert(resource)
        case .b(let resource):
            store.upsert(resource)
        case .c(let resource):
            store.upsert(resource)
        case .d(let resource):
            store.upsert(resource)
        case .e(let resource):
            store.upsert(resource)
        case .f(let resource):
            store.upsert(resource)
        case .g(let resource):
            store.upsert(resource)
        case .h(let resource):
            store.upsert(resource)
        case .i(let resource):
            store.upsert(resource)
        case .j(let resource):
            store.upsert(resource)
        }
    }
}

extension Include11: StorableResource where
    A: JSONAPI.IdentifiableResourceObjectType,
    B: JSONAPI.IdentifiableResourceObjectType,
    C: JSONAPI.IdentifiableResourceObjectType,
    D: JSONAPI.IdentifiableResourceObjectType,
    E: JSONAPI.IdentifiableResourceObjectType,
    F: JSONAPI.IdentifiableResourceObjectType,
    G: JSONAPI.IdentifiableResourceObjectType,
    H: JSONAPI.IdentifiableResourceObjectType,
    I: JSONAPI.IdentifiableResourceObjectType,
    J: JSONAPI.IdentifiableResourceObjectType,
    K: JSONAPI.IdentifiableResourceObjectType {
    public func store(in store: ResourceStore) {
        switch self {
        case .a(let resource):
            store.upsert(resource)
        case .b(let resource):
            store.upsert(resource)
        case .c(let resource):
            store.upsert(resource)
        case .d(let resource):
            store.upsert(resource)
        case .e(let resource):
            store.upsert(resource)
        case .f(let resource):
            store.upsert(resource)
        case .g(let resource):
            store.upsert(resource)
        case .h(let resource):
            store.upsert(resource)
        case .i(let resource):
            store.upsert(resource)
        case .j(let resource):
            store.upsert(resource)
        case .k(let resource):
            store.upsert(resource)
        }
    }
}
