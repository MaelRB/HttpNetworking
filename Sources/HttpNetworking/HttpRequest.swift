import Foundation

public protocol HttpRequest<HttpBody, HttpResponse>: Sendable {
    associatedtype HttpBody: Encodable
    associatedtype HttpResponse: Decodable
    func urlRequest(_ body: HttpBody) throws -> URLRequest
}
