// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Common {
    /// Huỷ bỏ
    internal static var cancel: String { return L10n.tr("Localizable", "common.cancel") }
    /// Đóng
    internal static var close: String { return L10n.tr("Localizable", "common.close") }
    /// Đã hoàn thành
    internal static var completed: String { return L10n.tr("Localizable", "common.completed") }
    /// Xác nhận
    internal static var confirm: String { return L10n.tr("Localizable", "common.confirm") }
    /// Xong
    internal static var done: String { return L10n.tr("Localizable", "common.done") }
    /// Thoát
    internal static var exit: String { return L10n.tr("Localizable", "common.exit") }
    /// Đã hết hạn
    internal static var expired: String { return L10n.tr("Localizable", "common.expired") }
    /// Thất bại
    internal static var failure: String { return L10n.tr("Localizable", "common.failure") }
    /// Lọc
    internal static var filter: String { return L10n.tr("Localizable", "common.filter") }
    /// Đang tải...
    internal static var loading: String { return L10n.tr("Localizable", "common.loading") }
    /// Đã có lỗi xảy ra. Vui lòng thử lại!
    internal static var messageError: String { return L10n.tr("Localizable", "common.message_error") }
    /// Chưa có dữ liệu
    internal static var noData: String { return L10n.tr("Localizable", "common.no_data") }
    /// Chưa cập nhật
    internal static var notUpdate: String { return L10n.tr("Localizable", "common.not_update") }
    /// Lưu ý
    internal static var note: String { return L10n.tr("Localizable", "common.note") }
    /// Chưa hoàn thành
    internal static var pendent: String { return L10n.tr("Localizable", "common.pendent") }
    /// Tìm kiếm
    internal static var searchPlaceholder: String { return L10n.tr("Localizable", "common.search_placeholder") }
    /// Cấu hình
    internal static var setting: String { return L10n.tr("Localizable", "common.setting") }
    /// Thành công
    internal static var success: String { return L10n.tr("Localizable", "common.success") }
    /// Xin chào%@
    internal static func welcomeFormat(_ p1: Any) -> String {
      return L10n.tr("Localizable", "common.welcome_format", String(describing: p1))
    }
    internal enum Copy {
      /// Sao chép thành công
      internal static var success: String { return L10n.tr("Localizable", "common.copy.success") }
    }
    internal enum Data {
      /// Không có dữ liệu
      internal static var emtry: String { return L10n.tr("Localizable", "common.data.emtry") }
    }
    internal enum Explain {
      internal enum Title {
        /// Ẩn giải thích
        internal static var hide: String { return L10n.tr("Localizable", "common.explain.title.hide") }
        /// Giải thích
        internal static var show: String { return L10n.tr("Localizable", "common.explain.title.show") }
      }
    }
    internal enum Have {
      /// Đã lọc
      internal static var filter: String { return L10n.tr("Localizable", "common.have.filter") }
    }
  }

  internal enum Tabbar {
    /// Tin nhắn
    internal static var message: String { return L10n.tr("Localizable", "tabbar.message") }
    /// Thêm
    internal static var more: String { return L10n.tr("Localizable", "tabbar.more") }
    /// Tin tức
    internal static var news: String { return L10n.tr("Localizable", "tabbar.news") }
    /// Ví bảo mật
    internal static var wallet: String { return L10n.tr("Localizable", "tabbar.wallet") }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
      return TranslationService.shared.format(key:table:args:)(key, table, args)
  }
}

