# Mobbie
<br>

## 앱 소개
서버 통신을 이용한 Feed UI의 익명 SNS 앱입니다.
<br>
<br>
## 기능 소개
- 회원가입 인증 로직과 로그인 기능이 있습니다.
- 여러 개의 글과 사진을 피드 형식으로 한눈에 보여줍니다.
- 4개까지의 사진을 포함한 텍스트를 등록할 수 있습니다.
- 글에 댓글과 좋아요를 남길 수 있습니다.
<br>
<br>

## 사용한 기술
- `UIKit`, `Storyboard`, `SnapKit`, `SideMenu`
- `Moya`, `Kingfisher`, `Lottie`, `Toast`
- `MVVM`, `Singleton`, `Router`, `Input/Output` 
<br>
<br>

## 기능 소개
- **RxSwift와 서버 통신**을 통한 **JWT 인증 로직을 구현**했습니다.
- **정규표현식**을 사용하여 사용자의 입력값에 대해 **유효성 검증**했습니다.
- Alamofire의 **Interceptor**를 활용하여 RefreshToken을 통해 **AccessToken 갱신**했습니다.
- **Generic**과 **Router Pattern**을 활용하여 **코드 재사용성**을 높였습니다.
- **Lottie**를 이용하여 회원가입 성공 시 **애니메이션을 구현**했습니다.
- final과 private과 같은 **접근제어자**를 활용하여 **은닉화 및 컴파일 최적화**했습니다.
<br>
<br>

## TroubleShooting
### 1. 수정 중...
- 문제 상황
  - 더원 디자이얼
- 해결 방법
  - 웅냠냐

```swift
    func callRequestCodable(page: Int = 1, segment: Trends, completionHandler: @escaping (TMDB, [[String]]) -> ()) {
        
        if TMDBManager.movieGenre.isEmpty && TMDBManager.tvGenre.isEmpty {
            
            self.callMovieRequest(url: URL.getGenreURL(media: .movie)) {
                self.callTvRequest(url: URL.getGenreURL(media: .tv)) {
                    self.callRequest(page: page, segment: segment) { data, genre in
                        completionHandler(data, genre)
                    }
                }
            }
            
        } else {
            
            self.callRequest(page: page, segment: segment) { data, genre in
                completionHandler(data, genre)
            }
        }
    }
```
<br>

### 2. 수정 중...
- 문제 상황
  - 
- 해결 방법
  - 
