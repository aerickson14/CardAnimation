import SwiftUI

struct CardView<Front, Back>: View where Front: View, Back: View {
    private let backgroundColor: Color
    private let height: CGFloat
    private let front: () -> Front
    private let back: () -> Back
    private let onSelect: () -> Void

    @State private var isFlipped: Bool = false
    @Binding var isSelected: Bool
    @State private var cardRotation = 0.0
    @State private var contentRotation = 0.0

    private let aspectRatio: CGFloat = 8.5 / 5.5

    init(
        backgroundColor: Color,
        height: CGFloat,
        isSelected: Binding<Bool>,
        onSelect: @escaping () -> Void,
        @ViewBuilder front: @escaping () -> Front,
        @ViewBuilder back: @escaping () -> Back
    ) {
        self.backgroundColor = backgroundColor
        self.height = height
        self._isSelected = isSelected
        self.onSelect = onSelect
        self.front = front
        self.back = back
    }

    var body: some View {
        ZStack {
            if isFlipped {
                back()
            } else {
                front()
            }
        }
        .rotation3DEffect(.degrees(contentRotation), axis: (x: 0, y: 1, z: 0))
        .padding(8)
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .aspectRatio(aspectRatio, contentMode: .fit)
        .background(
            backgroundColor
        )
        .cornerRadius(8)
        .padding()
        .shadow(color: Color(.systemBackground).opacity(0.2), radius: 8, x: 0, y: 2)
        .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            if isSelected {
                flipCard()
            } else {
                onSelect()
            }
        }
    }

    private func flipCard() {
        let animationTime = 0.5
        withAnimation(Animation.linear(duration: animationTime)) {
            cardRotation += 180
        }

        withAnimation(Animation.linear(duration: 0.001).delay(animationTime / 2)) {
            contentRotation += 180
            isFlipped.toggle()
        }
    }
}
