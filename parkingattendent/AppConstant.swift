//
//  AppConstant.swift
//  parkingattendent
//
//  Created by Sy Le on 10/16/17.
//  Copyright © 2017 Sy Le. All rights reserved.
//

import Foundation

class AppConstant {
//    auth api
    static let apiLogin = AppUtil.getResourceUrl(apiUrl: "/login/mobile")
    static let apiLogout = AppUtil.getResourceUrl(apiUrl: "/logout/mobile")
    
//  note api
    static let apiNote = AppUtil.getResourceUrl(apiUrl: "/api/v1/note")
    static let apiNoteByLicenseNumber = AppUtil.getResourceUrl(apiUrl: "/api/v1/note/licensenumber")
    static let apiNoteByUserId = AppUtil.getResourceUrl(apiUrl: "/api/v1/note/userid")
    
//  violation api
    static let apiViolation = AppUtil.getResourceUrl(apiUrl: "/api/v1/violation")
    static let apiViolationeByLicenseNumber = AppUtil.getResourceUrl(apiUrl: "/api/v1/violation/licensenumber")
    static let apiViolationByUserId = AppUtil.getResourceUrl(apiUrl: "/api/v1/violation/userid")
}
