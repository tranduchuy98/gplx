import SwiftUI
import Combine

// MARK: - ViewModel giống style bạn tham chiếu
final class NewsHeaderViewModel: ObservableObject {
    let offset: CurrentValueSubject<CGFloat, Never> = .init(.zero)  // độ cuộn dọc
    @Published var progress: CGFloat = 0                            // 0..1 (ẩn dần)
}

struct NewsContentView: View {
    @StateObject private var vm = NewsHeaderViewModel()

    // Tinh chỉnh
    private let headerHeight: CGFloat = 220
    private let hideThreshold: CGFloat = 50   // cuộn bao nhiêu thì ẩn hẳn

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: 20, pinnedViews: []) {
                    // Header có GeometryReader đo offset .global (giống code bạn đưa)
                    scrollHeaderView

                    // ----- Demo content -----
                    Group {
                        sectionSubjects
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

            // Mini bar xuất hiện khi header gần ẩn hết
            MiniNavBar(visible: vm.progress > 0.92)
                .padding(.top, safeTopInset() + 6)
                .padding(.horizontal, 12)
                .allowsHitTesting(vm.progress > 0.92)
        }
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Header có hiệu ứng co/ẩn
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

    // MARK: - Sections demo
    private var sectionSubjects: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Subjects").font(.system(size: 24, weight: .bold))
            Text("Recommendations for you").font(.subheadline).foregroundColor(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    SubjectCard(title: "Mathematics", icon: "function", colors: [.orange, .pink])
                    SubjectCard(title: "Geography", icon: "globe.asia.australia.fill", colors: [.blue, .purple])
                    SubjectCard(title: "Physics", icon: "atom", colors: [.indigo, .cyan])
                }
                .padding(.vertical, 4)
            }
        }
    }

    private var sectionSchedule: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your Schedule").font(.system(size: 24, weight: .bold))
            VStack(spacing: 14) {
                ScheduleRow(title: "Biology", subtitle: "Chapter 5 · Animal Kingdom", color: .green)
                ScheduleRow(title: "Chemistry", subtitle: "Organic basics", color: .teal)
                ScheduleRow(title: "History", subtitle: "Renaissance overview", color: .brown)
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
                    Text(" phí với bộ đề ")
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

// MARK: - Mini Nav
struct MiniNavBar: View {
    var visible: Bool
    var body: some View {
        HStack {
            Text("Discover").font(.headline).foregroundColor(.primary)
            Spacer()
            Image(systemName: "magnifyingglass").foregroundColor(.primary)
        }
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .opacity(visible ? 1 : 0)
        .animation(.easeInOut(duration: 0.18), value: visible)
    }
}

// MARK: - Demo cells
struct SubjectCard: View {
    let title: String; let icon: String; let colors: [Color]
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .padding(8)
                .background(.white.opacity(0.25), in: RoundedRectangle(cornerRadius: 10))
            Text(title).font(.headline).foregroundColor(.white)
        }
        .padding(16)
        .frame(width: 180, height: 110)
        .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

struct ScheduleRow: View {
    let title: String; let subtitle: String; let color: Color
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.9))
                .frame(width: 52, height: 52)
                .overlay(Image(systemName: "book.fill").foregroundColor(.white))
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "ellipsis").rotationEffect(.degrees(90)).foregroundColor(.secondary)
        }
        .padding(14)
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}
