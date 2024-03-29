//
//  ContentView.swift
//  InstaFilter
//
//  Created by A.f. Adib on 12/18/23.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    
    @State private var image : Image?
   
    @State private var filterIntensity = 0.5
    
    @State private var showImgPicker = false
    @State private var inputImage : UIImage?
    @State private var processedImg : UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showFilter = false
    
   var stringTitle = StringTitle()
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Rectangle()
                        .fill(.secondary)
                    
                    Text(stringTitle.tapTile)
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showImgPicker = true
                }
                
                HStack{
                    Text(stringTitle.intensity)
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in
                            applyProcessing()
                        }
                    
                }.padding(.vertical)
                
                HStack{
                    Button(stringTitle.changeFilter) {
                        showFilter = true
                    }
                    
                    Spacer()
                    Button(stringTitle.save, action: save)
                }
                
            }
            .padding([.horizontal, .bottom])
            .navigationTitle(stringTitle.navTitle)
            .onChange(of: inputImage) { _ in
                loadImage()
            }
            .sheet(isPresented: $showImgPicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog(stringTitle.confirmationTitle, isPresented: $showFilter) {
                
                Button(stringTitle.crystallize) { setFilter(CIFilter.crystallize())}
                Button(stringTitle.edges) { setFilter(CIFilter.edges())}
                Button(stringTitle.gaussianBlur) { setFilter(CIFilter.gaussianBlur())}
                Button(stringTitle.pixellate) { setFilter(CIFilter.pixellate())}
                Button(stringTitle.sepiaTone) { setFilter(CIFilter.sepiaTone())}
                Button(stringTitle.unsharpMask) { setFilter(CIFilter.unsharpMask())}
                Button(stringTitle.vignette) { setFilter(CIFilter.vignette())}
                Button(stringTitle.cancel, role: .cancel) { }
                
            }
            
        }
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
       let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKeyPath: kCIInputImageKey)
        applyProcessing()

    }
    
    func save() {
        guard let processedImg = processedImg else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print(stringTitle.saveSucc)
        }
        
        imageSaver.errorHandler = {
            print($0.localizedDescription)
        }
        
        imageSaver.writePhotoAlbum(image: processedImg)
    }
    
    
    func applyProcessing() {
        
//        currentFilter.intensity = Float(filterIntensity)
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
         
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImg = uiImage
        }
    }
    
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
