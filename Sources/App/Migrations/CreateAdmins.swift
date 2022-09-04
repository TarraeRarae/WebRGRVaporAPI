//
//  File.swift
//  
//
//  Created by TarraeRarae on 04.09.2022.
//

import Fluent

struct CreateAdmins: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("admins")
      .id()
      .field("email", .string, .required)
      .field("password", .string, .required)
      .create()
  }
  
  func revert(on database: Database) async throws {
    try await database.schema("admins").delete()
  }
}
