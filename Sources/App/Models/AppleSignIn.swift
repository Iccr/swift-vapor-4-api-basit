//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation


class Apple {
    struct AccessToken {
      static let expirationTime: TimeInterval = 30 * 24 * 60 * 60 // 30 days
    }

    struct SIWA {
      static let applicationIdentifier =  Environment.get("IOS_APP_ID") ?? ""
      static let servicesIdentifier = "SIWA_SERVICES_IDENTIFIER" //e.g. com.raywenderlich.siwa-vapor.services
      static let redirectURL = "SIWA_REDIRECT_URL" // e.g. https://foobar.ngrok.io/web/auth/siwa/callback
    }
}
