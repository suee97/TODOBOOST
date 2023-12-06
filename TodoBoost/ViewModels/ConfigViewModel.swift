import Foundation

final class ConfigViewModel {
    let sections: [Section] = [
        Section(title: "테마 설정", seciontList: [
            .themeColor, .importantFont, .importantColor
        ]),
        Section(title: "카테고리 설정", seciontList: [
            .appendCategory
        ]),
        Section(title: "기타", seciontList: [
            .initialize
        ])
    ]
}

struct Section {
    let title: String
    var seciontList: [ConfigRoute]
}
