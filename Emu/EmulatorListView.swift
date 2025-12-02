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
            
            HSplitView {
                VStack(alignment: .leading) {
                    Text("Android")
                        .font(.headline)
                        .padding(.leading)
                    List(service.emulators.filter { $0.type == .android }) { emulator in
                        EmulatorRow(emulator: emulator, service: service)
                    }
                }
                .frame(minWidth: 200, maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    Text("iOS")
                        .font(.headline)
                        .padding(.leading)
                    List(service.emulators.filter { $0.type == .ios }) { emulator in
                        EmulatorRow(emulator: emulator, service: service)
                    }
                }
                .frame(minWidth: 200, maxWidth: .infinity)
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
