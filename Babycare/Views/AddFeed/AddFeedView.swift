import SwiftUI
import SwiftData
import UIKit

/// 记录喂养（弹窗表单）
struct AddFeedView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var type: FeedType = .breast
    @State private var timestamp: Date = .now
    @State private var durationMin: Int = 15
    @State private var volumeML: Double = 90
    @State private var side: FeedSide = .both
    @State private var note: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("喂养类型") {
                    Picker("类型", selection: $type) {
                        ForEach(FeedType.allCases) { item in
                            Label(item.title, systemImage: item.symbol).tag(item)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("时间") {
                    DatePicker("喂养时间", selection: $timestamp, in: ...Date.now)
                }

                Section("详情") {
                    if type.usesDuration {
                        Stepper("亲喂时长：\(durationMin) 分钟", value: $durationMin, in: 1...120)
                    }
                    if type.usesSide {
                        Picker("喂养侧", selection: $side) {
                            ForEach(FeedSide.allCases) { item in
                                Label(item.title, systemImage: item.symbol).tag(item)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    if type.usesVolume {
                        HStack {
                            Text("奶量")
                            Slider(value: $volumeML, in: 10...300, step: 5)
                            Text("\(Int(volumeML)) ml")
                                .font(.callout.monospacedDigit())
                                .frame(minWidth: 52, alignment: .trailing)
                        }
                    }
                    if type == .solid {
                        TextField("辅食内容（如：米粉 2 勺）", text: $note)
                    }
                }

                if type != .solid {
                    Section("备注") {
                        TextField("备注（可选）", text: $note, axis: .vertical)
                            .lineLimit(2...4)
                    }
                }
            }
            .navigationTitle("记录喂养")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func save() {
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let record = FeedRecord(
            timestamp: timestamp,
            type: type,
            durationMin: type.usesDuration ? durationMin : nil,
            volumeML: type.usesVolume ? volumeML : nil,
            side: type.usesSide ? side : nil,
            note: trimmedNote.isEmpty ? nil : trimmedNote
        )
        context.insert(record)
        try? context.save()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        dismiss()
    }
}

#Preview {
    AddFeedView()
}
