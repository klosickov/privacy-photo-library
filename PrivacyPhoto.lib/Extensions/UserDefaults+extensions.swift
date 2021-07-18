import Foundation

extension UserDefaults {
    
    static func setAppWasLaunched() {
        standard.set(true, forKey: Keys.wasAppLaunched.rawValue)
    }
    
    static func wasAppLaunched() -> Bool {
        return standard.bool(forKey: Keys.wasAppLaunched.rawValue)
    }
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
