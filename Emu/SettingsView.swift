import SwiftUI

struct SettingsView: View {
    @AppStorage("androidSdkPath") private var sdkPath: String = "/Users/azzam/Library/Android/sdk"
    
    var body: some View {
        Form {
            Section(header: Text("Android SDK")) {
                TextField("SDK Path", text: $sdkPath)
                Text("Default: ~/Library/Android/sdk")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 400, height: 150)
    }
}
