import XCTest
import JSONAPI
import JSONAPITesting
import JSONAPIResourceStore

final class ResourceStoreTests: XCTestCase {
    func test_resourceStore() {
        let t1Id = "1234"
        let t2Id = "5678"
        let t3Id = "910112"

        let date = Date()

        let type3 = Type3(
            id: .init(rawValue: t3Id),
            attributes: .init(int: 1234),
            relationships: .init(type2: .init(id: .init(rawValue: t2Id))),
            meta: .none,
            links: .none
        )

        let type2 = Type2(
            id: .init(rawValue: t2Id),
            attributes: .init(string: "hello world"),
            relationships: .init(
                type1: .init(id: .init(rawValue: t1Id)),
                type3: .init(id: .init(rawValue: t3Id))
            ),
            meta: .none,
            links: .none
        )

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

        let store = ResourceStore()

        XCTAssertEqual(store.count, 0)
        XCTAssertNil(store[type1.id])

        store.upsert(type1)

        XCTAssertEqual(store.count, 1)
        XCTAssertEqual(store[type1.id]?.primary, type1)
        XCTAssertNil(store[type3.id])
        XCTAssertEqual(store[type1.id]?.type4.count, 0)
        XCTAssertNil(store[type1.id]?.type2)

        store.upsert(type2)

        XCTAssertEqual(store.count, 2)
        XCTAssertEqual(store[type1.id]?.primary, type1)
        XCTAssertEqual(store[type2.id]?.primary, type2)
        XCTAssertEqual(store[type1.id]?.type4.count, 0)
        XCTAssertEqual(store[type1.id]?.type2?.primary, type2)
    }

    func test_resourceStoreFromDocument() {
        let t1Id = "1234"
        let t2Id = "5678"
        let t3Id = "910112"

        let date = Date()

        let type3 = Type3(
            id: .init(rawValue: t3Id),
            attributes: .init(int: 1234),
            relationships: .init(type2: .init(id: .init(rawValue: t2Id))),
            meta: .none,
            links: .none
        )

        let type2 = Type2(
            id: .init(rawValue: t2Id),
            attributes: .init(string: "hello world"),
            relationships: .init(
                type1: .init(id: .init(rawValue: t1Id)),
                type3: .init(id: .init(rawValue: t3Id))
            ),
            meta: .none,
            links: .none
        )

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

        let type4 = Type4(
            id: "1111",
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let document = JSONAPI.Document<SingleResourceBody<Type1>, NoMetadata, NoLinks, Include3<Type2, Type3, Type4>, NoAPIDescription, UnknownJSONAPIError>(
            apiDescription: .none,
            body: .init(resourceObject: type1),
            includes: .init(values: [.init(type2), .init(type3)]),
            meta: .none,
            links: .none
        )

        let store = document.resourceStore()!

        XCTAssertEqual(store.count, 3)
        XCTAssertEqual(store[type1.id]?.primary, type1)
        XCTAssertEqual(store[type2.id]?.primary, type2)
        XCTAssertEqual(store[type1.id]?.createdAt, date)
        XCTAssertEqual(store[type1.id]?.type4.count, 0)
        XCTAssertEqual(store[type1.id]?.type2?.primary, type2)
        XCTAssertEqual(store[type1.id]?.type2?.type3?.primary, type3)
        XCTAssertEqual(store[type1.id]?.type2?.type3?.int, 1234)

        store.upsert(type4)

        XCTAssertEqual(store[type4.id]?.primary, type4)
    }
}

enum Type1Description: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "type1"

    struct Attributes: JSONAPI.Attributes {
        let createdAt: Attribute<Date>
    }

    struct Relationships: JSONAPI.Relationships {
        let type2: ToOneRelationship<Type2, NoIdMetadata, NoMetadata, NoLinks>
        let type4: ToManyRelationship<Type4, NoIdMetadata, NoMetadata, NoLinks>
    }
}

typealias Type1 = JSONAPI.ResourceObject<Type1Description, NoMetadata, NoLinks, String>

enum Type2Description: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "type2"

    struct Attributes: JSONAPI.Attributes {
        let string: Attribute<String>
    }

    struct Relationships: JSONAPI.Relationships {
        let type1: ToOneRelationship<Type1, NoIdMetadata, NoMetadata, NoLinks>
        let type3: ToOneRelationship<Type3, NoIdMetadata, NoMetadata, NoLinks>
    }
}

typealias Type2 = JSONAPI.ResourceObject<Type2Description, NoMetadata, NoLinks, String>

enum Type3Description: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "type3"

    struct Attributes: JSONAPI.Attributes {
        let int: Attribute<Int>
    }

    struct Relationships: JSONAPI.Relationships {
        let type2: ToOneRelationship<Type2, NoIdMetadata, NoMetadata, NoLinks>
    }
}

typealias Type3 = JSONAPI.ResourceObject<Type3Description, NoMetadata, NoLinks, String>

enum Type4Description: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "type4"

    typealias Attributes = NoAttributes
    typealias Relationships = NoRelationships
}

typealias Type4 = JSONAPI.ResourceObject<Type4Description, NoMetadata, NoLinks, String>
