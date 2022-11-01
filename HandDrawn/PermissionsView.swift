//
//  PermissionsView.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 28/10/2022.
//

import SwiftUI
import Photos

/// Permissions prompting view, the permissions (except the saving one) are NOT required due to using the UIImagePicker for media selction
struct PermissionsView: View {
            
    /// Image picker visibility
    @State var isPickerPresented: Bool = false
    /// Currently selected media item
    @State var selectedItem: MediaItem?
    
    /// Current permissions status
    @State var status: Bool? = {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            return nil
        case .authorized:
            return true
        #if swift(>=5.3)
        case .limited:
            return true
        #endif
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }()
        
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.permissionsBackground.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    
                    // MARK: duck.mp4 size is 110KB while duck.json is 242KB + Lottie engine size
                    PlayerView(
                        asset: AVAsset(url: Bundle.main.url(forResource: "duck", withExtension: "mp4")!),
                        size: Binding.constant(CGSize(width: 150, height: 150))
                    )
                    .frame(width: 150, height: 150)
                    
                    Text("Access Your Photos and Videos")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.light)
                        .padding(.bottom, 8)
                    
                    Button(action: {
                        if self.status == true {
                            isPickerPresented = true
                        } else if self.status == nil {
                            PHPhotoLibrary.requestAuthorization { status in
                                if status == .authorized {
                                    self.status = true
                                    return
                                } else if #available(iOS 14.0, *) {
                                    if status == .limited {
                                        self.status = true
                                        return
                                    }
                                }
                                
                                self.status = false
                            }
                        }
                    }, label: {
                        // Permissions button
                        ZStack {
                            if !isPickerPresented {
                                Text(self.status == true ? "Continue" : "Grant Permissions")
                            } else {
                                ActivityIndicator(isAnimating: isPickerPresented).configure {
                                    $0.color = .light
                                }
                            }
                        }
                        .fixedSize()
                        .frame(width: geometry.size.width - 96)
                        .font(.system(size: 17, weight: .bold))
                        .padding()
                        .background(self.status == false ? Color.gray : Color.blue)
                        .cornerRadius(8)
                        .foregroundColor(.light)
                    })
                    .disabled(self.status == false)
                    .sheet(isPresented: $isPickerPresented) { // small delay on first load - but fullScreenCover has different style (and iOS 14+)
                        // also possible to display as fullscreen view
                        ImagePicker(didFinishSelection: { media in
                            selectedItem = media
                            isPickerPresented = false
                        })
                        .edgesIgnoringSafeArea(.all)
                    }
                }
                
                // Editor overlay
                if selectedItem != nil {
                    EditorView(media: selectedItem!, onClose: {
                        selectedItem = nil
                        isPickerPresented = true
                    })
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct PermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsView()
    }
}
