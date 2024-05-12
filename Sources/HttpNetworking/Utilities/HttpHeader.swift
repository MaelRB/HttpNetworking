import Foundation

public struct HttpHeader: Sendable {
    let field: String
    let value: String
    
    public init(
        field: String,
        value: String
    ) {
        self.field = field
        self.value = value
    }
}
