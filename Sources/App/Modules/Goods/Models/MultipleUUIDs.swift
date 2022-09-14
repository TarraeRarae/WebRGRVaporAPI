//
//  File.swift
//  
//
//  Created by TarraeRarae on 11.09.2022.
//

import Foundation

struct MultipleUUIDs: Codable {
  let data: [SingleUUID]
}

struct SingleUUID: Codable {
  let uuid: UUID?
}
