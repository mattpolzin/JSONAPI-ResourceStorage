import XCTest
import JSONAPI
import JSONAPITesting
import JSONAPIResourceCache

final class ResourceCacheTests: XCTestCase {
    func test_resourceAccess() {
        let t1Id = "1234"
        let t2Id = "5678"
        let t2Id2 = "1323221"
        let t3Id = "910112"

        let date = Date()

        let type3 = Type3(
            id: .init(rawValue: t3Id),
            attributes: .init(int: 1234),
            relationships: .init(type2: .init(id: .init(rawValue: t2Id))),
            meta: .none,
            links: .none
        )

        let type2s = [
            Type2(
                id: .init(rawValue: t2Id),
                attributes: .init(string: "hello world"),
                relationships: .init(
                    type1: .init(id: .init(rawValue: t1Id)),
                    type3: .init(id: .init(rawValue: t3Id))
                ),
                meta: .none,
                links: .none
            ),
            Type2(
                id: .init(rawValue: t2Id2),
                attributes: .init(string: "hi"),
                relationships: .init(
                    type1: .init(id: .init(rawValue: t1Id)),
                    type3: .init(id: .init(rawValue: t3Id))
                ),
                meta: .none,
                links: .none
            )
        ]

        let type1 = Type1(
            id: .init(rawValue: t1Id),
            attributes: .init(createdAt: .init(value: date)),
            relationships: .init(
                type2: .init(id: .init(rawValue: t2Id)),
                type4: .init(ids: [])
            ),
            meta: .none,
            links: .none
        )

        var cache = ResourceCache()
        XCTAssertNil(cache[type1.id])
        XCTAssertNil(cache.type1s[type1.id])
        XCTAssertNil(type1.id.materialized(from: cache))

        cache.upsert(type1)
        XCTAssertEqual(cache[type1.id], type1)
        XCTAssertEqual(cache.type1s[type1.id], type1)
        XCTAssertEqual(type1.id.materialized(from: cache), type1)
        XCTAssertNil(cache[type2s[0].id])
        XCTAssertNil(cache[type2s[1].id])
        XCTAssertNil(cache[type3.id])

        cache.upsert(type2s)
        XCTAssertEqual(cache[type1.id], type1)
        XCTAssertEqual(cache.type1s[type1.id], type1)
        XCTAssertEqual(type1.id.materialized(from: cache), type1)
        XCTAssertEqual(cache[type2s[0].id], type2s[0])
        XCTAssertEqual(cache.type2s[type2s[0].id], type2s[0])
        XCTAssertEqual(type2s[0].id.materialized(from: cache), type2s[0])
        XCTAssertEqual(cache[type2s[1].id], type2s[1])
        XCTAssertEqual(cache.type2s[type2s[1].id], type2s[1])
        XCTAssertEqual(type2s[1].id.materialized(from: cache), type2s[1])
    }

    func test_documentCreation() {
        let t1Id = "1234"
        let t2Id = "5678"
        let t2Id2 = "1323221"
        let t3Id = "910112"

        let date = Date()

        let type3 = Type3(
            id: .init(rawValue: t3Id),
            attributes: .init(int: 1234),
            relationships: .init(type2: .init(id: .init(rawValue: t2Id))),
            meta: .none,
            links: .none
        )

        let type2s = [
            Type2(
                id: .init(rawValue: t2Id),
                attributes: .init(string: "hello world"),
                relationships: .init(
                    type1: .init(id: .init(rawValue: t1Id)),
                    type3: .init(id: .init(rawValue: t3Id))
                ),
                meta: .none,
                links: .none
            ),
            Type2(
                id: .init(rawValue: t2Id2),
                attributes: .init(string: "hi"),
                relationships: .init(
                    type1: .init(id: .init(rawValue: t1Id)),
                    type3: .init(id: .init(rawValue: t3Id))
                ),
                meta: .none,
                links: .none
            )
        ]

        let type1 = Type1(
            id: .init(rawValue: t1Id),
            attributes: .init(createdAt: .init(value: date)),
            relationships: .init(
                type2: .init(id: .init(rawValue: t2Id)),
                type4: .init(ids: [])
            ),
            meta: .none,
            links: .none
        )

        let document = JSONAPI.Document<
            ManyResourceBody<Type2>,
            NoMetadata,
            NoLinks,
            Include2<Type1, Type3>,
            NoAPIDescription,
            UnknownJSONAPIError>(
                apiDescription: .none,
                body: .init(resourceObjects: type2s),
                includes: .init(values: [.init(type1), .init(type3)]),
                meta: .none,
                links: .none
        )

        let cache = document.resourceCache()

        XCTAssertEqual(cache?[type1.id], type1)
        XCTAssertEqual(cache?[type2s[0].id], type2s[0])
        XCTAssertEqual(cache?[type2s[1].id], type2s[1])
        XCTAssertEqual(cache?[type3.id], type3)

        let firstPrimaryResource = document.body.primaryResource!.values.first!
        XCTAssertEqual((firstPrimaryResource ~> \.type1).materialized(from: cache!), type1)
        XCTAssertEqual((firstPrimaryResource ~> \.type3).materialized(from: cache!), type3)
    }

    func test_successDocumentCreation() {
        let t1Id = "1234"
        let t2Id = "5678"
        let t2Id2 = "1323221"
        let t3Id = "910112"

        let date = Date()

        let type3 = Type3(
            id: .init(rawValue: t3Id),
            attributes: .init(int: 1234),
            relationships: .init(type2: .init(id: .init(rawValue: t2Id))),
            meta: .none,
            links: .none
        )

        let type2s = [
            Type2(
                id: .init(rawValue: t2Id),
                attributes: .init(string: "hello world"),
                relationships: .init(
                    type1: .init(id: .init(rawValue: t1Id)),
                    type3: .init(id: .init(rawValue: t3Id))
                ),
                meta: .none,
                links: .none
            ),
            Type2(
                id: .init(rawValue: t2Id2),
                attributes: .init(string: "hi"),
                relationships: .init(
                    type1: .init(id: .init(rawValue: t1Id)),
                    type3: .init(id: .init(rawValue: t3Id))
                ),
                meta: .none,
                links: .none
            )
        ]

        let type1 = Type1(
            id: .init(rawValue: t1Id),
            attributes: .init(createdAt: .init(value: date)),
            relationships: .init(
                type2: .init(id: .init(rawValue: t2Id)),
                type4: .init(ids: [])
            ),
            meta: .none,
            links: .none
        )

        let document = JSONAPI.Document<
            ManyResourceBody<Type2>,
            NoMetadata,
            NoLinks,
            Include2<Type1, Type3>,
            NoAPIDescription,
        UnknownJSONAPIError>.SuccessDocument(
                apiDescription: .none,
                body: .init(resourceObjects: type2s),
                includes: .init(values: [.init(type1), .init(type3)]),
                meta: .none,
                links: .none
        )

        let cache = document.resourceCache()

        XCTAssertEqual(cache[type1.id], type1)
        XCTAssertEqual(cache[type2s[0].id], type2s[0])
        XCTAssertEqual(cache[type2s[1].id], type2s[1])
        XCTAssertEqual(cache[type3.id], type3)

        let firstPrimaryResource = document.body.primaryResource!.values.first!
        XCTAssertEqual((firstPrimaryResource ~> \.type1).materialized(from: cache), type1)
        XCTAssertEqual((firstPrimaryResource ~> \.type3).materialized(from: cache), type3)
    }
}

// MARK: - Test Types
fileprivate enum Type1Description: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "type1"

    struct Attributes: JSONAPI.Attributes {
        let createdAt: Attribute<Date>
    }

    struct Relationships: JSONAPI.Relationships {
        let type2: ToOneRelationship<Type2, NoIdMetadata, NoMetadata, NoLinks>
        let type4: ToManyRelationship<Type4, NoIdMetadata, NoMetadata, NoLinks>
    }
}

fileprivate typealias Type1 = JSONAPI.ResourceObject<Type1Description, NoMetadata, NoLinks, String>

fileprivate enum Type2Description: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "type2"

    struct Attributes: JSONAPI.Attributes {
        let string: Attribute<String>
    }

    struct Relationships: JSONAPI.Relationships {
        let type1: ToOneRelationship<Type1, NoIdMetadata, NoMetadata, NoLinks>
        let type3: ToOneRelationship<Type3, NoIdMetadata, NoMetadata, NoLinks>
    }
}

fileprivate typealias Type2 = JSONAPI.ResourceObject<Type2Description, NoMetadata, NoLinks, String>

fileprivate enum Type3Description: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "type3"

    struct Attributes: JSONAPI.Attributes {
        let int: Attribute<Int>
    }

    struct Relationships: JSONAPI.Relationships {
        let type2: ToOneRelationship<Type2, NoIdMetadata, NoMetadata, NoLinks>
    }
}

fileprivate typealias Type3 = JSONAPI.ResourceObject<Type3Description, NoMetadata, NoLinks, String>

fileprivate enum Type4Description: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "type4"

    typealias Attributes = NoAttributes
    typealias Relationships = NoRelationships
}

fileprivate typealias Type4 = JSONAPI.ResourceObject<Type4Description, NoMetadata, NoLinks, String>

// MARK: - Cache
fileprivate struct ResourceCache: JSONAPIResourceCache.ResourceCache {
    var type1s: ResourceHash<Type1> = [:]
    var type2s: ResourceHash<Type2> = [:]
    var type3s: ResourceHash<Type3> = [:]
    var type4s: ResourceHash<Type4> = [:]
}

//protocol Materializable: JSONAPIResourceCache.Materializable where ResourceCacheType == ResourceCache {}

extension Type1Description: Materializable {
    static var cachePath: WritableKeyPath<ResourceCache, ResourceHash<Type1>> { \.type1s }
}

extension Type2Description: Materializable {
    static var cachePath: WritableKeyPath<ResourceCache, ResourceHash<Type2>> { \.type2s }
}

extension Type3Description: Materializable {
    static var cachePath: WritableKeyPath<ResourceCache, ResourceHash<Type3>> { \.type3s }
}

//extension Type4Description: Materializable {
//    static var cachePath: WritableKeyPath<ResourceCache, ResourceHash<Type4>> { \.type4s }
//}
