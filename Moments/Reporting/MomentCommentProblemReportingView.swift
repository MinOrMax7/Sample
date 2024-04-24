//
//  MomentCommentProblemReportingView.swift
//  Amigo
//
//  Created by Jack Liu on 8/5/22.
//

import SwiftUI
import Popovers

struct MomentCommentProblemReportingView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var currentUser : UserViewModel

    @ObservedObject var comment : MomentCommentViewModel
    @Binding var commentID: String
    @State var content = "Write down your answer here"
    @State var showError = false
    @State var showSuccess = false
    

    let placeholderString = "Write down your answer here"
    var body: some View {
        ProblemReportingView(content: $content, showError: $showError, showSuccess: $showSuccess, placeholderString: placeholderString)
        .navigationTitle("Report a Problem")
        .toolbar {
            Button {
                guard content != placeholderString  && content.count > 40 else {
                    self.showError = true
                    return
                }
                comment.reportComment(id: commentID, content: content, user: currentUser.user.id)
                self.showSuccess = true
            } label: {
                Text("submit")
            }

        }
    }
}
