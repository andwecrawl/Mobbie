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
}
