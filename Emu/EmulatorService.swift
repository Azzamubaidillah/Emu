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
        // List Android AVDs
        runCommand(arguments: ["-list-avds"]) { [weak self] output, error in
            guard let self = self else { return }
            
            var androidEmulators: [Emulator] = []
            if let output = output {
                let names = output.components(separatedBy: .newlines)
                    .filter { !$0.isEmpty }
                androidEmulators = names.map { Emulator(name: $0, type: .android, uuid: nil, osVersion: nil) }
            }
            
            // List iOS Simulators
            self.listSimulators { iosSimulators in
                DispatchQueue.main.async {
                    self.emulators = androidEmulators + iosSimulators
                    self.errorMessage = nil
                }
            }
        }
    }
    
    private func listSimulators(completion: @escaping ([Emulator]) -> Void) {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        task.arguments = ["simctl", "list", "devices", "available"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                var simulators: [Emulator] = []
                let lines = output.components(separatedBy: .newlines)
                
                var currentOSVersion: String?
                
                for line in lines {
                    if line.hasPrefix("--") && line.hasSuffix("--") {
                        // Parse OS version header like "-- iOS 17.0 --"
                        let trimmed = line.trimmingCharacters(in: CharacterSet(charactersIn: "- "))
                        currentOSVersion = trimmed
                        continue
                    }
                    
                    // Parse line like: "    iPhone 14 (UUID) (Shutdown)"
                    if line.contains("Shutdown") || line.contains("Booted") {
                        let parts = line.split(separator: "(")
                        if parts.count >= 2 {
                            let name = parts[0].trimmingCharacters(in: .whitespaces)
                            let uuidPart = parts[1]
                            let uuid = uuidPart.replacingOccurrences(of: ")", with: "").trimmingCharacters(in: .whitespaces)
                            
                            simulators.append(Emulator(name: name, type: .ios, uuid: uuid, osVersion: currentOSVersion))
                        }
                    }
                }
                completion(simulators)
                return
            }
        } catch {
            print("Failed to list simulators: \(error)")
        }
        completion([])
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
    
    func runSimulator(uuid: String) {
        // Boot simulator
        let bootTask = Process()
        bootTask.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        bootTask.arguments = ["simctl", "boot", uuid]
        
        try? bootTask.run()
        
        // Open Simulator app
        let openTask = Process()
        openTask.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        openTask.arguments = ["-a", "Simulator"]
        
        try? openTask.run()
    }
    
    func shutdownSimulator(uuid: String) {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        task.arguments = ["simctl", "shutdown", uuid]
        try? task.run()
    }
    
    func eraseSimulator(uuid: String) {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        task.arguments = ["simctl", "erase", uuid]
        try? task.run()
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
