import Foundation

public protocol HttpServer: Sendable {
    associatedtype Namepsace: HttpNamespace
    
    @discardableResult
    func request<Body, Response>(
        _ keyPath: KeyPath<Namepsace, some HttpRequest<Body, Response>>,
        body: Body
    ) async throws -> Response
    
    @discardableResult
    func request<Response>(
        _ keyPath: KeyPath<Namepsace, some HttpRequest<Empty, Response>>
    ) async throws -> Response
    
    func request<Body>(
        _ keyPath: KeyPath<Namepsace, some HttpRequest<Body, Empty>>,
        body: Body
    ) async throws
    
    func request(
        _ keyPath: KeyPath<Namepsace, some HttpRequest<Empty, Empty>>
    ) async throws
}

public final class HttpServerOf<N: HttpNamespace>: HttpServer {
    private let jsonDecoder = JSONDecoder()
    private let namespace = N()
    
    public init() {}
    
    @discardableResult
    public func request<Body, Response>(
        _ keyPath: KeyPath<N, some HttpRequest<Body, Response>>,
        body: Body
    ) async throws -> Response {
        let httpRequest = namespace[keyPath: keyPath]
        let urlRequest = try httpRequest.urlRequest(body)
        let result = try await URLSession.shared.data(for: urlRequest)
        return try jsonDecoder.decode(Response.self, from: result.0)
    }
    
    @discardableResult
    public func request<Response>(
        _ keyPath: KeyPath<N, some HttpRequest<Empty, Response>>
    ) async throws -> Response {
        let httpRequest = namespace[keyPath: keyPath]
        let urlRequest = try httpRequest.urlRequest(Empty())
        let result = try await URLSession.shared.data(for: urlRequest)
        return try jsonDecoder.decode(Response.self, from: result.0)
    }
    
    public func request<Body>(
        _ keyPath: KeyPath<N, some HttpRequest<Body, Empty>>,
        body: Body
    ) async throws {
        let httpRequest = namespace[keyPath: keyPath]
        let urlRequest = try httpRequest.urlRequest(body)
        let _ = try await URLSession.shared.data(for: urlRequest)
    }
    
    public func request(
        _ keyPath: KeyPath<N, some HttpRequest<Empty, Empty>>
    ) async throws {
        let httpRequest = namespace[keyPath: keyPath]
        let urlRequest = try httpRequest.urlRequest(Empty())
        let _ = try await URLSession.shared.data(for: urlRequest)
    }
}
