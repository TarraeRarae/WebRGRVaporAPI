//
//  CreateGood.swift
//  
//
//  Created by TarraeRarae on 05.09.2022.
//

import Fluent

struct CreateGoods: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("goods")
      .id()
      .field("name", .string, .required)
      .field("price", .int32, .required)
      .field("weight", .int32, .required)
      .field("image", .string)
      .field("description", .string)
      .create()
  }

  func revert(on database: Database) async throws {
    try await database.schema("goods").delete()
  }
}
