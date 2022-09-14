//
//  File.swift
//  
//
//  Created by TarraeRarae on 07.09.2022.
//

import Foundation
import Vapor

struct GoodsController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let goods = routes.grouped("goods")
    goods.get("getAll", use: getAll)
    goods.get("getElement", ":id", use: getElement)
    goods.post("getElements", use: getElements)
    goods.post("create", use: create)
    goods.delete("delete", ":goodID", use: delete)
  }

  func getAll(req: Request) async throws -> Response {
    let response = try await Good.query(on: req.db).all()
    let result = try await response.encodeResponse(
      status: .ok,
      headers: HTTPHeaders([("Access-Control-Allow-Origin", "*")]),
      for: req
    )
    return result
  }

  func getElement(req: Request) async throws -> Response {
    guard let idString = req.parameters.get("id"),
          let id = UUID(uuidString: idString) else {
      throw Abort(.notFound)
    }

    guard let result = try await Good.find(id, on: req.db) else {
      throw Abort(.custom(code: 500, reasonPhrase: HTTPErrors.serverError))
    }

    let response = try await result.encodeResponse(
      status: .ok,
      headers: HTTPHeaders([("Access-Control-Allow-Origin", "*")]),
      for: req
    )

    return response
  }

  func getElements(req: Request) async throws -> Response {
    do {
      let goodsData = try req.content.decode(MultipleUUIDs.self)

      var result = [Good]()

      for item in goodsData.data {
        do {
          guard let element = try await Good.find(item.uuid, on: req.db) else {
            throw Abort(.custom(code: 401, reasonPhrase: "Not found id: \(item)"))
          }
          result.append(element)
        } catch {
          throw Abort(.custom(code: 500, reasonPhrase: HTTPErrors.serverError))
        }
      }

      let response = try await result.encodeResponse(
        status: .ok,
        headers: HTTPHeaders([("Access-Control-Allow-Origin", "*")]),
        for: req
      )

      return response

    } catch(let error) {
      throw Abort(.custom(code: 500, reasonPhrase: error.localizedDescription))
    }
  }

  func create(req: Request) async throws -> HTTPStatus {
    print(req.content)
    let goodData = try req.content.decode(Good.self)

    do {
      try await goodData.save(on: req.db)
    } catch {
      throw Abort(.custom(code: 500, reasonPhrase: HTTPErrors.serverError))
    }

    return .ok
  }

  func delete(req: Request) async throws -> HTTPStatus {
    guard let idString = req.parameters.get("goodID") else {
      throw Abort(.custom(code: 400, reasonPhrase: "ID parameter was missed"))
    }

    guard let id = UUID(uuidString: idString),
          let goodData = try await Good.find(id, on: req.db) else {
      throw Abort(.notFound)
    }

    do {
      try await goodData.delete(on: req.db)
    } catch {
      throw Abort(.custom(code: 500, reasonPhrase: HTTPErrors.serverError))
    }

    return .ok
  }
}
