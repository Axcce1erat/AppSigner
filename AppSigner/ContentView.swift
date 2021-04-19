//  ContentView.swift
//  AppSigner
//  Created by Axel Schwarz

import SwiftUI

struct ContentView: View {
    
    @State var workspaceUrl = "Please enter your workspace like /Users/<yourUsername>/Documents/"
    @State var isRunning = false
    
    var body: some View {
        VStack{
            Text("Enter workspace URL")
                .font(.title)
                .padding()
            HStack{
                TextField("Workspace location", text: $workspaceUrl)
                Button(action: {
                    print("Button pressed")
                    print($workspaceUrl)
                    // Check valied URL
                    // change View to Output
                    let executleUrl = URL(fileURLWithPath: "/usr/bin/say")
                    try! Process.run(executleUrl,
                                     arguments: [self.workspaceUrl],
                                     terminationHandler: {_ in self.isRunning = false})
                }) {
                    Text("Execute")
                }.disabled(isRunning)
                .padding(.trailing)
            }
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
