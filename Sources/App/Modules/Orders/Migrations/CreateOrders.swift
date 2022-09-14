//
//  CreateGoods.swift
//  
//
//  Created by TarraeRarae on 13.09.2022.
//

import Foundation
import FluentKit

struct CreateOrders: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("orders")
      .id()
      .field("goodsID", .uuid, .required)
      .field("goodsAmount", .int, .required)
      .field("orderID", .int)
      .create()
  }

  func revert(on database: Database) async throws {
    try await database.schema("orders").delete()
  }
}
