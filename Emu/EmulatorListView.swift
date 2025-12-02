import SwiftUI

struct EmulatorListView: View {
    @StateObject private var service = EmulatorService()
    
    var body: some View {
        VStack {
            if let errorMessage = service.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            List(service.emulators) { emulator in
                HStack {
                    Image(systemName: "phone") // Placeholder icon, SF Symbols doesn't have android. Maybe "phone" or "display"
                    Text(emulator.name)
                    Spacer()
                    Menu {
                        Button("Run") {
                            service.runAvd(name: emulator.name)
                        }
                        Button("Cold Boot") {
                            service.runAvd(name: emulator.name, options: ["-no-snapshot-load"])
                        }
                        Button("Wipe Data") {
                            service.runAvd(name: emulator.name, options: ["-wipe-data"])
                        }
                        Button("No Boot Animation") {
                            service.runAvd(name: emulator.name, options: ["-no-boot-anim"])
                        }
                    } label: {
                        Label("Run", systemImage: "play.fill")
                    }
                }
            }
            .toolbar {
                Button(action: {
                    service.listAvds()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .onAppear {
            service.listAvds()
        }
    }
}
