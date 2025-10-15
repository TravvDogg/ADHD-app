import SwiftUI
import SwiftData
import UIKit

struct CaptureCard: View {
    let capture: Capture

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // Image on the left — takes half the width and is square
                Group {
                    if let image = capture.uiImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                    } else {
                        ZStack {
                            Color(.systemGray5)
                            Image(systemName: "photo")
                                .font(.system(size: 28).bold())
                                .foregroundStyle(Color(.systemGray2))
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .clipped()

                // Right side tiles take the other half of the width and match image height
                GeometryReader { proxy in
                    let spacing: CGFloat = 8
                    let tileHeight = (proxy.size.height - spacing) / 2
                    let contentPadding: CGFloat = 10
                    let iconSize = max(0, tileHeight - contentPadding * 2)

                    VStack(spacing: spacing) {
                        StepsTile(stepsText: stepsText, iconSize: iconSize)
                            .frame(maxWidth: .infinity)
                            .frame(height: tileHeight)

                        EmotionTile(
                            emojiText: emotionText,
                            emojiImage: emojiImage(from: capture.displayEmoji),
                            iconSize: iconSize
                        )
                            .frame(maxWidth: .infinity)
                            .frame(height: tileHeight)
                    }
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
            }

            // Note
            Text(capture.displayNote)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            // Bottom bar
            HStack {
                Text(capture.displayMission.capitalized)
                    .font(.footnote.bold())
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "pencil.circle.fill")
                    .foregroundStyle(Color(.systemGray))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
        )
    }

    private var stepsText: String {
        if let steps = capture.steps, steps > 0 {
            return "\(steps)"
        } else {
            return "—"
        }
    }

    private var emotionText: String {
        let mapping: [String: String] = [
            "😆": "happy",
            "😅": "anxious",
            "😐": "neutral",
            "😞": "unhappy",
            "😡": "upset",
            "😳": "awkward"
        ]
        return mapping[capture.displayEmoji] ?? "none selected"
    }

    private func emojiImage(from emoji: String) -> Image {
        let trimmed = emoji.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return Image(systemName: "face.smiling").renderingMode(.template)
        }
        let font = UIFont.systemFont(ofSize: 320)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (emoji as NSString).size(withAttributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        (emoji as NSString).draw(at: .zero, withAttributes: attributes)
        let uiImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return Image(uiImage: uiImage)
    }
}

private struct InfoTile<Leading: View>: View {
    let leading: Leading
    let title: String
    let value: String
    let gradient: LinearGradient
    let fixedIconSize: CGFloat?

    init(
        title: String,
        value: String,
        gradient: LinearGradient,
        fixedIconSize: CGFloat? = nil,
        @ViewBuilder leading: () -> Leading
    ) {
        self.title = title
        self.value = value
        self.gradient = gradient
        self.fixedIconSize = fixedIconSize
        self.leading = leading()
    }

    var body: some View {
        GeometryReader { proxy in
            let contentPadding: CGFloat = 10
            let computed = max(0, proxy.size.height - contentPadding * 2)
            let iconSize = fixedIconSize ?? computed

            HStack(alignment: .center, spacing: 8) {
                leading
                    .frame(width: iconSize, height: iconSize)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                    Text(value)
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.9))
                }
                Spacer(minLength: 0)
            }
            .padding(contentPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

private struct StepsTile: View {
    let stepsText: String
    let iconSize: CGFloat?

    var body: some View {
        InfoTile(
            title: "Steps",
            value: stepsText,
            gradient: LinearGradient(colors: [Color.orange, Color.yellow], startPoint: .topLeading, endPoint: .bottomTrailing),
            fixedIconSize: iconSize
        ) {
            Image(systemName: "figure.walk.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: iconSize, height: iconSize)
        }
    }
}

private struct EmotionTile: View {
    let emojiText: String
    let emojiImage: Image
    let iconSize: CGFloat?

    var body: some View {
        InfoTile(
            title: "Emotion",
            value: emojiText,
            gradient: LinearGradient(colors: [Color.teal, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing),
            fixedIconSize: iconSize
        ) {
            emojiImage
                .resizable()
                .scaledToFill()
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    let sample = Capture(
        title: "Square Object",
        mission: "Square",
        note: "On my walk today, I noticed a square flower pot sitting by the corner of a house. It instantly reminded me of my grandma's place — she always had one just like it near her front steps, filled with herbs she loved to cook with.",
        emoji: "😆",
        steps: 4120,
        imageData: nil
    )
    return CaptureCard(capture: sample)
        .padding()
        .background(Color(.systemGray6))
}


//let mapping: [String: String] = [
//    "😆": "happy",
//    "😅": "anxious",
//    "😐": "neutral",
//    "😞": "unhappy",
//    "😡": "upset",
//    "😳": "awkward"
