//
//  AuthenticationModel.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation
import LocalAuthentication

class AuthenticationModel: ObservableObject {
    private var context = LAContext()

    func authenticate(completion: @escaping (_ isAuthenticated: Bool, _ hasError: Bool) -> ()) {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                if success {
                    completion(true, false)
                } else {
                    completion(false, false)
                }
            }
        } else {
            completion(false, true)
        }
    }
}
