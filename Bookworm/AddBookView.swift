//
//  AddBookView.swift
//  Bookworm
//
//  Created by Steven Gustason on 4/23/23.
//

import SwiftUI

struct AddBookView: View {
    // Environment property to store our managed object context
    @Environment(\.managedObjectContext) var moc
    
    // Add our dismiss environment property so we can dismiss the view
    @Environment(\.dismiss) var dismiss
    
    // State properties for each of our book's data values (except for ID which is generated dynamically)
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    // Property to store genre options
    let genres = ["Select a genre", "Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    // Computed property to make sure all of our address fields are filled out (and not just whitespace)
    var fieldsFilledOut: Bool {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || genre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || genre == "Select a genre" {
            return false
        }
    
    return true
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    TextEditor(text: $review)
                    // Use our custom star rating view, passing in our $rating for our binding variable
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }

                Section {
                    Button("Save") {
                        // Create an instance of our Book class using our managed object context
                        let newBook = Book(context: moc)
                        
                        // Generate our id
                        newBook.id = UUID()
                        
                        // Save the current date
                        newBook.date = Date.now
                        
                        // Save each of our values from the values above
                        newBook.title = title
                        newBook.author = author
                        // Convert rating from an Int to an Int16
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review

                        // Try to save the managed object context to permanent storage
                        try? moc.save()
                        
                        // Dismiss the sheet
                        dismiss()
                    }
                }
                .disabled(fieldsFilledOut == false)
            }
            .navigationTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
