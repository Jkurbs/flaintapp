//
//  AuthView.swift
//  Flaint
//
//  Created by Kerby Jean on 7/10/22.
//  Copyright © 2022 Kerby Jean. All rights reserved.
//

import SwiftUI

struct UsernameView: View {
    
    @ObservedObject var model: AuthModel
    @State private var buttonDisabled = true
    
    @State var username: String = ""
    var body: some View {
        VStack {
            Text("Choose a username")
            VStack {
                VStack {
                    Form {
                        TextField("Username", text: $model.username)
                    }
                    
                    Button("Next") {
                        
                    }
                    .disabled(buttonDisabled)
                    .onReceive(model.validateUsername) {valide in
                        self.buttonDisabled = !valide!
                    }
                }
                Spacer()
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView(model: AuthModel())
            .previewInterfaceOrientation(.portrait)
        
    }
}
