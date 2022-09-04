//
//  File.swift
//  
//
//  Created by TarraeRarae on 04.09.2022.
//

import Fluent
import Vapor

struct AdminController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let admins = routes.grouped("admin")
    admins.post(use: create)
    admins.get(use: getAll)
  }

  func getAll(req: Request) async throws -> [Admin] {
    try await Admin.query(on: req.db).all()
  }

  func create(req: Request) async throws -> HTTPStatus {
    let adminData = try req.content.decode(Admin.self)

    if try await Admin.query(on: req.db).filter(\.$email == adminData.email).count() > 0 {
      throw Abort(.custom(code: 400, reasonPhrase: "User is already registered"))
    }

    if !Validator.shared.checkIsEmailValid(email: adminData.email) {
      throw Abort(.custom(code: 400, reasonPhrase: "Email is not valid"))
    }

    if !Validator.shared.checkIsPasswordValid(password: adminData.password) {
      throw Abort(.custom(code: 400, reasonPhrase: "Password is not valid"))
    }

    do {
      try await adminData.save(on: req.db)
    } catch {
      throw Abort(.custom(
        code: 500,
        reasonPhrase: "Server error. Unable to create an account. Please, try again later")
      )
    }

    return .ok
  }
}
