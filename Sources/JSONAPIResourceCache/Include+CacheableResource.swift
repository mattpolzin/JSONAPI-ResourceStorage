//
//  Include+CacheableResource.swift
//  
//
//  Created by Mathew Polzin on 5/20/20.
//

import JSONAPI
import Poly

extension Include1: CacheableResource where A: CacheableResource {
    public func cache(in cache: inout A.Cache) {
        switch self {
        case .a(let resource):
            resource.cache(in: &cache)
        }
    }
}

extension Include2: CacheableResource where
    A: CacheableResource,
    B: CacheableResource,
    A.Cache == B.Cache {
    public func cache(in cache: inout A.Cache) {
        switch self {
        case .a(let resource):
            resource.cache(in: &cache)
        case .b(let resource):
            resource.cache(in: &cache)
        }
    }
}

extension Include3: CacheableResource where
    A: CacheableResource,
    B: CacheableResource,
    C: CacheableResource,
    A.Cache == B.Cache,
    B.Cache == C.Cache {
    public func cache(in cache: inout A.Cache) {
        switch self {
        case .a(let resource):
            resource.cache(in: &cache)
        case .b(let resource):
            resource.cache(in: &cache)
        case .c(let resource):
            resource.cache(in: &cache)
        }
    }
}

extension Include4: CacheableResource where
    A: CacheableResource,
    B: CacheableResource,
    C: CacheableResource,
    D: CacheableResource,
    A.Cache == B.Cache,
    B.Cache == C.Cache,
    C.Cache == D.Cache {
    public func cache(in cache: inout A.Cache) {
        switch self {
        case .a(let resource):
            resource.cache(in: &cache)
        case .b(let resource):
            resource.cache(in: &cache)
        case .c(let resource):
            resource.cache(in: &cache)
        case .d(let resource):
            resource.cache(in: &cache)
        }
    }
}

extension Include5: CacheableResource where
    A: CacheableResource,
    B: CacheableResource,
    C: CacheableResource,
    D: CacheableResource,
    E: CacheableResource,
    A.Cache == B.Cache,
    B.Cache == C.Cache,
    C.Cache == D.Cache,
    D.Cache == E.Cache {
    public func cache(in cache: inout A.Cache) {
        switch self {
        case .a(let resource):
            resource.cache(in: &cache)
        case .b(let resource):
            resource.cache(in: &cache)
        case .c(let resource):
            resource.cache(in: &cache)
        case .d(let resource):
            resource.cache(in: &cache)
        case .e(let resource):
            resource.cache(in: &cache)
        }
    }
}

extension Include6: CacheableResource where
    A: CacheableResource,
    B: CacheableResource,
    C: CacheableResource,
    D: CacheableResource,
    E: CacheableResource,
    F: CacheableResource,
    A.Cache == B.Cache,
    B.Cache == C.Cache,
    C.Cache == D.Cache,
    D.Cache == E.Cache,
    E.Cache == F.Cache {
    public func cache(in cache: inout A.Cache) {
        switch self {
        case .a(let resource):
            resource.cache(in: &cache)
        case .b(let resource):
            resource.cache(in: &cache)
        case .c(let resource):
            resource.cache(in: &cache)
        case .d(let resource):
            resource.cache(in: &cache)
        case .e(let resource):
            resource.cache(in: &cache)
        case .f(let resource):
            resource.cache(in: &cache)
        }
    }
}

extension Include7: CacheableResource where
    A: CacheableResource,
    B: CacheableResource,
    C: CacheableResource,
    D: CacheableResource,
    E: CacheableResource,
    F: CacheableResource,
    G: CacheableResource,
    A.Cache == B.Cache,
    B.Cache == C.Cache,
    C.Cache == D.Cache,
    D.Cache == E.Cache,
    E.Cache == F.Cache,
    F.Cache == G.Cache {
    public func cache(in cache: inout A.Cache) {
        switch self {
        case .a(let resource):
            resource.cache(in: &cache)
        case .b(let resource):
            resource.cache(in: &cache)
        case .c(let resource):
            resource.cache(in: &cache)
        case .d(let resource):
            resource.cache(in: &cache)
        case .e(let resource):
            resource.cache(in: &cache)
        case .f(let resource):
            resource.cache(in: &cache)
        case .g(let resource):
            resource.cache(in: &cache)

        }
    }
}

extension Include8: CacheableResource where
    A: CacheableResource,
    B: CacheableResource,
    C: CacheableResource,
    D: CacheableResource,
    E: CacheableResource,
    F: CacheableResource,
    G: CacheableResource,
    H: CacheableResource,
    A.Cache == B.Cache,
    B.Cache == C.Cache,
    C.Cache == D.Cache,
    D.Cache == E.Cache,
    E.Cache == F.Cache,
    F.Cache == G.Cache,
    G.Cache == H.Cache {
    public func cache(in cache: inout A.Cache) {
        switch self {
        case .a(let resource):
            resource.cache(in: &cache)
        case .b(let resource):
            resource.cache(in: &cache)
        case .c(let resource):
            resource.cache(in: &cache)
        case .d(let resource):
            resource.cache(in: &cache)
        case .e(let resource):
            resource.cache(in: &cache)
        case .f(let resource):
            resource.cache(in: &cache)
        case .g(let resource):
            resource.cache(in: &cache)
        case .h(let resource):
            resource.cache(in: &cache)
        }
    }
}

extension Include9: CacheableResource where
    A: CacheableResource,
    B: CacheableResource,
    C: CacheableResource,
    D: CacheableResource,
    E: CacheableResource,
    F: CacheableResource,
    G: CacheableResource,
    H: CacheableResource,
    I: CacheableResource,
    A.Cache == B.Cache,
    B.Cache == C.Cache,
    C.Cache == D.Cache,
    D.Cache == E.Cache,
    E.Cache == F.Cache,
    F.Cache == G.Cache,
    G.Cache == H.Cache,
    H.Cache == I.Cache {
    public func cache(in cache: inout A.Cache) {
        switch self {
        case .a(let resource):
            resource.cache(in: &cache)
        case .b(let resource):
            resource.cache(in: &cache)
        case .c(let resource):
            resource.cache(in: &cache)
        case .d(let resource):
            resource.cache(in: &cache)
        case .e(let resource):
            resource.cache(in: &cache)
        case .f(let resource):
            resource.cache(in: &cache)
        case .g(let resource):
            resource.cache(in: &cache)
        case .h(let resource):
            resource.cache(in: &cache)
        case .i(let resource):
            resource.cache(in: &cache)
        }
    }
}

extension Include10: CacheableResource where
    A: CacheableResource,
    B: CacheableResource,
    C: CacheableResource,
    D: CacheableResource,
    E: CacheableResource,
    F: CacheableResource,
    G: CacheableResource,
    H: CacheableResource,
    I: CacheableResource,
    J: CacheableResource,
    A.Cache == B.Cache,
    B.Cache == C.Cache,
    C.Cache == D.Cache,
    D.Cache == E.Cache,
    E.Cache == F.Cache,
    F.Cache == G.Cache,
    G.Cache == H.Cache,
    H.Cache == I.Cache,
    I.Cache == J.Cache {
    public func cache(in cache: inout A.Cache) {
        switch self {
        case .a(let resource):
            resource.cache(in: &cache)
        case .b(let resource):
            resource.cache(in: &cache)
        case .c(let resource):
            resource.cache(in: &cache)
        case .d(let resource):
            resource.cache(in: &cache)
        case .e(let resource):
            resource.cache(in: &cache)
        case .f(let resource):
            resource.cache(in: &cache)
        case .g(let resource):
            resource.cache(in: &cache)
        case .h(let resource):
            resource.cache(in: &cache)
        case .i(let resource):
            resource.cache(in: &cache)
        case .j(let resource):
            resource.cache(in: &cache)
        }
    }
}

extension Include11: CacheableResource where
    A: CacheableResource,
    B: CacheableResource,
    C: CacheableResource,
    D: CacheableResource,
    E: CacheableResource,
    F: CacheableResource,
    G: CacheableResource,
    H: CacheableResource,
    I: CacheableResource,
    J: CacheableResource,
    K: CacheableResource,
    A.Cache == B.Cache,
    B.Cache == C.Cache,
    C.Cache == D.Cache,
    D.Cache == E.Cache,
    E.Cache == F.Cache,
    F.Cache == G.Cache,
    G.Cache == H.Cache,
    H.Cache == I.Cache,
    I.Cache == J.Cache,
    J.Cache == K.Cache {
    public func cache(in cache: inout A.Cache) {
        switch self {
        case .a(let resource):
            resource.cache(in: &cache)
        case .b(let resource):
            resource.cache(in: &cache)
        case .c(let resource):
            resource.cache(in: &cache)
        case .d(let resource):
            resource.cache(in: &cache)
        case .e(let resource):
            resource.cache(in: &cache)
        case .f(let resource):
            resource.cache(in: &cache)
        case .g(let resource):
            resource.cache(in: &cache)
        case .h(let resource):
            resource.cache(in: &cache)
        case .i(let resource):
            resource.cache(in: &cache)
        case .j(let resource):
            resource.cache(in: &cache)
        case .k(let resource):
            resource.cache(in: &cache)
        }
    }
}
