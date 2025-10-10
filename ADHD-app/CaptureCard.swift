import SwiftUI
import SwiftData
import UIKit

struct CaptureCard: View {
    let capture: Capture

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // Image on the left
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
                .frame(width: 96, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(spacing: 8) {
                    // Steps tile
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "figure.walk.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(.white)
                            .shadow(radius: 0)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Steps")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.9))
                            Text(stepsText)
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(10)
                    .background(
                        LinearGradient(colors: [Color.orange, Color.yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Emotion tile
                    HStack(alignment: .center, spacing: 8) {
                        emojiImage(from: capture.displayEmoji)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Emotion")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.9))
                            Text(capture.displayEmoji)
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(10)
                    .background(
                        LinearGradient(colors: [Color.teal, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
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
            return "\(steps) steps"
        } else {
            return "—"
        }
    }

    private func emojiImage(from emoji: String) -> Image {
        let font = UIFont.systemFont(ofSize: 28)
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

#Preview {
    let sample = Capture(
        title: "Square Object",
        mission: "Square",
        note: "On my walk today, I noticed a square flower pot sitting by the corner of a house. It instantly reminded me of my grandma's place — she always had one just like it near her front steps, filled with herbs she loved to cook with.",
        emoji: "😄",
        steps: 4120,
        imageData: nil
    )
    return CaptureCard(capture: sample)
        .padding()
        .background(Color(.systemGray6))
}
