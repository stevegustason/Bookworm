//
//  ContentView.swift
//  Bookworm
//
//  Created by Steven Gustason on 4/22/23.
//

import SwiftUI

// Struct to create a styled button
struct PushButton: View {
    // Pass in a title
    let title: String
    // Binding variable to track whether it's toggled on or off
    @Binding var isOn: Bool

    // Different colors for when the button is toggled on or off
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]

    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        // Use a gradiant with a ternary operator to use onColors when isOn is true and offColors otherwise
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct ContentView: View {
    // Variable that will essentially be bound to isOn
    @State private var rememberMe = false
    
    @AppStorage("notes") private var notes = ""
    
    // Creates a fetch request (fetching our data according to our data model) with no sorting, and places it into a property called students that has the the type FetchedResults<Student>
    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
    
    // When it comes to adding and saving objects, we need access to the managed object context that it is in SwiftUI’s environment. This is another use for the @Environment property wrapper – we can ask it for the current managed object context, and assign it to a property for our use
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        NavigationView{
            VStack {
                // Create our push button by passing in a title and our state variable that will be bound to isOn
                PushButton(title: "Remember Me", isOn: $rememberMe)
                Text(rememberMe ? "On" : "Off")
                
                // Text editor is for multiline text input. It's even similar than text field - there's no placeholder text or any configuration options. You just pass in a two way binding to a string
                TextEditor(text: $notes)
                    .navigationTitle("Notes")
                    .padding()
                
                List(students) { student in
                    // CoreData generates an optional property because it may have a value and it may not
                    Text(student.name ?? "Unknown")
                }
                
                Button("Add") {
                    let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
                    let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]
                    
                    let chosenFirstName = firstNames.randomElement()!
                    let chosenLastName = lastNames.randomElement()!
                    
                    // Create a Student object using the class CoreData generated for us, which is attached to the managed object context
                    let student = Student(context: moc)
                    // Assign a UUID
                    student.id = UUID()
                    // And our randomly generated first and last names from the lists above
                    student.name = "\(chosenFirstName) \(chosenLastName)"
                    
                    // Finally, we ask our managed object context to save itself so our data is written to the persistent store
                    try? moc.save()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController()
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

