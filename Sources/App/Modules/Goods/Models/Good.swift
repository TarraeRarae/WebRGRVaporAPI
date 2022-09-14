//
//  Good.swift
//  
//
//  Created by TarraeRarae on 07.09.2022.
//

import Fluent
import Vapor
import PostgresNIO

final class Good: Model, Content {
  static var schema = "goods"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "name")
  var name: String

  @Field(key: "price")
  var price: Int32

  @Field(key: "weight")
  var weight: Int32?

  @Field(key: "image")
  var image: String?

  @Field(key: "description")
  var description: String?

  init() {}

  init(name: String, price: Int32, description: String?, image: String?, weight: Int32?) {
    self.name = name
    self.price = price
    self.description = description
    self.image = image
    self.weight = weight
  }
}
