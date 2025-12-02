import SwiftUI

struct EmulatorRow: View {
    let emulator: Emulator
    @ObservedObject var service: EmulatorService
    
    var body: some View {
        HStack {
            Image(systemName: emulator.type == .android ? "iphone" : "applelogo") 
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
                VStack(alignment: .trailing) {
                    if let version = emulator.osVersion {
                        Text(version)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Menu {
                        Button("Boot") {
                            if let uuid = emulator.uuid {
                                service.runSimulator(uuid: uuid)
                            }
                        }
                        Button("Shutdown") {
                            if let uuid = emulator.uuid {
                                service.shutdownSimulator(uuid: uuid)
                            }
                        }
                        Divider()
                        Button("Erase Content & Settings", role: .destructive) {
                            if let uuid = emulator.uuid {
                                service.eraseSimulator(uuid: uuid)
                            }
                        }
                    } label: {
                        Label("Actions", systemImage: "ellipsis.circle")
                    }
                    .menuStyle(.borderlessButton)
                    .fixedSize()
                }
            }
        }
    }
}
