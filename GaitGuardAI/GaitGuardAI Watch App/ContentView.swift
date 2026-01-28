import SwiftUI

struct ContentView: View {
    @StateObject private var engine = MotionDetector()
    @State private var isActive = false
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            // Large Status Icon
            Image(systemName: isActive ? "bolt.shield.fill" : "shield.slash")
                .font(.system(size: 45))
                .foregroundColor(isActive ? .green : .gray)
                .symbolEffect(.pulse, isActive: isActive)
            
            Text(isActive ? "Monitoring Gait" : "Guard is Off")
                .font(.system(.body, design: .rounded).bold())
            
            Spacer()
            
            // The Start/Stop Button
            Button(action: {
                isActive.toggle()
                if isActive {
                    engine.startMonitoring()
                } else {
                    engine.stopMonitoring()
                }
            }) {
                Text(isActive ? "STOP" : "START")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .tint(isActive ? .red : .blue)
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .containerBackground(isActive ? Color.green.gradient : Color.blue.gradient, for: .navigation)
    }
}
