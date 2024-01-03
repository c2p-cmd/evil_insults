//
//  ContentView.swift
//  EvilInsults
//
//  Created by Sharan Thakur on 03/01/24.
//

import SwiftUI

struct ContentView: View {
    @State private var apiService = APIService()
    
    var view: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.purple.gradient)
                .shadow(radius: 5)
            Text(apiService.insult)
                .font(.title3)
                .padding()
                .multilineTextAlignment(.center)
                .fontDesign(.monospaced)
                .foregroundStyle(.white)
                .animation(.bouncy, value: apiService.insult)
                .transition(.push(from: .leading))
                .id(apiService.insult)
        }
        .frame(maxHeight: 300)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 100) {
                Picker("Pick a language", selection: $apiService.language) {
                    ForEach(Languages.allCases, id: \.id) {
                        let value = $0.rawValue
                        
                        Text(value)
                            .tag($0)
                    }
                }
                .pickerStyle(.palette)
                .disabled(apiService.isBusy)
                
                view
                
                if let error = apiService.error {
                    Text(error.localizedDescription)
                        .foregroundStyle(.red)
                }
                
                if apiService.isBusy {
                    ProgressView()
                }
            }
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    let image = Image(uiImage: viewToImage())
                    ShareLink(
                        item: image,
                        preview: SharePreview("😈", image: image)
                    )
                    .tint(.purple)
                    
                    Spacer()
                    
                    Button("Fetch", action: apiService.fetchJoke)
                        .tint(.purple)
                        .buttonStyle(.bordered)
                }
            }
        }
    }
    
    @MainActor
    func viewToImage() -> UIImage {
        let renderer = ImageRenderer(content: view)
        
        return renderer.uiImage ?? UIImage(systemName: "x")!
    }
}

#Preview {
    ContentView()
}
