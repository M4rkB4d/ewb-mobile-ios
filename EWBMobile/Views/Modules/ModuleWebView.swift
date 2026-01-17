//
//  ModuleWebView.swift
//  EWBMobile
//
//  Created by Mark Paul Ramirez on 1/17/26.
//

import SwiftUI
import WebKit

// MARK: - Module WebView Screen

struct ModuleWebViewScreen: View {
    let module: BankingModule
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State private var error: Error?
    @State private var webViewKey = UUID()
    
    var body: some View {
        ZStack {
            ModuleWebView(
                url: URL(string: module.webURL)!,
                token: AuthService.shared.authToken,
                isLoading: $isLoading,
                error: $error
            )
            .id(webViewKey)
            .ignoresSafeArea(edges: .bottom)
            
            // Loading overlay
            if isLoading && error == nil {
                LoadingView(message: "Loading \(module.name)...")
            }
            
            // Error view
            if let error = error {
                ErrorView(error: error) {
                    reload()
                }
            }
        }
        .navigationTitle(module.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    reload()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(isLoading)
            }
        }
    }
    
    private func reload() {
        error = nil
        isLoading = true
        webViewKey = UUID()
    }
}

// MARK: - Module WebView

struct ModuleWebView: UIViewRepresentable {
    let url: URL
    let token: String?
    @Binding var isLoading: Bool
    @Binding var error: Error?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        // Add user script to inject auth token
        if let token = token {
            let script = """
                localStorage.setItem('token', '\(token)');
                localStorage.setItem('user', localStorage.getItem('user') || '{}');
            """
            let userScript = WKUserScript(
                source: script,
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
            configuration.userContentController.addUserScript(userScript)
        }
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.bounces = true
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = "EWBMobile-iOS/\(Constants.App.version)"
        
        // Load the module URL
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: ModuleWebView
        
        init(_ parent: ModuleWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
            parent.error = nil
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            parent.error = error
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            parent.error = error
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            // Enable JavaScript for all navigations
            preferences.allowsContentJavaScript = true
            
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel, preferences)
                return
            }
            
            // Allow navigation within the module
            if url.absoluteString.contains(Constants.WebModules.billsPayment) ||
               url.absoluteString.contains(Constants.WebModules.fundTransfer) ||
               url.absoluteString.contains(Constants.WebModules.buyLoad) ||
               url.host == "localhost" {
                decisionHandler(.allow, preferences)
                return
            }
            
            // Open external links in Safari
            if navigationAction.navigationType == .linkActivated {
                UIApplication.shared.open(url)
                decisionHandler(.cancel, preferences)
                return
            }
            
            decisionHandler(.allow, preferences)
        }
    }
}

// MARK: - Error View

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("Unable to Connect")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Button(action: retryAction) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(Color.ewbBlue)
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        ModuleWebViewScreen(module: BankingModule.modules[0])
    }
}
