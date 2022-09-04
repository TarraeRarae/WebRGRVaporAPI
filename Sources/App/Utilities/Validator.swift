//
//  File.swift
//  
//
//  Created by TarraeRarae on 04.09.2022.
//

import Foundation

final class Validator {
  static let shared = Validator()

  func checkIsEmailValid(email: String) -> Bool {
    return email.matches("^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$")
  }

  func checkIsPasswordValid(password: String) -> Bool {
    return password.matches("((?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,})")
  }
}
