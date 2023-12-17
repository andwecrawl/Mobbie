//
//  NicknameData.swift
//  Mobbie
//
//  Created by yeoni on 12/16/23.
//

import Foundation

class Nickname {
    
    static let shared = Nickname()
    
    private init() { }
    
    private let adjectives = ["다정한", "진취적인", "맑은", "고결한", "터프한", "현란한", "밝은", "빈틈없는", "특별한", "도덕적인", "놀라운", "흥미로운", "부드러운", "쾌활한", "정갈한", "섬세한", "힘찬", "순수한", "매력적인", "소란스러운", "아찔한", "명랑한", "창의적인", "착한", "섹시한", "포근한", "소심한", "감각적인", "신비로운", "아름다운", "활기찬", "건강한", "자세한", "예쁜", "극적인", "매끄러운", "천진난만한", "생동감 있는", "건장한", "화려한", "균형잡힌", "경제적인", "용감한", "감동적인", "불굴의", "몽환적인", "단단한", "발랄한", "자연스러운", "미묘한", "귀여운", "화사한", "단호한", "청량한", "우아한", "시원한", "경쾌한", "묵직한", "자유분방한", "고상한", "따뜻한", "진실된", "근면한", "쿨한", "수수한", "열정적인", "매혹적인", "강인한", "편안한", "끈질긴", "청초한", "촉촉한", "도도한", "겸손한", "유쾌한", "기발한", "생생한", "생기발랄한", "신그러운", "깔끔한", "유연한", "흐릿한", "유순한", "신선한", "싱그러운", "힘이 넘치는", "점잖은", "달콤한", "꾸준한", "웅장한", "도전적인", "담백한", "자유로운", "낭만적인", "세련된", "눈부신", "화목한", "신뢰할 수 있는", "안정된", "즐거운", "달달한", "독특한", "강렬한", "황홀한", "미소가 매력적인", "향기로운", "고요한", "아담한", "대담한", "유려한", "밝아지는", "적극적인", "정열적인", "영롱한", "사랑스러운", "우울한", "역동적인", "절제된", "과감한", "진중한", "독립적인", "끈끈한", "신나는", "노르스름한", "노란", "붉은", "불그스름한", "새하얀", "초록빛의", "유혹하는", "푸르스름한", "기겁하는", "친절한"]
    
    private let fruits = ["망고스틴", "감귤", "라임", "코코넛", "복분자", "석류", "키위", "천도복숭아", "토마토", "아보카도", "귤", "복숭아", "망고", "라즈베리", "대추", "딸기", "청포도", "청사과", "배", "수박", "오렌지", "자몽", "포도", "파파야", "체리", "호박", "감", "파인애플", "패션프루트", "사과", "블랙베리", "두리안", "매실", "아사이베리", "바나나", "레몬", "살구", "밤", "산딸기", "자두", "블루베리"]
    
    private let animals = ["오징어", "범블비", "앵무새", "코알라", "원숭이", "기니피그", "말티즈", "오소리", "코끼리", "앵두새", "뱀", "치타", "벌새", "족제비", "해마", "카멜레온", "새우", "백조", "표범", "캥거루", "바다소", "해달", "물범", "돌고래", "햄스터", "허스키", "고릴라", "바다거북", "오리", "코알라쥐", "범고래상어", "고슴도치", "오랑우탄", "수달", "악어", "고양이", "침팬지", "두꺼비", "사자", "푸들", "다람쥐", "바다코끼리", "기린", "북극곰", "범고래", "하이에나", "문어", "호랑이", "상어", "푸마", "밍크고래", "두더지", "사막여우", "펭귄", "토끼", "판다", "부엉이", "불곰", "하마"]
    
    private let things = ["탬버린", "플룻", "북", "징", "베이스",  "피아노", "바이올린", "기타", "드럼", "트럼본", "클라리넷", "하프", "오카리나", "비올라", "첼로", "오보에", "바순", "리코더"]
    
    
    func makeNewNickname() -> String {
        let MainNickname = [fruits, animals, things]
        return adjectives.randomElement()! + " " + MainNickname.randomElement()!.randomElement()!
    }
    
    
    let lastExecutionKey = "lastExecution"
    
    func setNicknameRefresher() {
        var timer: Timer?
        let timerInterval: TimeInterval = 24 * 60 * 60 // 24시간
        let lastExecutionTime = UserDefaults.standard.double(forKey: lastExecutionKey)
        
        let calendar = Calendar.current
        let now = Date()
        
        // 현재 날짜의 정오(12시)로 설정
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 12
        components.minute = 0
        components.second = 0
        
        guard let targetDate = calendar.date(from: components) else {
            return
        }
        
        // 현재와 목표 시간 간의 시간 간격 계산
        let elapsedTime = now.timeIntervalSince(targetDate)
        let initialDelay = elapsedTime >= 0 ? timerInterval : -elapsedTime
        
        // 타이머 설정
        timer = Timer.scheduledTimer(withTimeInterval: initialDelay, repeats: false) { [weak self] _ in
            self?.timerFired()
        }
        
    }
    
    func timerFired() {
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastExecutionKey)
        
        UserDefaultsHelper.shared.nickname = makeNewNickname()
        
        setNicknameRefresher() // 다음 타이머 시작
    }
}
