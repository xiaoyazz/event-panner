//
//  Event.swift
//  EventPlanner
//
//  Created by Jinling Cai on 2023-04-19.
//

import UIKit

class Event: NSObject {
    var id: Int?
    var title: String?
    var dateTime: Date?
    var eventType: String?
    var host: String?
    var locationName: String?
    var address: String?
    var city: String?
    var province: String?
    var postalCode: String?
    var phoneNumber: String?
    
    func initWithData(id: Int?, title: String?, dateTime: Date?, eventType: String?, host: String?, locationName: String?, address: String?, city: String?, province: String?, postalCode: String?, phoneNumber: String?) {
            self.id = id
            self.title = title
            self.dateTime = dateTime
            self.eventType = eventType
            self.host = host
            self.locationName = locationName
            self.address = address
            self.city = city
            self.province = province
            self.postalCode = postalCode
            self.phoneNumber = phoneNumber
        }

}
