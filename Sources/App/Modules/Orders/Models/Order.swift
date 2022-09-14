//
//  Order.swift
//  
//
//  Created by TarraeRarae on 13.09.2022.
//

import Fluent
import Vapor
import PostgresNIO

final class Orders: Codable {
  let data: [Order]
}

final class Order: Model, Content {
  static var schema = "orders"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "goodsID")
  var goodsID: UUID

  @Field(key: "goodsAmount")
  var goodsAmount: Int

  @Field(key: "orderID")
  var orderID: Int?

  init() {}

  init(id: UUID?, goodsID: UUID, goodsAmount: Int, orderID: Int?) {
    self.id = id
    self.goodsID = goodsID
    self.goodsAmount = goodsAmount
    self.orderID = orderID
  }
}
