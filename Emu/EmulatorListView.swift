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
            
            List {
                Section(header: Text("Android")) {
                    ForEach(service.emulators.filter { $0.type == .android }) { emulator in
                        EmulatorRow(emulator: emulator, service: service)
                    }
                }
                
                Section(header: Text("iOS")) {
                    ForEach(service.emulators.filter { $0.type == .ios }) { emulator in
                        EmulatorRow(emulator: emulator, service: service)
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
