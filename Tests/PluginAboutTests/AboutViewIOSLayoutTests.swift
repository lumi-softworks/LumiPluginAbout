import Foundation
import Testing

/// 「关于」页 iOS 布局守卫。
///
/// iOS 不再复用桌面 scaffold，而是使用系统 `Form` 分组列表：
/// 两个分组（关于我们 / 我们的产品）、外链行与原生分组底色。
@Suite("关于页 iOS 布局")
struct AboutViewIOSLayoutTests {
    private static var packageRoot: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()   // PluginAboutTests
            .deletingLastPathComponent()   // Tests
            .deletingLastPathComponent()   // <pkg>
    }

    private static func aboutView() throws -> String {
        let url = Self.packageRoot
            .appendingPathComponent("Sources/PluginAbout/Views/AboutView.swift")
        return try String(contentsOf: url, encoding: .utf8)
    }

    @Test("iOS 与 macOS 布局分离")
    func routesByPlatform() throws {
        let view = try Self.aboutView()
        #expect(view.contains("#if os(iOS)"))
        #expect(view.contains("private var iosContent"))
        #expect(view.contains("private var desktopContent"))
    }

    @Test("iOS 使用系统 Form 分组列表")
    func usesNativeForm() throws {
        let view = try Self.aboutView()
        #expect(view.contains("Form {"))
        #expect(view.contains("} header: {"))
        #expect(
            view.components(separatedBy: "AppSettingsContentScaffold(maxContentWidth").count == 2,
            Comment(rawValue: "桌面 scaffold 只应保留在 macOS 分支中")
        )
    }

    @Test("iOS 使用原生外链行")
    func usesNativeLinkRows() throws {
        let view = try Self.aboutView()
        #expect(view.contains("Link(destination:"))
        #expect(view.contains(".buttonStyle(.plain)"))
        #expect(view.contains("arrow.up.right"))
    }
}