//
//  PasswordListModel.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/10/22.
//

import Foundation
import BigInt


class PasswordListModel: ObservableObject{
    @Published var blockNumber: Int = 0
    @Published var accountBalance: BigInt = 0
    @Published var hasError = false
    @Published var error: String?
    @Published var selection: Int?
    @Published var passwordSize: BigUInt = 0
    @Published var passwords: [CommonPassword] = []
    
    func update(){
        self.blockNumber = 3
    }
    
}
