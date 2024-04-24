//
//  ProfileHistoryListView.swift
//  Amig Pet IOS App
//
//  Created by Jack Liu on 6/4/22.
//

import SwiftUI

struct ProfileHistoryListView: View {
    @StateObject var courses = CourseViewModel()
    @EnvironmentObject var user : UserViewModel
    @StateObject var userCourseHistoryViewModel : UserCourseHistoryViewModel
    
    init(id: String){
        _userCourseHistoryViewModel = StateObject(wrappedValue: UserCourseHistoryViewModel(id: id))
    }
    
    
    let width = UIScreen.main.bounds.size.width * 108 / 390
    let height = UIScreen.main.bounds.size.width * 94 / 390
    
    var body: some View {
        VStack{
            if(courses.list.count > 0){
                List{
                    ForEach(0..<courses.list.count, id:\.self) { tempIndex in
                        let index = courses.list.count - 1 - tempIndex
                        let course = $courses.list[index]
                        CourseListDisplayView(course: course)
                    }
                    .onDelete { (indexSet) in
                        indexSet.forEach{ (i) in
                            userCourseHistoryViewModel.removeCourseHistory(documenetID: userCourseHistoryViewModel.courseHistoryList[i].id)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear(){
            userCourseHistoryViewModel.getCourseHistory()
            courses.getCoursesWithArray(courseArray: userCourseHistoryViewModel.courseHistoryList.map({return $0.courseID}))
        }
        .onChange(of: userCourseHistoryViewModel.courseHistoryList) { V in
            courses.getCoursesWithArray(courseArray: userCourseHistoryViewModel.courseHistoryList.map({return $0.courseID}))
        }

    }
}
