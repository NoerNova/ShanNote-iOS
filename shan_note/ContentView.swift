import SwiftUI
import Combine
import SwiftData
import UIKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var text = ""
    
    var body: some View {
        NavigationView {
            VStack {
                KeyboardHandlingTextViewWrapper(text: $text)
                    .frame(height: UIScreen.main.bounds.height / 2)
                    .padding()
                    .border(Color.gray, width: 1)
                Spacer()
            }
            .navigationTitle("Shan Note App")
        }
    }
}

class KeyboardHandlingTextView: UITextView {
    var onKeyPress: ((String) -> Void)?
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
            
        var didHandleEvent = false
        
        for press in presses {
            
            guard let key = press.key else { continue }
            
            if key.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow ||
                key.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow ||
                key.charactersIgnoringModifiers == UIKeyCommand.inputUpArrow ||
                key.charactersIgnoringModifiers == UIKeyCommand.inputDownArrow {
                didHandleEvent = false
            } else {
                if let character = key.characters.first,
                   character.isLetter || character.isSymbol || character.isPunctuation {
                    didHandleEvent = true
                    
                    let mappedChar = alphabetMapping(for: character)
                    self.insertText(String(mappedChar))
                }
            }
        }
        
        if didHandleEvent == false {
            super.pressesBegan(presses, with: event)
        }
    }
}

extension KeyboardHandlingTextView {
    func alphabetMapping(for char: Character) -> String {
        let qwertyLowercase = "qwertyuiop[]\\asdfghjkl;'zxcvbnm,./"
        let qwertyUppercase = "QWERTYUIOP{}|ASDFGHJKL:\"ZXCVBNM<>?"
        let shanCharacterLowercased = ["ၸ", "တ", "ၼ", "မ", "ႄ", "ပ", "ၵ", "င", "သ", "ၺ", "ႁ", "\"", "ရ","ေ", "ျ", "ိ", "်", "ႂ", "ႉ", "ႈ", "ု", "ူ", "း", "ႊ","ၽ", "ထ", "ၶ", "လ", "ႇ", "ဢ", "ၢ", "ယ", "ွ", "။"]
        
        let shanCharacterUppercased = ["ၹ", "ၻ", "ꧣ", "ၿ", "", "ြ", "ၷ", "", "ဝ", "[", "]", "”", "႟","ဵ", "ှ", "ီ", "ႅ", "…", "ံ", "", "", "", "", "႞","ၾ", "ꩪ", "ꧠ", "ꩮ", "ႆ", "", "ႃ", "", "?", "၊"]
        
        if let index = qwertyLowercase.firstIndex(of: char) {
            return String(shanCharacterLowercased[shanCharacterLowercased.index(shanCharacterLowercased.startIndex, offsetBy: qwertyLowercase.distance(from: qwertyLowercase.startIndex, to: index))])
        } else if let index = qwertyUppercase.firstIndex(of: char) {
            return String(shanCharacterUppercased[shanCharacterUppercased.index(shanCharacterUppercased.startIndex, offsetBy: qwertyUppercase.distance(from: qwertyUppercase.startIndex, to: index))])
        }
        
        return String(char)
    }
}

struct KeyboardHandlingTextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = KeyboardHandlingTextView()
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.isEditable = true
        textView.backgroundColor = UIColor.clear
        textView.onKeyPress = { newText in
            self.text = newText
        }
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
