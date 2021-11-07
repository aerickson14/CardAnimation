import SwiftUI

struct CardsView: View {

    private let cards: [Card] = [
        Card(id: 1, foregroundColor: .white, backgroundColor: .black, title: "Mastercard", number: "123 123 123 1234"),
        Card(id: 2, foregroundColor: .black, backgroundColor: .white, title: "IKEA", number: "1231231231234"),
        Card(id: 3, foregroundColor: .black, backgroundColor: Color(.systemGray5), title: "Canada Life", number: "1231231231234"),
        Card(id: 4, foregroundColor: .black, backgroundColor: Color(red: 187/255, green: 38/255, blue: 26/255), title: "Canadian Tire", number: "1231231231234"),
        Card(id: 5, foregroundColor: .black, backgroundColor: Color(red: 184/255, green: 43/255, blue: 53/255), title: "Tims Rewards", number: "1231231231234"),
        Card(id: 5, foregroundColor: .white, backgroundColor: Color(red: 154/255, green: 129/255, blue: 71/255), title: "Air Miles", number: "1231231231234")
    ]
    private let cardHeight: CGFloat = 180
    private let nonSelectedCardHeightPercentage: CGFloat = 0.8
    private let cardOffset: CGFloat = 40
    private let cardSpacing: CGFloat = 20
    // When using zstack with offsets the scrollview's content height is smaller than it needs to be
    // This offset adds padding to the bottom of the view so all cards can be scrolled to
    private var totalOffset: CGFloat {
        return CGFloat(cards.count - 1) * (cardHeight + cardSpacing)
    }
    @State private var selectedCard: Card?

    init(selectedIndex: Int = 0) {
        self._selectedCard = State(initialValue: cards[selectedIndex])
    }

    var body: some View {
        ZStack {
            backgroundView
            ScrollView {
                cardsStackView
            }
        }
    }

    var cardsStackView: some View {
        ZStack {
            ForEach(cards) { card in
                HStack {
                    Spacer()
                    CardView(
                        backgroundColor: card.backgroundColor,
                        height: cardHeight,
                        isSelected: Binding<Bool>(
                            get: { selectedCard == card },
                            set: { selectedCard = $0 ? card : nil }
                        ),
                        onSelect: {
                            withAnimation {
                                selectedCard = card
                            }
                        },
                        front: { frontView(for: card) },
                        back: { backView(for: card) }
                    )
                        .rotation3DEffect(.degrees(card == selectedCard ? 0 : -10), axis: (x: 1, y: 0, z: 0))
                        .transformEffect(CGAffineTransform(a: 1, b: 0, c: 0, d: card == selectedCard ? 1 : nonSelectedCardHeightPercentage, tx: 0, ty: 0))
                        .offset(y: yOffset(for: card))
                    Spacer()
                }
            }
        }
        .padding(.bottom, totalOffset)
    }

    var backgroundView: some View {
        Color(.clear)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color(red: 49/255, green: 71/255, blue: 85/255),
                            .black
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea()
    }

    func frontView(for card: Card) -> some View {
        VStack {
            HStack {
                Text(card.title)
                    .fontWeight(.semibold)
                    .foregroundColor(card.foregroundColor)
                Spacer()
            }
            Spacer()
            Text(card.number)
                .foregroundColor(card.foregroundColor)
            Spacer()
        }
    }

    func backView(for card: Card) -> some View {
        Text("Back")
    }

    func yOffset(for card: Card) -> CGFloat {
        guard let cardIndex = cards.firstIndex(of: card) else { return 0 }

        let selectedIndex = selectedCard.map { cards.firstIndex(of: $0) ?? .max } ?? .max
        var offset: CGFloat = 0
        let selectedCardIsAbove = cardIndex > selectedIndex
        let cardsAbove = cardIndex > 0 ? cardIndex : 0
        if selectedCardIsAbove {
            offset += cardHeight
        }
        offset += CGFloat(cardsAbove) * (cardOffset)

        NSLog("\(card.title) \(offset)")
        return offset
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ForEach(0 ... 4, id: \.self) { index in
                CardsView(selectedIndex: index)
            }
        }
        .previewLayout(.sizeThatFits)
        .frame(width: 1800)
    }
}
