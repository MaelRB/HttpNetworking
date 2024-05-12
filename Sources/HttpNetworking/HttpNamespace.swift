import Foundation

@dynamicMemberLookup
public protocol HttpNamespace: Sendable {
    init()
    subscript<T: HttpRequest>(dynamicMember keyPath: KeyPath<HttpNamespace, T>) -> T { get }
}

extension HttpNamespace {
    public subscript<T: HttpRequest>(dynamicMember keyPath: KeyPath<HttpNamespace, T>) -> T {
        self[keyPath: keyPath]
    }
}
