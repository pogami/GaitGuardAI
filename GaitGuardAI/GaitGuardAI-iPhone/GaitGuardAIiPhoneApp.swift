// GaitGuardiPhoneApp.swift
import SwiftUI

@main
struct GaitGuardiPhoneApp: App {
    @StateObject private var connectivity = WatchConnectivityManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(connectivity)
        }
    }
}

