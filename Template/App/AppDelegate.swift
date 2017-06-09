//
//  AppDelegate.swift
//  RedPanda
//
//

import UIKit
import RedPanda
import PluggableApplicationDelegate

@UIApplicationMain
class AppDelegate: RedPandaApplicationDelegate {

    override var services: [ApplicationService] {
        return [
            ApplicationLifeCycleService()
        ]
    }


}
