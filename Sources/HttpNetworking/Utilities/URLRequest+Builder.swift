import Foundation

extension URLRequest {
    public final class Builder {
        private var url: String?
        private var httpMethod: HttpMethod = .get
        private var httpBody: (any Encodable)?
        private var headers: [HttpHeader] = []
        private var urlComponents: [String] = []
        private var queryItems: [URLQueryItem] = []
        
        public init() {}
        
        public func withUrl(_ url: String) -> Self {
            self.url = url
            return self
        }
        
        public func withUrlComponent(_ component: String) -> Self {
            self.urlComponents.append(component)
            return self
        }
        
        public func withQueryItem(_ queryItem: URLQueryItem) -> Self {
            self.queryItems.append(queryItem)
            return self
        }
        
        public func withHttpMethod(_ httpMethod: HttpMethod) -> Self {
            self.httpMethod = httpMethod
            return self
        }
        
        public func withHeader(_ header: HttpHeader) -> Self {
            self.headers.append(header)
            return self
        }
        
        public func withHeaders(_ headers: [HttpHeader]) -> Self {
            self.headers.append(contentsOf: headers)
            return self
        }
        
        public func withBody(_ body: any Encodable) -> Self {
            self.httpBody = body
            return self
        }
        
        public func build() throws -> URLRequest {
            guard let url else { throw BuilderError.missingArgument("URL") }
            guard var url = URL(string: url) else { throw BuilderError.invalidArgument("URL") }
            
            for component in urlComponents {
                url.append(component: component)
            }
            
            url.append(queryItems: queryItems)
            
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.field)
            }
            
            if let httpBody {
                let jsonEncoder = JSONEncoder()
                let data = try jsonEncoder.encode(httpBody)
                request.httpBody = data
            }
            
            return request
        }
    }
}

enum BuilderError: Error, Sendable {
    case missingArgument(String)
    case invalidArgument(String)
}

extension [HttpHeader] {
    public static let `default`: [HttpHeader] = [
        HttpHeader(field: "Content-type", value: "application/json"),
        HttpHeader(field: "Accept", value: "application/json, text/plain, */*")
    ]
}
