import SwiftUI
import SwiftData

/// 我的：宝宝档案、数据管理
struct ProfileView: View {
    @Query private var babies: [Baby]
    @Query private var records: [FeedRecord]
    @Environment(\.modelContext) private var context
    @State private var showEdit = false
    @State private var showClearConfirm = false

    private var baby: Baby? { babies.first }

    var body: some View {
        NavigationStack {
            List {
                if let baby {
                    Section("宝宝档案") {
                        HStack(spacing: 12) {
                            Text(baby.avatarEmoji)
                                .font(.system(size: 40))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(baby.name)
                                    .font(.headline)
                                Text("\(baby.ageText) · \(baby.gender ?? "未设置")")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button {
                                showEdit = true
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(Theme.peach)
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Section("档案信息") {
                        infoRow(
                            "出生日期",
                            value: baby.birthday?.formatted(date: .abbreviated, time: .omitted) ?? "未设置"
                        )
                        infoRow(
                            "出生体重",
                            value: baby.birthWeightKg.map {
                                "\($0.formatted(.number.precision(.fractionLength(1)))) kg"
                            } ?? "未设置"
                        )
                        infoRow(
                            "出生身高",
                            value: baby.birthHeightCm.map {
                                "\($0.formatted(.number.precision(.fractionLength(1)))) cm"
                            } ?? "未设置"
                        )
                    }

                    Section("数据") {
                        infoRow("累计记录", value: "\(records.count) 条")
                    }
                } else {
                    Button("创建宝宝档案") { showEdit = true }
                }

                Section("管理") {
                    Button("清空所有记录", role: .destructive) {
                        showClearConfirm = true
                    }
                }
            }
            .navigationTitle("我的")
            .sheet(isPresented: $showEdit) {
                BabyProfileSheet(mode: baby == nil ? .create : .edit)
            }
            .confirmationDialog(
                "确定清空所有喂养记录吗？此操作不可恢复。",
                isPresented: $showClearConfirm,
                titleVisibility: .visible
            ) {
                Button("清空全部记录", role: .destructive) {
                    for record in records {
                        context.delete(record)
                    }
                    try? context.save()
                }
                Button("取消", role: .cancel) {}
            }
        }
    }

    private func infoRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .foregroundStyle(.primary)
        }
    }
}
