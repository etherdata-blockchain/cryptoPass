//
//  BankFormView.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI



struct BankFormView: View {
    let password: Binding<BankPassword>

    
    var body: some View {
        Group{
            Section(header: Text("Password")){
                TextField("Password", text: password.password.projectedValue)
                TextField("Secondary password", text: password.secondaryPassword.projectedValue)
            }
            ForEach(password.securityQuestions.projectedValue){ question in
                Section(header: Text("Question \(question.id)")){
                    SecurityItem(question: question){
                        question in
                    deleteQuestion(question: question)
                    }
                }
            }
            Section{
                Button(action: { addQuestion() }) {
                    Text("Add Security Question")
                }
            }
        }
    }
    
    private func addQuestion(){
        withAnimation{
            password.securityQuestions.wrappedValue.append( SecurityQuestion(id: "\(password.securityQuestions.count)", title: "", answer: ""))
        }
    }
    
    private func deleteQuestion(question: SecurityQuestion){
        withAnimation{
            let index = password.securityQuestions.firstIndex{
                q in
                question.id == q.id
            }
            if let index = index{
                password.securityQuestions.wrappedValue.remove(at: index)
            }
        }
    }
}

struct SecurityItem: View{
    let question: Binding<SecurityQuestion>
    let onDelete: (SecurityQuestion) -> ()
    
    var body: some View {
        Group{
            TextField("Question", text: question.title.projectedValue)
            TextField("Answer", text: question.answer.projectedValue)
            Button(action: { onDelete(question.wrappedValue) }) {
                Text("Delete")
            }
        }
    }
}
