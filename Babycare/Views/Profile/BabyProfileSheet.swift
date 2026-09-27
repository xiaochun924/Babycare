import SwiftUI
import SwiftData

/// 宝宝档案表单（创建 / 编辑）
struct BabyProfileSheet: View {
    enum Mode {
        case create, edit
    }

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let mode: Mode
    @Query private var babies: [Baby]

    @State private var name: String = ""
    @State private var emoji: String = "👶"
    @State private var gender: String?
    @State private var birthday: Date = Calendar.current.date(byAdding: .year, value: -1, to: .now) ?? .now
    @State private var birthWeight: String = ""
    @State private var birthHeight: String = ""

    private let emojis = ["👶", "🐣", "🐰", "🐻", "🦊", "🐼", "🐯", "🐨", "🦁", "🐧", "🌈", "⭐️", "🍼", "🎀"]

    var body: some View {
        NavigationStack {
            Form {
                Section("头像") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(emojis, id: \.self) { item in
                                Text(item)
                                    .font(.system(size: 34))
                                    .padding(8)
                                    .background(
                                        Circle().fill(emoji == item ? Theme.peach.opacity(0.25) : Color.clear)
                                    )
                                    .onTapGesture { emoji = item }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("基本信息") {
                    TextField("宝宝昵称", text: $name)
                    Picker("性别", selection: $gender) {
                        Text("未设置").tag(String?.none)
                        Text("男孩").tag(String?.some("男"))
                        Text("女孩").tag(String?.some("女"))
                    }
                    .pickerStyle(.segmented)
                    DatePicker("出生日期", selection: $birthday, in: ...Date.now, displayedComponents: .date)
                }

                Section("出生信息（可选）") {
                    HStack {
                        TextField("出生体重 (kg)", text: $birthWeight)
                            .keyboardType(.decimalPad)
                        Text("kg")
                    }
                    HStack {
                        TextField("出生身高 (cm)", text: $birthHeight)
                            .keyboardType(.decimalPad)
                        Text("cm")
                    }
                }
            }
            .navigationTitle(mode == .create ? "创建宝宝档案" : "编辑档案")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if mode == .edit {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("取消") { dismiss() }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }
                        .fontWeight(.semibold)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            guard mode == .edit, let baby = babies.first else { return }
            name = baby.name
            emoji = baby.avatarEmoji
            gender = baby.gender
            if let birthdayValue = baby.birthday {
                birthday = birthdayValue
            }
            if let weight = baby.birthWeightKg {
                birthWeight = weight.formatted(.number.precision(.fractionLength(1)))
            }
            if let height = baby.birthHeightCm {
                birthHeight = height.formatted(.number.precision(.fractionLength(1)))
            }
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let baby: Baby
        if let existing = babies.first {
            baby = existing
        } else {
            baby = Baby()
            context.insert(baby)
        }
        baby.name = trimmedName
        baby.avatarEmoji = emoji
        baby.gender = gender
        baby.birthday = birthday
        baby.birthWeightKg = Double(birthWeight.replacingOccurrences(of: ",", with: "."))
        baby.birthHeightCm = Double(birthHeight.replacingOccurrences(of: ",", with: "."))
        try? context.save()
        dismiss()
    }
}

#Preview {
    BabyProfileSheet(mode: .create)
}
