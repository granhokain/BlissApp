//
//  RunTimeError.swift
//  BlissApp
//
//  Created by Rafael Martins on 21/12/20.
//

import Foundation

struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
