//
//  ResizeableTextFieldView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 01.05.24.
//

//import SwiftUI
//
//struct ResizeableTextFieldView: View {
//        
//        @EnvironmentObject var obj: observed
//        
//        var body: some View {
//            
//            VStack{
//                
//                MultiTextField()
//                    .frame(height: self.obj.size)
//                    .padding(10)
//                    .background(Color.yellow)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//    }
//
//    struct MultiTextField : UIViewRepresentable {
//        
//        func makeCoordinator() -> MultiTextField.Coordinator {
//            return MultiTextField.Coordinator(parent1: self)
//        }
//        
//        @EnvironmentObject var obj : observed
//        
//        func makeUIView(context: UIViewRepresentableContext<MultiTextField>) -> UITextView {
//            
//            let view = UITextView()
//            view.font = .systemFont(ofSize: 19)
//            view.text = "Type something"
//            view.textColor = UIColor.black.withAlphaComponent(0.35)
//            view.backgroundColor = .clear
//            view.delegate = context.coordinator
//            
//            self.obj.size = view.contentSize.height
//            view.isEditable = true
//            view.isUserInteractionEnabled = true
//            view.isScrollEnabled = true
//            return view
//        }
//        
//        func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiTextField>) {
//            
//        }
//        
//        class Coordinator : NSObject, UITextViewDelegate {
//            
//            var parent :  MultiTextField
//            
//            init(parent1 : MultiTextField) {
//                
//                parent = parent1
//            }
//            
//            func textViewDidBeginEditing(_ textView: UITextView) {
//                
//                textView.text = ""  Vielleicht hier die @Published textToTranslate reinmachen
//                textView.textColor = .black
//            }
//            
//            func textViewDidChange(_ textView: UITextView) {
//                
//                self.parent.obj.size = textView.contentSize.height
//            }
//        }
//    }
//
//    class observed : ObservableObject {
//        
//        @Published var size : CGFloat = 0
//    }
//
//
//struct ContentView_Preview: PreviewProvider {
//    static var previews: some View {
//        ResizeableTextFieldView()
//    }
//}
