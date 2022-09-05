//
//  Admin.swift
//  
//
//  Created by TarraeRarae on 04.09.2022.
//

import Fluent
import Vapor
import PostgresNIO

final class Admin: Model, Content {
  static var schema = "admins"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "email")
  var email: String

  @Field(key: "password")
  var password: String

  init() {}

  init(email: String, password: String) {
    self.email = email
    self.password = password
  }
}

//extension Admin: Migration {
//   static func prepare(on connection: PostgresConnection) -> Future<Void> {
//       return Database.create(self, on: connection) { builder in
//           try addProperties(to: builder)
//           builder.unique(on: \.email)
//       }
//   }
//}
