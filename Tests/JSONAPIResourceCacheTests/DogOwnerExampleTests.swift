//
//  DogOwnerExampleTests.swift
//  
//
//  Created by Mathew Polzin on 5/31/20.
//

import XCTest


import JSONAPI
import JSONAPIResourceCache
// snag Foundation for Data and JSONDecoder
import Foundation


/*
 1. We will begin by quickly redefining the same types of `ResourceObjects` from the [Basic Example](https://colab.research.google.com/drive/1IS7lRSBGoiW02Vd1nN_rfdDbZvTDj6Te).
 */
typealias Resource<Description: JSONAPI.ResourceObjectDescription> = JSONAPI.ResourceObject<Description, NoMetadata, NoLinks, String>

struct PersonDescription: ResourceObjectDescription {

    static let jsonType: String = "people"

    struct Attributes: JSONAPI.Attributes {
        let firstName: Attribute<String>
        let lastName: Attribute<String>

        /// User is not required to specify their age.
        let age: Attribute<Int?>
    }

    struct Relationships: JSONAPI.Relationships {
        let pets: ToManyRelationship<Dog, NoMetadata, NoLinks>
    }
}

typealias Person = Resource<PersonDescription>

struct DogDescription: ResourceObjectDescription {
    static let jsonType: String = "dogs"

    struct Attributes: JSONAPI.Attributes {
        let name: Attribute<String>
    }

    typealias Relationships = NoRelationships
}

typealias Dog = Resource<DogDescription>

/*
 2. We can borrow the Document typealiases from the [Compound Example](https://colab.research.google.com/drive/1BdF0Kc7l2ixDfBZEL16FY6palweDszQU#scrollTo=TDVjdxF8yKeR).
 */
/// Our JSON:API Documents will still have no metadata or links associated with them but they will allow us to specify an include type later.
typealias SingleDocument<Resource: ResourceObjectType, Include: JSONAPI.Include> = JSONAPI.Document<SingleResourceBody<Resource>, NoMetadata, NoLinks, Include, NoAPIDescription, UnknownJSONAPIError>

typealias BatchDocument<Resource: ResourceObjectType, Include: JSONAPI.Include> = JSONAPI.Document<ManyResourceBody<Resource>, NoMetadata, NoLinks, Include, NoAPIDescription, UnknownJSONAPIError>

/*
 3. We define a resource cache capable of storing `Person` and `Dog` types. As a convenience, we define what it means to merge two `Caches`. The `merge` method is not a requirement of `ResourceCache` but it will allow us to easily add resources from our JSON:API document to our cache.

    We are going to use a value type for the cache. A reference type (like the one in the `JSONAPIResourceStore` module in this package) could also be used, but an equatable value type works well when you want your app state to be comparable so your logic can determine when the cache has changed.
 */
struct Cache: Equatable, ResourceCache {
    var people: ResourceHash<Person> = [:]
    var dogs: ResourceHash<Dog> = [:]

    mutating func merge(_ other: Cache) {
        // we merge and resolve conflicts with `other`'s versions so we effectively
        // "add or update" each resource.
        people.merge(other.people, uniquingKeysWith: { $1 })
        dogs.merge(other.dogs, uniquingKeysWith: { $1 })
    }
}

/*
 4. We need to tell people and dogs where to find themselves in the cache.
 */
extension PersonDescription: Materializable {
    static var cachePath: WritableKeyPath<Cache, ResourceHash<Person>> { \.people }
}

extension DogDescription: Materializable {
    static var cachePath: WritableKeyPath<Cache, ResourceHash<Dog>> { \.dogs }
}


final class DogOwnerExampleTests: XCTestCase {
    func test_Example() throws {

        /*
         5. Let's create our app-wide cache of resources. We are going to use a value type; a reference type could be used just as well, but a value type that is equatable
         */
        var cache = Cache()

        /*
         6. Now let's define a mock response containing a single person and including any dogs that are related to that person.
         */
        let mockSinglePersonResponse =
"""
{
  "data": {
    "type": "people",
    "id": "88223",
    "attributes": {
      "first_name": "Lisa",
      "last_name": "Offenbrook",
      "age": null
    },
    "relationships": {
      "pets": {
        "data": [
          {
            "type": "dogs",
            "id": "123"
          },
          {
            "type": "dogs",
            "id": "456"
          }
        ]
      }
    }
  },
  "included": [
    {
      "type": "dogs",
      "id": "123",
      "attributes": {
        "name": "Sparky"
      }
    },
    {
      "type": "dogs",
      "id": "456",
      "attributes": {
        "name": "Charlie Dog"
      }
    }
  ]
}
""".data(using: .utf8)!

        /*
         7. We decode a document like the one mocked above as a `SingleDocument` specialized on a primary resource type of `Person` and an include type of `Include1<Dog>` (a.k.a. all included resources will be of the same type: `Dog`).
         */
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let document = try decoder.decode(SingleDocument<Person, Include1<Dog>>.self, from: mockSinglePersonResponse)

        /*
         8. We can ask `document` for a cache of resources it contains. Then we can merge that into our app-wide cache.
         */
        if let documentResources = document.resourceCache() {
            cache.merge(documentResources)
        } else {
            // probably time to check for an error response.
        }

        /*
         9. We can access all people in the cache.
         */
        for person in cache.people.values {
            print("\(person.firstName) \(person.lastName) has \((person ~> \.pets).count) dogs.")
        }

        /*
         10. We can access those dogs via the cache using the cache's subscript operator.
         */
        for person in cache.people.values {
            print("\(person.firstName) \(person.lastName) has pets named:")
            for dogId in (person ~> \.pets) {
                print(cache[dogId]?.name ?? "missing dog info")
            }
        }

        /*
         11. We can also map the dog ids to materialized dogs.
         */
        for person in cache.people.values {
            let dogs = (person ~> \.pets).compactMap { $0.materialized(from: cache) }
            let dogNames = dogs.map(\.name).joined(separator: ", ")

            print("\(person.firstName) \(person.lastName) has pets named: \(dogNames)")
        }
    }
}
