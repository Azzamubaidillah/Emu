import SwiftUI

struct EmulatorRow: View {
    let emulator: Emulator
    @ObservedObject var service: EmulatorService
    
    var body: some View {
        HStack {
            Image(systemName: emulator.type == .android ? "logo.android" : "applelogo") // SF Symbols doesn't have android logo, using generic or maybe "phone"
                .foregroundColor(emulator.type == .android ? .green : .primary)
            Text(emulator.name)
            Spacer()
            
            if emulator.type == .android {
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
            } else {
                Button(action: {
                    if let uuid = emulator.uuid {
                        service.runSimulator(uuid: uuid)
                    }
                }) {
                    Image(systemName: "play.fill")
                }
            }
        }
    }
}
