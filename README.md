# Mobbie
![mobbietemp 001](https://github.com/andwecrawl/SeSAC/assets/120160532/27660066-bdfd-4239-90d7-b63ef062f122)

<br>

## 앱 소개
서버 통신을 이용한 텍스트 기반 Feed UI의 익명 SNS 앱으로, 자신의 닉네임을 랜덤으로 바꿀 수 있습니다.
<br>
<br>
## 기능 소개
- 회원가입 인증 로직과 로그인, 로그아웃, 회원 탈퇴 기능이 있습니다.
- 여러 개의 글과 사진을 피드 형식으로 한눈에 보여줍니다.
- 4개까지의 사진을 포함한 텍스트를 등록하고 삭제할 수 있습니다.
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
- **Network**를 활용하여 네트워크 연결 상태를 확인 후 사용자의 입력값에 따라 설정창으로 이동하거나 앱을 종료해 주었습니다.
- **Lottie**를 이용하여 회원가입 성공 시 **애니메이션을 구현**했습니다.
- final과 private과 같은 **접근제어자**를 활용하여 **은닉화 및 컴파일 최적화**했습니다.
<br>
<br>

## TroubleShooting
### 1. Moya를 이용하여 통신한 데이터를 RxSwift를 이용하여 넘기기
- 문제 상황
  - viewModel에서 대부분 RxSwift를 이용하여 로직을 구성하고 있어 RxSwift와 Moya를 결합한 형태로 넘겨야 원활한 처리가 가능할 것 같았다.
- 해결 방법
  - 기존의 작성했던 코드를 rx로 랩핑하는 형태로 해결했다. `Observable.create`를 통해 Observable을 만들고 return한 뒤에 viewModel에서 Observable을 받아 flatMap을 통해 랩핑을 벗겨 사용하는 방식으로 코드를 구성하였다.

```swift
    func fetchInSignProgress<T: Decodable>(_ api: MoyaNetwork, type: T.Type) -> Observable<Result<T, Error>> {
        
        return Observable.create { observer in
            self.provider.request(api) { response in
                
                switch response {
                case .success(let response):
                    let statusCode = response.statusCode
                    
                    if response.statusCode == 200 {
                        
                        guard let result = self.handleDecodingError(type: T.self, data: response.data) else { return }
                        observer.onNext(.success(result))
                        
                    } else {
                        let error = LSLPError(rawValue: statusCode) ?? .undefinedError
                        
                        observer.onNext(.failure(error))
                    }
                    
                case .failure(let error):
                    
                    let statusCode = error.response?.statusCode
                    let error = LSLPError(rawValue: statusCode ?? 500) ?? .undefinedError
                    observer.onError(error)
                    
                }
            }
            return Disposables.create()
        }
    }
```
<br>

### 2. 게시글 전체를 사진 형태로 공유하기
- 문제 상황
  - UIActivityViewController의 ActivityItems 변경을 통해 공유 기능을 구현했으나, 글의 사진과 제목이 기본값으로 나오는 문제가 있었다.
- 해결 방법
  - UIActivityItemSource를 상속받는 ShareActivityItemSource 클래스를 만들어 게시글 전체의 MetaData를 공유해 주었다. 사용자가 올린 사진이 없을 때는 `UIGraphicsImageRenderer`를 통해 게시글 자체를 공유해 주었고, 사용자가 올린 사진이 있을 경우 맨 처음 사진을 공유하도록 했다.
 
```swift
import LinkPresentation
import UIKit

final class SharePinNumberActivityItemSource: NSObject, UIActivityItemSource {
    private var title: String
    private var content: String
    private var image: UIImage
    
    init(title: String, content: String, image: UIImage) {
        self.title = title
        self.content = content
        self.image = image
        
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return content
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        return content
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        return title
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metaData = LPLinkMetadata()
        metaData.title = title
        metaData.iconProvider = NSItemProvider(object: image)
        metaData.originalURL = URL(fileURLWithPath: content)
        return metaData
    }
}
```
```swift
    func share(activeVC: UIActivityViewController) {
        activeVC.popoverPresentationController?.sourceView = self.view
        self.present(activeVC, animated: true)
    }
```
```swift
    @objc func shareButtonTapped() {
        guard let post else { return }
        var thumb = UIImage()
        if let imageURL = post.image.first {
            KingfisherHelper.shared.fetchImage(imageURL: imageURL) { image, size in
                thumb = image
            } errorHandler: { error in
                print(error)
                self.delegate?.alert(title: error.localizedDescription)
                return
            }
        } else {
            contentView.backgroundColor = .background
            thumb = contentView.asImage()
        }
        let title = "\(post.nickname ?? "")님의 게시글 공유하기"
        let content = post.content ?? ""
        
        let items = [SharePinNumberActivityItemSource(title: title, content: content, image: thumb)]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        delegate?.share(activeVC: activityVC)
    }
```

<br>

### 3. 사용자의 event에 따른 반응형 UI 구현
- 문제 상황
  - 사용자가 입력한 값을 설정한 아이디/비밀번호 조건에 일치하는지 일차적으로 유효성 검증한 후에, 사용자가 버튼을 탭했을 때 서버 통신을 통해 가입 가능한 아이디인지 확인하는 로직을 구현해 주어야 했다. 그러기 위해서는 순서가 중요했는데, 정규표현식을 통해 사용자가 입력한 값을 먼저 검증한 후에 사용자가 버튼을 탭하고 서버 통신을 통해 확인해야 했다.
- 해결 방법
  - 자체적으로 정규표현식을 통해 사용자의 입력값에 대한 유효성 검증을 할 수 있었다. 이후, 검증한 결과(bool값)와 해당 text를 `withLatestFrom`과 `combineLatest`, `filter` 오퍼레이터를 활용하여 stream을 관리할 수 있었다.
```swift
        text
            .map { str in
                isFilled.onNext(str.isEmpty ? false : true)
                switch joinType {
                case .email:
                    self.newInfo.id = str
                    subjectInfo.onNext(self.newInfo)
                    return (str.range(of: RegexType.email.rawValue, options: .regularExpression) != nil)
                case .password:
                    self.newInfo.password = str
                    subjectInfo.onNext(self.newInfo)
                    return (str.range(of: RegexType.password.rawValue, options: .regularExpression) != nil)
                case .phoneNumber:
                    self.newInfo.phoneNumber = str
                    subjectInfo.onNext(self.newInfo)
                    return (str.range(of: RegexType.phoneNumber.rawValue, options: .regularExpression) != nil)
                default:
                    return false
                }
            }
            .bind(to: isValidText)
            .disposed(by: disposeBag)
```


```swift
            input.validationButtonTap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .withLatestFrom(text)
                .flatMap { str in
                    let model = ValidationData(email: str)
                    return MoyaAPIManager.shared.fetchInSignProgress(.emailValidation(model: model), type: ValidationResponse.self)
                }
                .subscribe(with: self) { owner, response in
                    switch response {
                    case .success(let result):
                        isValidToNext.onNext(true)
                    case .failure(let error):
                        isValidToNext.onNext(false)
                        input.userInput.onNext("")
                        self.completionHandler?(error.localizedDescription)
                    }
                }
                .disposed(by: disposeBag)
```
```swift
        Observable.combineLatest(output.isValidToNext, output.text)
            .bind(with: self) { owner, tuple in
                    owner.nextButton.backgroundColor = tuple.0 ? .highlightOrange : .gray
                
                if !tuple.1.isEmpty {
                    owner.lineView.backgroundColor = tuple.0 ? .highlightOrange : .systemRed
                }
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withLatestFrom(output.isValid, resultSelector: { _, isValid in
                if isValid {
                    return true
                } else {
                    return false
                }
            })
            .filter({ $0 == true })
            .withLatestFrom(output.userInfo, resultSelector: { _, value in
                return value
            })
            .bind(with: self, onNext: { owner, userInfo in
                    let vc = JoinViewController()
                    vc.joinType = .password
                    vc.userInfo = userInfo
                    self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
```
<br>
