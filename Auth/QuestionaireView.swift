

import SwiftUI

struct QuestionaireView: View {
    @EnvironmentObject var user: UserViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var birthDateYear = 0
    @State var birthDateMonth = 0
    @State var beenWithYear = 0
    @State var beenWithMonth = 0
    @State var pfp : UIImage? = nil
    
    @State var step = 1
    var body: some View {
        ZStack {
            Color("colors/F1C2CA").ignoresSafeArea() // 1
            ScrollView {
                Spacer()
                VStack{
                    if(step == 1){
                        QuestionaireTextView(text: "Lets start with some questions!")
                        QuestionaireTextFieldView(startingText: "First Name", mainText: $user.user.firstName)
                        QuestionaireTextFieldView(startingText: "Last Name", mainText: $user.user.lastName)
//                        QuestionaireTextFieldView(startingText: "Phone Number(Optional)", mainText: $user.user.phoneNumber)
                            .padding(.bottom, UIScreen.main.bounds.size.height / 80)
                        Button {
                            if user.user.firstName != "" && user.user.lastName != ""{
                                step += 1
                            }
                        } label: {
                            Text("next")
                                .bold()
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color("colors/FEA3AC"))
                                .clipShape(Capsule())
                        }
                    } else if (step == 2) {
                        QuestionaireStep2View(step: $step)
                    } else if (step == 3) {
                        QuestionaireStep3View(step: $step, pfp: $pfp)
                    } else if (step == 4){
                        QuestionaireTextView(text: "Breed?")
                        Picker("Breed", selection: $user.user.breed) {
                            ForEach(Breed.breedList, id: \.self) { breed in
                                Text("\(breed)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        QuestionaireNextButtonView(step: $step, text: "next")
                    } else if (step == 5) {
                        QuestionaireTextView(text: "How old is \(user.user.petName)?")
                        HStack{
                            Picker("birthDateYear", selection: $birthDateYear){
                                ForEach(0...25, id: \.self){ year in
                                    Text("\(year)")
                                }
                            }
                            .background(Color("colors/D9D9D9"))
                            Text("year")
                            Picker("birthDateMonth", selection: $birthDateMonth){
                                ForEach(0...11, id: \.self){ month in
                                    Text("\(month)")
                                }
                            }
                            .background(Color("colors/D9D9D9"))
                            Text("months")
                        }
                        .padding(.bottom, 50)
                        QuestionaireNextButtonView(step: $step, text: "next")
                    } else if (step == 6){
                        QuestionaireTextView(text: "How long have you been with \(user.user.petName)?")
                        HStack{
                            Picker("beenWithYear", selection: $beenWithYear){
                                ForEach(0...25, id: \.self){ year in
                                    Text("\(year)")
                                }
                            }
                            .background(Color("colors/D9D9D9"))
                            Text("year")
                            Picker("beenWithMonth", selection: $beenWithMonth){
                                ForEach(0...11, id: \.self){ month in
                                    Text("\(month)")
                                }
                            }
                            .background(Color("colors/D9D9D9"))
                            Text("months")
                        }
                        .padding(.bottom, 50)
                        QuestionaireNextButtonView(step: $step, text: "next")
                    } else if (step == 7) {
                        QuestionaireQuestionsView(step: $step, text: "Do you need support for potty training?")
                    } else if (step == 8) {
                        QuestionaireQuestionsView(step: $step, text: "Can \(user.user.petName) sit and stay for ten seconds?")
                    } else if (step == 9) {
                        QuestionaireQuestionsView(step: $step, text: "Do you need support for manner training?")
                    } else if (step == 10) {
                        QuestionaireQuestionsView(step: $step, text: "Do you want to teach \(user.user.petName) fun tricks?")
                    }
                    
                }
                .padding(.vertical, 70)
                .padding(.horizontal, 23)
                .frame(width: UIScreen.main.bounds.size.width - 30)
                .background(Color.white)
                .padding(.top, 150)
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .navigationBarHidden(true)
        .accentColor(Color.black)
        .onChange(of: step) { change in
            if(change == 11){
                var components = DateComponents()
                components.year = -birthDateYear
                components.month = -birthDateMonth
                user.user.petBirthDate = Calendar.current.date(byAdding: components, to: Date()) ?? Date()
                components.year = -beenWithYear
                components.month = -beenWithMonth
                user.user.togetherDate = Calendar.current.date(byAdding: components, to: Date()) ?? Date()
                user.user.togetherDate = user.user.togetherDate < user.user.petBirthDate ? user.user.petBirthDate : user.user.togetherDate
                user.createUser()
                if let pfp = pfp {
                    ImageViewModel.uploadImageToStorage(path: "users/\(user.user.id)", localImage: pfp, imageName: "pfp")
                }
            }
        }
        .onAppear(){
            if let firstname = authViewModel.name.givenName {
                self.user.user.firstName = firstname
            }
            if let lastname = authViewModel.name.familyName {
                self.user.user.lastName = lastname
            }
        }
    }
}

struct QuestionaireTextView: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 24, weight: .semibold, design: .default))
            .multilineTextAlignment(.center)
            .padding(.bottom, UIScreen.main.bounds.size.height / 160)
    }
}

struct QuestionaireTextFieldView: View {
    let startingText : String
    @Binding var mainText : String
    var body: some View {
        TextField("  \(startingText)", text: $mainText)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(20)
            .background(Color("colors/D9D9D9"))
        //            .background(
        //                RoundedRectangle(cornerRadius: 10, style: .continuous)
        //                    .stroke(Color.black, lineWidth: 1)
        //            )
    }
}

struct QuestionaireNextButtonView: View {
    @Binding var step : Int
    var text : String
    var body: some View {
        Button {
            step += 1
        } label: {
            Text(text)
                .bold()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color("colors/FEA3AC"))
                .clipShape(Capsule())
        }
    }
}

struct QuestionaireStep2View: View {
    @EnvironmentObject var user: UserViewModel
    @Binding var step : Int
    var body: some View {
        QuestionaireTextView(text: "You are a:")
        Button {
            step += 1
        } label: {
            Text("Dog Parent")
                .bold()
                .frame(maxWidth: .infinity)
                .frame(height: 66)
                .background(Color("colors/EEEEEE"))
                .clipShape(Capsule())
                .padding(.bottom, 15)
        }
        Button {
            user.user.petName = "\(user.user.firstName)'s Future Puppy"
            user.user.petGender = true
            user.user.petBirthDate = Date()
            user.user.togetherDate = Date()
            user.user.questions = [0, 0, 0, 0]
            self.user.createUser()
        } label: {
            Text("Want to be a dog parent")
                .bold()
                .frame(maxWidth: .infinity)
                .frame(height: 66)
                .background(Color("colors/EEEEEE"))
                .clipShape(Capsule())
        }
    }
}

struct QuestionaireStep3View: View {
    @EnvironmentObject var user: UserViewModel
    @Binding var step : Int
    @Binding var pfp : UIImage?
    
    var body: some View {
        QuestionaireTextView(text: "What's your dog's name?")
            .padding(.bottom, UIScreen.main.bounds.size.height / 160)
        HStack(spacing: 30){
            VStack{
                Button {
                    user.user.petGender = true
                } label: {
                    Image("SignIn/male")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .mask(Rectangle().opacity(user.user.petGender ? 1 : 0.3))
                }
                
                Button {
                    user.user.petGender = false
                } label: {
                    Image("SignIn/female")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .mask(Rectangle().opacity(user.user.petGender ? 0.3 : 1))
                }
            }
            
            ImagePickingView(image: $pfp, imageWidth: 120)
        }
        .padding(.bottom, UIScreen.main.bounds.size.height / 160)
        
        QuestionaireTextFieldView(startingText: "", mainText: $user.user.petName)
            .padding(.bottom, UIScreen.main.bounds.size.height / 160)
        
        Button {
            if user.user.petName != "" {
                step += 1
            }
        } label: {
            Text("next")
                .bold()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color("colors/FEA3AC"))
                .clipShape(Capsule())
        }
        .padding(.bottom, UIScreen.main.bounds.size.height / 160)
    }
}

struct QuestionaireQuestionsView: View {
    @EnvironmentObject var user: UserViewModel
    @Binding var step : Int
    @State var arr : [Int] = []
    let text : String
    
    var body: some View {
        QuestionaireTextView(text: text)
        HStack(spacing: 30){
            VStack{
                Button {
                    arr.append(1)
                    step += 1
                } label: {
                    Text("Yes")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("colors/EEEEEE"))
                        .clipShape(Capsule())
                }
                .padding(.bottom, 5)
                
                Button {
                    arr.append(2)
                    step += 1
                } label: {
                    Text("No")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("colors/EEEEEE"))
                        .clipShape(Capsule())
                }
            }
        }
    }
}

