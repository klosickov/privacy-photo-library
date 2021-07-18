import Foundation

class ImageData: NSCoder, Codable {
    
    var imageName: String
    var comment: String
    var isFavorite: Bool
    
    init(imageName: String, comment: String = "", isFavorite: Bool = false) {
        self.imageName = imageName
        self.comment = comment
        self.isFavorite = isFavorite
    }
    
    public enum CodingKeys: String, CodingKey {
        case imageName, comment, isFavorite
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.imageName, forKey: .imageName)
        try container.encode(self.comment, forKey: .comment)
        try container.encode(self.isFavorite, forKey: .isFavorite)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.comment = try container.decode(String.self, forKey: .comment)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
}
