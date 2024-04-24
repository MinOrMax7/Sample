//
//  MomentPostProblemReportingView.swift
//  Amigo
//
//  Created by Jack Liu on 8/4/22.
//

import SwiftUI
import Popovers

struct MomentPostProblemReportingView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var currentUser : UserViewModel
    
    @ObservedObject var post: MomentIndividualPostViewModel
    @State var content = "Write down your answer here"
    @State var showError = false
    @State var showSuccess = false
    
    @State var expanding = false;

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
                post.reportPost(content: self.content, user: currentUser.user.id)
                self.showSuccess = true
            } label: {
                Text("submit")
                
            }

        }
    }
}
