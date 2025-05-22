import Foundation
import Alamofire

enum AppError: Error, LocalizedError {
    case networkError(String)
    case decodingError(String)
    case apiError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message): return message
        case .decodingError(let message): return message
        case .apiError(let message): return message
        case .unknown: return "Bilinmeyen bir hata oluştu."
        }
    }
}

protocol BaseServiceProtocol {
    func request<T: Decodable>(endpoint: String, parameters: [String: Any], completion: @escaping (Result<T, AppError>) -> Void)
}

class BaseService: BaseServiceProtocol {
    private let baseURL = "https://www.omdbapi.com/"
    private let apiKey = "e20a3a8a"
    
    func request<T: Decodable>(endpoint: String, parameters: [String: Any], completion: @escaping (Result<T, AppError>) -> Void) {
        var params = parameters
        params["apikey"] = apiKey
        let url = baseURL + endpoint
        AF.request(url, parameters: params)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        if let responseStr = json?["Response"] as? String, responseStr == "False" {
                            let errorMsg = json?["Error"] as? String ?? "API hatası"
                            completion(.failure(.apiError(errorMsg)))
                            return
                        }
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(.decodingError(error.localizedDescription)))
                    }
                case .failure(let error):
                    completion(.failure(.networkError(error.localizedDescription)))
                }
            }
    }
} 