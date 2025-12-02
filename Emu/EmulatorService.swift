import Foundation
internal import Combine

class EmulatorService: ObservableObject {
    @Published var emulators: [Emulator] = []
    @Published var errorMessage: String?
    
    // Default path, can be overridden by settings
    private var sdkPath: String {
        UserDefaults.standard.string(forKey: "androidSdkPath") ?? "/Users/azzam/Library/Android/sdk"
    }
    
    private var emulatorPath: String {
        let path = "\(sdkPath)/emulator/emulator"
        print("Emulator path: \(path)")
        return path
    }
    
    func listAvds() {
        runCommand(arguments: ["-list-avds"]) { [weak self] output, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to list AVDs: \(error)"
                    return
                }
                
                if let output = output {
                    let names = output.components(separatedBy: .newlines)
                        .filter { !$0.isEmpty }
                    self?.emulators = names.map { Emulator(name: $0) }
                    self?.errorMessage = nil
                }
            }
        }
    }
    
    func runAvd(name: String, options: [String] = []) {
        // Running emulator in detached process via shell
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/sh")
        
        var args = ["-avd", "\"\(name)\""]
        args.append(contentsOf: options)
        
        let command = "\"\(emulatorPath)\" \(args.joined(separator: " "))"
        task.arguments = ["-c", command]
        
        var env = ProcessInfo.processInfo.environment
        env["ANDROID_HOME"] = sdkPath
        env["ANDROID_SDK_ROOT"] = sdkPath
        task.environment = env
        
        // We don't wait for it to finish, just launch it
        do {
            try task.run()
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to run AVD \(name): \(error.localizedDescription)"
            }
        }
    }
    
    private func runCommand(arguments: [String], completion: @escaping (String?, String?) -> Void) {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/sh")
        
        // Construct the command string
        let command = "\"\(emulatorPath)\" \(arguments.joined(separator: " "))"
        task.arguments = ["-c", command]
        
        // Set environment variables
        var env = ProcessInfo.processInfo.environment
        env["ANDROID_HOME"] = sdkPath
        env["ANDROID_SDK_ROOT"] = sdkPath
        task.environment = env
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        do {
            try task.run()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)
            completion(output, nil)
        } catch {
            completion(nil, error.localizedDescription)
        }
    }
}
