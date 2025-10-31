import SwiftUI
import Combine


// MARK: - ViewModel giống style bạn tham chiếu
final class NewsHeaderViewModel: ObservableObject {
    let offset: CurrentValueSubject<CGFloat, Never> = .init(.zero)  // độ cuộn dọc
    @Published var progress: CGFloat = 0                            // 0..1 (ẩn dần)
}
//
//struct NewsContentView: View {
//    @StateObject private var vm = NewsHeaderViewModel()
//    
//    @State private var searchText: String = ""
//
//    let onClick: () -> Void
//
//    // Tinh chỉnh
//    private let headerHeight: CGFloat = 220
//    private let hideThreshold: CGFloat = 50   // cuộn bao nhiêu thì ẩn hẳn
//    
//    private var filtered: [LicenseCategory] {
//          let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
//          guard !q.isEmpty else { return LicenseCategory.allCases }
//          return LicenseCategory.allCases.filter {
//              $0.rawValue.localizedCaseInsensitiveContains(q)
//          }
//      }
//
//    var body: some View {
//        ZStack(alignment: .top) {
//            ScrollView {
//                VStack(spacing: 20) {
//                    // Header có GeometryReader đo offset .global (giống code bạn đưa)
//                    scrollHeaderView
//                        .onTapGesture {
//                            onClick()
//                        }
//                    MiniNavBar(text: $searchText, visible: vm.progress < 0.92)
//                        .padding(.horizontal, 12)
//                        .padding(.top, 12)
//                    Group {
//                        if searchText.isEmpty {
//                            ExamCategoryGridView { print($0) }
//                        }
//                        sectionSchedule
//                    }
//                    .padding(.horizontal, 16)
//                    Spacer(minLength: 40)
//                }
//            }
//            .background(Color(.systemGroupedBackground))
//            .onReceive(vm.offset) { off in
//                // off >= 0 khi cuộn xuống
//                let p = min(max(off / hideThreshold, 0), 1)
//                withAnimation(.interactiveSpring(response: 0.28, dampingFraction: 0.86)) {
//                    vm.progress = p
//                }
//            }
//
//            MiniNavBar(text: $searchText, visible: vm.progress > 0.92)
//                .padding(.top, safeTopInset() + 6)
//                .padding(.horizontal, 12)
//                .allowsHitTesting(vm.progress > 0.92)
//        }
//        .background(Color(.systemGroupedBackground))
//        .ignoresSafeArea(edges: .top)
//        .onTapGesture {
//            UIApplication.shared.windows.first{$0.isKeyWindow }?.endEditing(true)
//        }
//    }
//
//    // MARK: - Header có hiệu ứng co/ẩn
//    private var scrollHeaderView: some View {
//        GeometryReader { reader -> AnyView in
//            // y là vị trí của khung header trong .global
//            let y = reader.frame(in: .global).minY
//
//            // offset dương khi cuộn xuống (header rời xa đỉnh màn hình)
//            let offsetDown = max(0, -y)          // cuộn xuống (vị trí đi âm nên lấy -y)
//            DispatchQueue.main.async {
//                vm.offset.send(offsetDown)
//            }
//
//            // overscroll khi kéo xuống vượt đỉnh (y > 0)
//            let overscroll = max(0, y)
//
//            // Map progress 0..1 để transform
//            let p = vm.progress
//
//            // Chiều cao header tăng khi overscroll (stretch)
//            let height = headerHeight + overscroll
//
//            // Transform: scale theo trục dọc từ đỉnh, mờ dần, trượt lên
//            let scale = 1.0 - 0.18 * p
//            let opacity = 1.0 - p
//            let translateY = -(headerHeight * 0.62) * p - overscroll / 3
//
//            return AnyView(
//                NewsHeaderView()
//                    .frame(height: height)
//                    .scaleEffect(x: 1.0, y: scale, anchor: .top)
//                    .opacity(opacity)
//                    .offset(y: translateY)
//                    .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.86), value: p)
//                    .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.86), value: overscroll)
//            )
//        }
//        .frame(height: headerHeight) // chiều cao nền tảng ban đầu
//    }


// MARK: - MAIN VIEW
struct NewsContentView: View {
    @StateObject private var vm = NewsHeaderViewModel()
    @State private var searchText: String = ""
    let onClick: () -> Void
    
    private let headerHeight: CGFloat = 200
    private let hideThreshold: CGFloat = 110

    // Filter theo LicenseCategory.rawValue
    private var filtered: [LicenseCategory] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return LicenseCategory.allCases }
        return LicenseCategory.allCases.filter {
            $0.rawValue.localizedCaseInsensitiveContains(q)
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                // Quan trọng: bật pinned section headers
              VStack(spacing: 20) {

                    // Header lớn (không pin)
                    scrollHeaderView
                        .onTapGesture {
                            onClick()
                        }
                  
                  MiniNavBar(text: $searchText, visible: vm.progress < 0.92)
                      .padding(.horizontal, 12)
                      .padding(.top, 12)

                    // Toàn bộ phần còn lại đặt trong 1 Section
                        // Nội dung ngay dưới MiniNavBar
                        Group {
                            if searchText.isEmpty {
                                ExamCategoryGridView { print($0) }
                            }
                            sectionSchedule
                        }
                        .padding(.horizontal, 16)

                        Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .onReceive(vm.offset) { off in
                // off >= 0 khi cuộn xuống
                let p = min(max(off / hideThreshold, 0), 1)
                withAnimation(.interactiveSpring(response: 0.28, dampingFraction: 0.86)) {
                    vm.progress = p
                }
            }
            MiniNavBar(text: $searchText, visible: vm.progress > 0.92)
                .padding(.top, safeTopInset() + 6)
                .padding(.horizontal, 12)
                .allowsHitTesting(vm.progress > 0.92)
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
        .onTapGesture {
            UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .first?.endEditing(true)
        }
    }
    
    
    private var scrollHeaderView: some View {
        GeometryReader { reader -> AnyView in
            // y là vị trí của khung header trong .global
            let y = reader.frame(in: .global).minY

            // offset dương khi cuộn xuống (header rời xa đỉnh màn hình)
            let offsetDown = max(0, -y)          // cuộn xuống (vị trí đi âm nên lấy -y)
            DispatchQueue.main.async {
                vm.offset.send(offsetDown)
            }

            // overscroll khi kéo xuống vượt đỉnh (y > 0)
            let overscroll = max(0, y)

            // Map progress 0..1 để transform
            let p = vm.progress

            // Chiều cao header tăng khi overscroll (stretch)
            let height = headerHeight + overscroll

            // Transform: scale theo trục dọc từ đỉnh, mờ dần, trượt lên
            let scale = 1.0 - 0.18 * p
            let opacity = 1.0 - p
            let translateY = -(headerHeight * 0.62) * p - overscroll / 3

            return AnyView(
                NewsHeaderView()
                    .frame(height: height)
                    .scaleEffect(x: 1.0, y: scale, anchor: .top)
                    .opacity(opacity)
                    .offset(y: translateY)
                    .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.86), value: p)
                    .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.86), value: overscroll)
            )
        }
        .frame(height: headerHeight) // chiều cao nền tảng ban đầu
    }

    private var sectionSchedule: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Đề thi ôn tập")
                .font(.system(size: 24, weight: .bold))
            Text("Danh sách đề thi các hạng giấy phép lái xe")
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(spacing: 14) {
                ForEach(filtered, id: \.self) { title in
                    Button {
                        print(title.rawValue)
                    } label: {
                        ScheduleRow(title: title.rawValue, subtitle: title.description)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }

                if filtered.isEmpty {
                    HStack {
                        Text("Không tìm thấy kết quả")
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                        Spacer()
                    }
                }
            }
        }
    }

    // Safe area
    private func safeTopInset() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.safeAreaInsets.top ?? 0
    }
}

// MARK: - Header View (giữ nguyên)
struct NewsHeaderView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(colors: [Color.green, Color.teal],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .overlay(
                    Circle().fill(Color.white.opacity(0.12))
                        .frame(width: 180, height: 180)
                        .offset(x: -40, y: 30)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.white.opacity(0.15), lineWidth: 2)
                        .frame(width: 240, height: 120)
                        .rotationEffect(.degrees(-8))
                        .offset(x: 120, y: 40)
                )

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Ôn thi GPLX")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                Group {
                    Text("Ôn thi giấy phép lái xe ")
                        .font(.system(size: 15, weight: .medium))
                    +
                    Text("ONLINE miễn phí")
                        .font(.system(size: 18, weight: .bold))
                    +
                    Text(" với bộ đề ")
                        .font(.system(size: 15, weight: .medium))
                    +
                    Text("600")
                        .font(.system(size: 18, weight: .bold))
                    +
                    Text(" câu theo luật giao thông mới 2025")
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                
                Group {
                    Text("15 hạng bằng lái")
                        .font(.system(size: 15, weight: .medium))
                    +
                    Text(" A, A1, B1, B, C1, C, D1, D2, D, BE, C1E, CE, D1E, D2E, DE")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16 + safeTopInset())
        }
        .ignoresSafeArea(edges: .top)
    }

    private func safeTopInset() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.safeAreaInsets.top ?? 0
    }
}

// MARK: - Mini Nav (vẫn giữ visible nếu bạn muốn điều kiện khác sau này)
struct MiniNavBar: View {
    @Binding var text: String
    var visible: Bool
    @FocusState private var isSearchFocused: Bool
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(.label))
                TextField("Tìm kiếm hạng bằng", text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .focused($isSearchFocused)
                Spacer()
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
            }
            .padding(10)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
            if isSearchFocused {
                Button {
                    UIApplication.shared.connectedScenes
                        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                        .first?.endEditing(true)
                } label: {
                    Text("Xong")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(.label))
                }
            }
        }
        .opacity(visible ? 1 : 0)
        .animation(.easeInOut(duration: 0.18), value: visible)
    }
}

// MARK: - Demo cells
struct SubjectCard: View {
    let title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.headline).foregroundColor(.black)
        }
        .padding(16)
        .frame(width: 180, height: 110)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct ScheduleRow: View {
    let title: String; let subtitle: String
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(colors: [Color.green, Color.teal],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 52, height: 52)
                .overlay(Text(title).font(.headline).foregroundColor(.white))
            VStack(alignment: .leading, spacing: 6) {
                Text(subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(14)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}



struct ExamCategoryGridView: View {
    let items: [ExamCategory] = ExamCategory.allCases
    var onSelect: (ExamCategory) -> Void = { _ in }
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Ôn tập theo chủ đề").font(.system(size: 24, weight: .bold))
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(items) { item in
                    Button {
                        onSelect(item)
                    } label: {
                        CategoryCard(item: item)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(Text(item.rawValue))
                            .accessibilityAddTraits(.isButton)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
}

private struct CategoryCard: View {
    let item: ExamCategory
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(item.tint.opacity(0.15))
                    .frame(width: 30, height: 30)
                Image(systemName: item.icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(item.tint)
            }
            Text(item.rawValue)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}
