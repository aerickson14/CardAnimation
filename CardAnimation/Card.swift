import SwiftUI

struct Card: Identifiable, Equatable {
    let id: Int
    let foregroundColor: Color
    let backgroundColor: Color
    let title: String
    let number: String
}
