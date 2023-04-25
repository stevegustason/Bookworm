//
//  ContentView.swift
//  Bookworm
//
//  Created by Steven Gustason on 4/22/23.
//

import SwiftUI

struct ContentView: View {
    // Add our managed object context
    @Environment(\.managedObjectContext) var moc
    
    // Fetch request reading all the books we have. Here, we're sorting ascending alphabetically on title, then ascending alphabetically on author. Having two or more sorts can be useful - for example, if the user added the book “Forever” by Pete Hamill, then added “Forever” by Judy Blume – an entirely different book that just happens to have the same title – then specifying a second sort field is helpful.
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>

    // Variable to track showing our AddBook sheet
    @State private var showingAddScreen = false
    
    // Function to delete books from CoreData
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // Find this book in our fetch request
            let book = books[offset]

            // Delete it from the context
            moc.delete(book)
        }

        // Save the context
        try? moc.save()
    }
    
    var body: some View {
        NavigationView {
            List {
                // loop over all of our books
                ForEach(books) { book in
                    // Link out to more information about our book
                    NavigationLink {
                        // Add a link to our detail view of the specified book
                        DetailView(book: book)
                    } label: {
                        // Our HStack will have our emoji rating, passing in the book's rating, then a VStack with the book's title and the author, making sure to unwrap all of the optionals
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                // All of our data is optional, so we need to use nil coalescing throughout
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                // Add swipe to delete using our deleteBooks function
                .onDelete(perform: deleteBooks)
            }
                .navigationTitle("Bookworm")
                .toolbar {
                    // Toolbar item to show a plus sign on the top right to add a new book
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            // Toggle showingAddScreen to true
                            showingAddScreen.toggle()
                        } label: {
                            Label("Add Book", systemImage: "plus")
                        }
                    }
                    // Second toolbar item in the top left (leading instead of trailing) to give us an edit button to delete multiple books at once
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            // Present our AddBookView when showingAddScreen is true, aka when the user clicks the plus button
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView()
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

