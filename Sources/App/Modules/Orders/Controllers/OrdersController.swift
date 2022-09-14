//
//  OrdersController.swift
//  
//
//  Created by TarraeRarae on 13.09.2022.
//

import Vapor

struct OrdersController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let orders = routes.grouped("orders")
    orders.get("getAll", use: getAll)
    orders.post("create", use: create)
    orders.delete("delete", ":orderID",use: delete)
  }

  func getAll(req: Request) async throws -> Response {
      let orders = try await Order.query(on: req.db).all()
      let response = try await orders.encodeResponse(
        status: .ok,
        headers: HTTPHeaders([("Access-Control-Allow-Origin", "*")]),
        for: req
      )
      return response
  }

  func create(req: Request) async throws -> HTTPStatus {
    let orderGoods = try req.content.decode(Orders.self)
    let orders = try await Order.query(on: req.db).all()
    if orders.count == 0 {
      for item in orderGoods.data {
        item.orderID = 0
      }
    } else {
      let maxOrderID = orders.max(by: { $0.orderID ?? 0 < $1.orderID ?? 0 })?.orderID ?? 0
      
      for item in orderGoods.data {
        item.orderID = maxOrderID + 1
      }
    }
    do {
      for item in orderGoods.data {
        try await item.save(on: req.db)
      }
    } catch {
      throw Abort(.custom(code: 500, reasonPhrase: HTTPErrors.serverError))
    }
    
    return .ok
  }

  func delete(req: Request) async throws -> HTTPStatus {
    guard let orderNumberString = req.parameters.get("orderID"),
          let orderID = Int(orderNumberString) else {
      throw Abort(.notFound)
    }

    let orders = try await Order.query(on: req.db).all()
    let ordersWithActualOrderID = orders.filter({ $0.orderID ?? -1 == orderID })

    do {
      for item in ordersWithActualOrderID {
        try await item.delete(on: req.db)
      }
    } catch {
      throw Abort(.custom(code: 500, reasonPhrase: HTTPErrors.serverError))
    }

    return .ok
  }
}
