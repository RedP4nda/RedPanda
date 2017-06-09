//
//  AppDelegate.swift
//  RedPanda
//
//

import UIKit
import RPFramework
import PluggableApplicationDelegate

@UIApplicationMain
class AppDelegate: RPApplicationDelegate {

    override var services: [ApplicationService] {
        return [
            ApplicationLifeCycleService()
        ]
    }


}
