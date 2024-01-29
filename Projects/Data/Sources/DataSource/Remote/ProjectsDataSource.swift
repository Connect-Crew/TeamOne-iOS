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
import SDWebImage

public protocol ProjectsDataSouceProtocol {
    
    func baseInformation() -> Observable<BaseProjectInformationResponseDTO>
    
    func list(_ request: ProjectListRequestDTO) -> Observable<[ProjectListResponseDTO]>
    
    func like(_ request: ProjectFavoriteRequestDTO) -> Observable<ProjectFavoriteResponseDTO>
    
    func project(_ projectId: Int) -> Single<ProjectResponseDTO>
    
    func apply(_ request: ProjectApplyRequestDTO) -> Single<ProjectApplyResponseDTO>
    
    func create(_ request: ProjectCreateRequestDTO) -> Single<ProjectCreateResponseDTO>
    
    func report(request: ProjectReportRequestDTO) -> Single<BaseValueResponseDTO>
    
    func members(projectId: Int) -> Single<[ProjectMemberResponseDTO]>
    
    func modify(_ request: ProjectModifyRequestDTO, projectId: Int) -> Single<ProjectCreateResponseDTO>
    
    func listAllApplicationsForProject(projectId: Int) -> Single<[GetApplyStatusResponseDTO]>
    
    func getApplies(request: GetAppliesRequestDTO) -> Single<[GetAppliesResponseDTO]>
    
    func updateState(projectId: Int, state: String) -> Single<Void>
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
    
    public func project(_ projectId: Int) -> Single<ProjectResponseDTO> {
        return provider.request(ProjectsTarget.project(projectId: projectId))
    }
    
    public func apply(_ request: ProjectApplyRequestDTO) -> Single<ProjectApplyResponseDTO> {
        return provider.request(ProjectsTarget.apply(request: request))
    }
    
    public func create(_ request: ProjectCreateRequestDTO) -> Single<ProjectCreateResponseDTO> {
        
        print("!!!!!!!!!!!\(self)::::")
        print(request)
        print("!!!!!!!!!!!!")
        
        let header: HTTPHeaders =  [
            "Content-Type" : "multipart/form-data",
            "Authorization" : "Bearer \(UserDefaultKeyList.Auth.appAccessToken!)"
        ]
        
        let url = "\(NetworkConstant.projectBasedURLString)/project/"
        
        return Single.create { single in
            
            Loading.start(stopTouch: true)
            
            // Alamofire의 upload 함수 사용
            AF.upload(multipartFormData: { formData in
                
                for banner in request.banner {
                    if let imageData = banner.image.jpegData(compressionQuality: 1) {
                        formData.append(imageData, withName: "banner", fileName: "\(banner).jpg", mimeType: "image/jpeg")
                    }
                    else if let imageData = banner.image.pngData() {
                        formData.append(imageData, withName: "banner", fileName: "\(banner.name).png", mimeType: "image/png")
                    } else {
                        
                    }
                }
                
                // 텍스트 필드 추가
                formData.append(request.title.data(using: .utf8)!, withName: "title")
                formData.append(request.region.data(using: .utf8)!, withName: "region")
                formData.append("\(request.online)".data(using: .utf8)!, withName: "online")
                formData.append("\(request.state)".data(using: .utf8)!, withName: "state")
                formData.append("\(request.careerMin)".data(using: .utf8)!, withName: "careerMin")
                formData.append("\(request.careerMax)".data(using: .utf8)!, withName: "careerMax")
                formData.append("\(request.leaderParts)".data(using: .utf8)!, withName: "leaderParts")
                
                for category in request.category {
                    formData.append("\(category)".data(using: .utf8)!, withName: "category")
                }
                
                formData.append("\(request.goal)".data(using: .utf8)!, withName: "goal")
                
                formData.append("\(request.introduction)".data(using: .utf8)!, withName: "introduction")
                
                // 각 ProjectRecruitDTO 객체를 별도의 객체로 변환
                for (_, recruit) in request.recruits.enumerated() {
                    let recruitDict = [
                        "part": recruit.part,
                        "comment": recruit.comment,
                        "max": "\(recruit.max)"
                    ]
                    
                    // 각 recruit를 JSON 문자열로 인코딩
                    if let recruitData = try? JSONSerialization.data(withJSONObject: recruitDict, options: []) {
                        formData.append(recruitData, withName: "recruits")
                    }
                }
            
            
                for skill in request.skills {
                    formData.append("\(skill)".data(using: .utf8)!, withName: "skills")
                }
                
            }, to: url, method: .post, headers: header)
            .responseDecodable(of: ProjectCreateResponseDTO.self) { response in
                
                debugPrint(response)
                
                switch response.result {
                case .success(let value):
                    single(.success(value))
                case .failure(_):
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
                
                Loading.stop()
            }
            return Disposables.create()
        }
    }
    
    public func report(request: ProjectReportRequestDTO) -> Single<BaseValueResponseDTO> {
        return provider.request(ProjectsTarget.report(request: request))
    }
    
    public func members(projectId: Int) -> Single<[ProjectMemberResponseDTO]> {
        return provider.request(ProjectsTarget.members(projectId: projectId))
    }
    
    public func modify(_ request: ProjectModifyRequestDTO,
                       projectId: Int
    ) -> Single<ProjectCreateResponseDTO> {
        
        print("!!!!!!!!!!!\(self)::::")
        print(request)
        print("!!!!!!!!!!!!")
        
        Loading.start(stopTouch: true)
        
        let header: HTTPHeaders =  [
            "Content-Type" : "multipart/form-data",
            "Authorization" : "Bearer \(UserDefaultKeyList.Auth.appAccessToken!)"
        ]
        
        let url = "\(NetworkConstant.projectBasedURLString)/project/\(projectId)"
        
        return Single.create { single in
            
            // Alamofire의 upload 함수 사용
            AF.upload(multipartFormData: { formData in
                
                // 이미지 추가
                for banner in request.banner {
                    if let imageData = banner.image.jpegData(compressionQuality: 1) {
                        formData.append(imageData, withName: "banner", fileName: "\(banner).jpg", mimeType: "image/jpeg")
                    }
                    else if let imageData = banner.image.pngData() {
                        formData.append(imageData, withName: "banner", fileName: "\(banner.name).png", mimeType: "image/png")
                    } else {
                        
                    }
                }
                
                for removeBanner in request.removeBanners {
                    formData.append("\(removeBanner)".data(using: .utf8)!, withName: "removeBanners")
                }
                
                // 텍스트 필드 추가
                formData.append(request.title.data(using: .utf8)!, withName: "title")
                formData.append(request.region.data(using: .utf8)!, withName: "region")
                formData.append("\(request.online)".data(using: .utf8)!, withName: "online")
                formData.append("\(request.state)".data(using: .utf8)!, withName: "state")
                formData.append("\(request.careerMin)".data(using: .utf8)!, withName: "careerMin")
                formData.append("\(request.careerMax)".data(using: .utf8)!, withName: "careerMax")
                formData.append("\(request.leaderParts)".data(using: .utf8)!, withName: "leaderParts")
                
                for category in request.category {
                    formData.append("\(category)".data(using: .utf8)!, withName: "category")
                }
                
                formData.append("\(request.goal)".data(using: .utf8)!, withName: "goal")
                
                formData.append("\(request.introduction)".data(using: .utf8)!, withName: "introduction")
                
                for (_, recruit) in request.recruits.enumerated() {
                    let recruitDict = [
                        "part": recruit.part,
                        "comment": recruit.comment,
                        "max": "\(recruit.max)"
                    ]
                    
                    if let recruitData = try? JSONSerialization.data(withJSONObject: recruitDict, options: []) {
                        formData.append(recruitData, withName: "recruits")
                    }
                }
                
                
                for skill in request.skills {
                    formData.append("\(skill)".data(using: .utf8)!, withName: "skills")
                }
                
            }, to: url, method: .put, headers: header)
            .responseDecodable(of: ProjectCreateResponseDTO.self) { response in
                
                debugPrint(response)
                
                switch response.result {
                case .success(let value):
                    single(.success(value))
                case .failure(_):
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
                
                Loading.stop()
                
            }
            return Disposables.create()
        }
    }
    
    public func listAllApplicationsForProject(projectId: Int) -> Single<[GetApplyStatusResponseDTO]> {
        
        return provider.request(ProjectsTarget.listAllApplicationsForProject(projectId: projectId))
    }
    
    public func getApplies(request: GetAppliesRequestDTO) -> Single<[GetAppliesResponseDTO]> {
        return provider.request(ProjectsTarget.getApplies(request: request))
    }
    
    public func updateState(projectId: Int, state: String) -> Single<Void> {
        return provider.request(ProjectsTarget.updateState(projectId: projectId, state: state))
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
    case report(request: ProjectReportRequestDTO)
    case members(projectId: Int)
    case listAllApplicationsForProject(projectId: Int)
    case getApplies(request: GetAppliesRequestDTO)
    case updateState(projectId: Int, state: String)
}

extension ProjectsTarget: TargetType {
    
    var baseURL: String {
        return NetworkConstant.projectBasedURLString
    }
    
    var method: HTTPMethod {
        switch self {
        case .list, .project, .baseInformation, .members, .listAllApplicationsForProject, .getApplies:
            return .get
        case .like, .apply, .createProject, .report, .updateState:
            return .post
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .createProject:
            return ["Contents-Type": "multipart/form-data"]
        default: return []
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
        case .createProject:
            return .none
        case let .report(request: request):
            return .body(request)
        case .members, .listAllApplicationsForProject, .updateState:
            return .none
        case .getApplies(let request):
            return .query(request)
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .list, .project, .baseInformation, .members, .getApplies, .updateState:
            return  URLEncoding.default
        case .like, .apply, .report, .listAllApplicationsForProject:
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
        case .report: return "/project/report"
        case .members(projectId: let id): return "/project/members/\(id)"
        case .listAllApplicationsForProject(let id): return "/project/apply/\(id)"
        case .getApplies(let request):
            return "/project/apply/\(request.projectId)/\(request.part)"
        case .updateState(let projectId, let state):
            return "/project/\(projectId)/state/\(state)/update"
        }
    }
}
