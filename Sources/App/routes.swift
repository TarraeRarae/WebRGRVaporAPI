import Fluent
import Vapor

func routes(_ app: Application) throws {
  try app.register(collection: AdminController())
  try app.register(collection: GoodsController())
  try app.register(collection: OrdersController())
}
