//
//  Error.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/17.
//

import Foundation

enum LSLPError: Int, Error {
    case worngRequest = 400 // 잘못된 요청 (요청 확인...)
    case unauthenticatedToken = 401 // 미가입 혹은 비번 틀림 / 인증되지 않은 token
    case forbidden = 403 // 접근 권한 X
    case unusableAccount = 409 // 이미 가입된 유저
    case notFound = 410
    case expiredRefreshToken = 418 // 리프레시 토큰 만료 -> 재로그인 필요
    case expiredToken = 419 // 액세스 토큰 만료
    case wrongKey = 420 // SeSACKey의 키값이 없거나 틀릴 경우
    case overfetching = 429 // 과호출
    case wrongURL = 444 // 비정상 URL을 통한 요청
    case unauthenticated = 445 // 본인의 것이 아닌 게시글 / 댓글 삭제 시 권한 X
    case undefinedError = 500 // 비정상 요청 및 정의되지 않는 error
    
    var descriptions: String {
        switch self {
        case .worngRequest:
            return "필수값을 채워주세요."
        case .unauthenticatedToken:
            return "비밀번호가 틀렸거나 가입되지 않은 회원입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unusableAccount:
            return "이미 가입된 유저입니다."
        case .notFound:
            return "게시글을 찾을 수 없습니다."
        case .expiredRefreshToken:
            return "재로그인이 필요합니다."
        case .expiredToken:
            return "액세스 토큰이 만료되었습니다."
        case .wrongKey:
            return "API 키값이 잘못되었습니다."
        case .overfetching:
            return "과호출입니다 ㅠㅠ"
        case .wrongURL:
            return "돌아가 여긴 자네가 올 곳이 아니야"
        case .unauthenticated:
            return "권한이 없습니다."
        case .undefinedError:
            return "사전에 정의되지 않은 네트워크 오류입니다."
        }
    }
}
