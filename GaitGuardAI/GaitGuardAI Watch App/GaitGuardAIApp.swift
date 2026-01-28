// GaitGuardApp.swift (REMOVE any duplicate SessionManager class from this file)
import SwiftUI

@main
struct GaitGuardApp: App {
    @StateObject private var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
        }
    }
}
