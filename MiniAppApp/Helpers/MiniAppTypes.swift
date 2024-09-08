//
//  MiniAppTypes.swift
//  MiniAppApp
//
//  Created by user on 08.09.2024.
//

import Foundation

enum MiniAppType {
    case dice, counter
}

enum DiceType: Int, CaseIterable {
    case d6 = 6, d12 = 12, d20 = 20
    
    var description: String {
        switch self {
        case .d6: return "D6"
        case .d12: return "D12"
        case .d20: return "D20"
        }
    }
}

enum CounterType: CaseIterable {
    case bw, colored
}
