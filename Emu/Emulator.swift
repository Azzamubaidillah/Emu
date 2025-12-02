import Foundation

enum EmulatorType {
    case android
    case ios
}

struct Emulator: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let type: EmulatorType
    let uuid: String? // For iOS simulators
}
