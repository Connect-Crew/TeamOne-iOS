//
//  ProjectsDataSource.swift
//  Data
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import TeamOneNetwork
import RxSwift
import Core
import Alamofire
import Domain

public protocol ProjectsDataSouceProtocol {
    
    func baseInformation() -> Observable<BaseProjectInformationResponseDTO>
    
    func list(_ request: ProjectListRequestDTO) -> Observable<[ProjectListResponseDTO]>
    
    func like(_ request: ProjectFavoriteRequestDTO) -> Observable<ProjectFavoriteResponseDTO>
    
    func project(_ projectId: Int) -> Observable<ProjectResponseDTO>
    
    func apply(_ request: ProjectApplyRequestDTO) -> Observable<ProjectApplyResponseDTO>
    
    func create(_ request: ProjectCreateRequestDTO) -> Single<ProjectCreateResponseDTO>
}

public struct ProjectsDataSource: ProjectsDataSouceProtocol {
    
    private let provider: ProviderProtocol
    
    public init() {
        self.provider = Provider.default
    }
    
    public func baseInformation() -> Observable<BaseProjectInformationResponseDTO> {
        return provider.request(ProjectsTarget.baseInformation)
    }
    
    public func list(_ request: ProjectListRequestDTO) -> Observable<[ProjectListResponseDTO]> {
        
        return provider.request(ProjectsTarget.list(request: request))
    }
    
    public func like(_ request: ProjectFavoriteRequestDTO) -> Observable<ProjectFavoriteResponseDTO> {
        return provider.request(ProjectsTarget.like(request: request))
    }
    
    public func project(_ projectId: Int) -> Observable<ProjectResponseDTO> {
        return provider.request(ProjectsTarget.project(projectId: projectId))
            .catch { _ in
                return Observable.error(ProjectError.loadFail)
            }
    }
    
    public func apply(_ request: ProjectApplyRequestDTO) -> Observable<ProjectApplyResponseDTO> {
        return provider.request(ProjectsTarget.apply(request: request))
    }
    
    public func create(_ request: ProjectCreateRequestDTO) -> Single<ProjectCreateResponseDTO> {
        
        print("!!!!!!!!!!!\(self)::::")
        print(request)
        print("!!!!!!!!!!!!")
        
        let header: HTTPHeaders =  [
            "Content-Type" : "multipart/form-data",
            "Authorization" : "\(UserDefaultKeyList.Auth.appAccessToken!)"
        ]
        
        let url = "\(NetworkConstant.projectBasedURLString)/project/"
        
        return Single.create { single in
            
            // Alamofire의 upload 함수 사용
            AF.upload(multipartFormData: { multipartFormData in
                
                // 이미지 추가
                for (index, imageData) in request.banner.enumerated() {
                    if let data = imageData {
                        multipartFormData.append(data, withName: "banner", fileName: "banner\(index).jpg", mimeType: "image/jpeg")
                    }
                }
                
                // 텍스트 필드 추가
                multipartFormData.append(request.title.data(using: .utf8)!, withName: "title")
                multipartFormData.append(request.region.data(using: .utf8)!, withName: "region")
                multipartFormData.append("\(request.online)".data(using: .utf8)!, withName: "online")
                multipartFormData.append("\(request.state)".data(using: .utf8)!, withName: "state")
                multipartFormData.append("\(request.careerMin)".data(using: .utf8)!, withName: "careerMin")
                multipartFormData.append("\(request.careerMax)".data(using: .utf8)!, withName: "careerMax")
                multipartFormData.append("\(request.leaderParts)".data(using: .utf8)!, withName: "leaderParts")
                
                for category in request.category {
                    multipartFormData.append("\(category)".data(using: .utf8)!, withName: "category")
                }
                
                multipartFormData.append("\(request.goal)".data(using: .utf8)!, withName: "goal")
                
                multipartFormData.append("\(request.introduction)".data(using: .utf8)!, withName: "introduction")
                
                // 각 ProjectRecruitDTO 객체를 별도의 객체로 변환
                for (_, recruit) in request.recruits.enumerated() {
                    let recruitDict = [
                        "part": recruit.part,
                        "comment": recruit.comment,
                        "max": "\(recruit.max)"
                    ]
                    
                    // 각 recruit를 JSON 문자열로 인코딩
                    if let recruitData = try? JSONSerialization.data(withJSONObject: recruitDict, options: []) {
                        multipartFormData.append(recruitData, withName: "recruits")
                    }
                }
            
            
                let skills = try! JSONSerialization.data(withJSONObject: request.skills, options: .prettyPrinted)
                
                multipartFormData.append(skills, withName: "skills")
                
            }, to: url, method: .post, headers: header)
            .responseDecodable(of: ProjectCreateResponseDTO.self) { response in
                
                debugPrint(response)
                
                switch response.result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    if let errorData = response.data {
                        do {
                            let networkError = try JSONDecoder().decode(ErrorEntity.self, from: errorData)
                            
                            let apiError = APIError(error: networkError)
                            
                            single(.failure(apiError))
                        } catch {
                            single(.failure(APIError.unknown))
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
}
extension NetworkConstant {
    static let projectBasedURLString: String = "http://teamone.kro.kr:9080"
}

enum ProjectsTarget {
    case baseInformation
    case list(request: ProjectListRequestDTO)
    case like(request: ProjectFavoriteRequestDTO)
    case project(projectId: Int)
    case apply(request: ProjectApplyRequestDTO)
    case createProject(request: ProjectCreateRequestDTO)
}

extension ProjectsTarget: TargetType {
    
    var baseURL: String {
        return NetworkConstant.projectBasedURLString
    }
    
    var method: HTTPMethod {
        switch self {
        case .list, .project, .baseInformation:
            return .get
        case .like, .apply, .createProject:
            return .post
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .list, .like, .project, .apply, .baseInformation:
            return ["Authorization": "Bearer \(UserDefaultKeyList.Auth.appAccessToken ?? "")"]
        case .createProject:
            return ["Contents-Type": "multipart/form-data"]
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .baseInformation:
            return .none
        case let .list(request: request):
            return .query(request)
        case let .like(request: request):
            return .body(request)
        case .project:
            return .none
        case let .apply(request: request):
            return .body(request)
        case let .createProject(request: request):
            return .body(request)
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .list, .project, .baseInformation:
            return  URLEncoding.default
        case .like, .apply:
            return JSONEncoding.default
        case .createProject:
            return JSONEncoding.default
        }
    }
    
    var path: String {
        switch self {
        case .baseInformation: return "/project/"
        case .list: return "/project/list"
        case .like: return "/project/favorite"
        case .project(projectId: let id): return "/project/\(id)"
        case .apply: return "/project/apply"
        case .createProject: return "/project/"
        }
    }
}
