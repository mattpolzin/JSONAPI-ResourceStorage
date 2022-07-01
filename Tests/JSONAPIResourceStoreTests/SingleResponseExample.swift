//
//  SingleResponseExample.swift
//
//  An example that shows easy ResourceStore usage for a single response.
//  In essence, what it might look like to treat a single response as the whole
//  world; accessing any resources from that response without worrying about how
//  those resources are or are not stored locally.
//
//  Created by Mathew Polzin on 7/1/22.
//

import XCTest
import JSONAPI
import JSONAPIResourceCache
    // snag Foundation for Data and JSONDecoder
import Foundation


/*
 We will begin by quickly redefining the same types of `ResourceObjects` from the [Basic Example](https://colab.research.google.com/drive/1IS7lRSBGoiW02Vd1nN_rfdDbZvTDj6Te).
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
        let pets: ToManyRelationship<Dog, NoIdMetadata, NoMetadata, NoLinks>
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
 We can borrow the Document typealiases from the [Compound Example](https://colab.research.google.com/drive/1BdF0Kc7l2ixDfBZEL16FY6palweDszQU#scrollTo=TDVjdxF8yKeR).
 */
    /// Our JSON:API Documents will still have no metadata or links associated with them but they will allow us to specify an include type later.
typealias SingleDocument<Resource: ResourceObjectType, Include: JSONAPI.Include> = JSONAPI.Document<SingleResourceBody<Resource>, NoMetadata, NoLinks, Include, NoAPIDescription, UnknownJSONAPIError>

typealias BatchDocument<Resource: ResourceObjectType, Include: JSONAPI.Include> = JSONAPI.Document<ManyResourceBody<Resource>, NoMetadata, NoLinks, Include, NoAPIDescription, UnknownJSONAPIError>

final class SingleResponseExampleTests: XCTestCase {
    func test_Example() throws {

        /*
         Now let's define a mock response containing a single person and including any dogs that are related to that person.
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
         We decode a document like the one mocked above as a `SingleDocument` specialized on a primary resource type of `Person` and an include type of `Include1<Dog>` (a.k.a. all included resources will be of the same type: `Dog`).
         */
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let document = try decoder.decode(SingleDocument<Person, Include1<Dog>>.self, from: mockSinglePersonResponse)

        /*
         We can ask `document` for a resource store if we want to merge it with an existing resource store, but we won't do that in this example.
         */
//        guard let documentResources = document.resourceStore() else {
//            // probably time to check for an error response.
//        }
//        existingResource.merge(documentResources)

        /*
         We can access the person in the document.
         */
        if let person = document.storedPrimaryResource() {
            print("\(person.firstName) \(person.lastName) found in API response.")

            /*
             We can access that person's dogs via the person using the stored resource.
             */
            print("\(person.firstName) \(person.lastName) has pets named:")
            for dog in person.pets {
                print(dog.name)
            }
        }
    }
}
