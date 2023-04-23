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
    
    // Fetch request reading all the books we have
    @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>

    // Variable to track showing our AddBook sheet
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                // loop over all of our books
                ForEach(books) { book in
                    // Link out to more information about our book
                    NavigationLink {
                        // All of our data is optional, so we need to use nil coalescing throughout
                        Text(book.title ?? "Unknown Title")
                    } label: {
                        // Our HStack will have our emoji rating, passing in the book's rating, then a VStack with the book's title and the author, making sure to unwrap all of the optionals
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
                .navigationTitle("Bookworm")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            // Toggle showingAddScreen to true
                            showingAddScreen.toggle()
                        } label: {
                            Label("Add Book", systemImage: "plus")
                        }
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

