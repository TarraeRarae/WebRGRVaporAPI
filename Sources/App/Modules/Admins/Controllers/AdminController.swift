//
//  AdminController.swift
//  
//
//  Created by TarraeRarae on 04.09.2022.
//

import Fluent
import Vapor

struct AdminController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let admins = routes.grouped("admin")
    admins.post("create", use: create)
    admins.get("getAll", use: getAll)
    admins.put("update", use: update)
    admins.delete("delete", ":uuid", use: delete)
    admins.post("login", use: login)
  }

  func getAll(req: Request) async throws -> [Admin] {
    try await Admin.query(on: req.db).all()
  }

  func create(req: Request) async throws -> HTTPStatus {
    print(req.content)
    let adminData = try req.content.decode(Admin.self)

    if try await Admin.query(on: req.db).filter(\.$email == adminData.email).count() > 0 {
      throw Abort(.custom(code: 400, reasonPhrase: "User is already registered"))
    }

    let validationResult = validateAdminData(data: adminData)
    if !validationResult.0 {
      throw Abort(.custom(code: 400, reasonPhrase: validationResult.1?.description ?? ""))
    }

    do {
      try await adminData.save(on: req.db)
    } catch {
      throw Abort(.custom(
        code: 500,
        reasonPhrase: HTTPErrors.serverError)
      )
    }

    return .ok
  }

  func update(req: Request) async throws -> HTTPStatus {
    let adminData = try req.content.decode(Admin.self)

    if adminData.email.count == 0 && adminData.password.count == 0 {
      throw Abort(.badRequest)
    }

    let validationResult = validateAdminData(data: adminData)
    if !validationResult.0 {
      if !((validationResult.1 == .badEmail && adminData.email.count == 0) ||
          (validationResult.1 == .badPassword && adminData.password.count == 0)) {
        throw Abort(.custom(code: 400, reasonPhrase: validationResult.1?.description ?? ""))
      }
    }

    guard let adminDataFromDB = try await Admin.find(adminData.id, on: req.db) else {
      throw Abort(.notFound)
    }

    if adminData.email.count > 0 {
      adminDataFromDB.email = adminData.email
    }

    if adminData.password.count > 0 {
      adminDataFromDB.password = adminData.password
    }

    try await adminDataFromDB.update(on: req.db)

    return .ok
  }

  func delete(req: Request) async throws -> HTTPStatus {
    guard let adminIDString = req.parameters.get("uuid"),
          let adminID = UUID(uuidString: adminIDString),
          let adminDataFromDB = try await Admin.find(adminID, on: req.db) else {
      throw Abort(.notFound)
    }

    try await adminDataFromDB.delete(on: req.db)
    return .ok
  }

  func login(req: Request) async throws -> HTTPStatus {
    let adminData = try req.content.decode(Admin.self)
    let admins = Admin.query(on: req.db).filter(\.$email == adminData.email)

    if try await admins.count() == 0 {
      throw Abort(.custom(code: 400, reasonPhrase: "Incorrect email or password"))
    }

    if try await admins.first()?.password ?? "" != adminData.password {
      throw Abort(.custom(code: 400, reasonPhrase: "Incorrect password or password"))
    }

    return .ok
  }
}

// MARK: - Private

private extension AdminController {
  func validateAdminData(data: Admin) -> (Bool, ValidationError?) {
    if !Validator.shared.checkIsEmailValid(email: data.email) {
      return (false, .badEmail)
    }

    if !Validator.shared.checkIsPasswordValid(password: data.password) {
      return (false, .badPassword)
    }

    return (true, nil)
  }
}
