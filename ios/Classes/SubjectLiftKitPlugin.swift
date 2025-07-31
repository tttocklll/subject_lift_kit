import Flutter
import UIKit
import Vision
import CoreImage

public class SubjectLiftKitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let api = SubjectLiftApiImpl()
    SubjectLiftApiSetup.setUp(binaryMessenger: registrar.messenger(), api: api)
  }
}

class SubjectLiftApiImpl: SubjectLiftApi {
  func extractForeground(imageData: ImageData, completion: @escaping (Result<SegmentationResult, Error>) -> Void) {
    // Convert data to UIImage
    guard let uiImage = UIImage(data: imageData.imageBytes) else {
      let result = SegmentationResult(
        maskImageBytes: nil,
        cutoutImageBytes: nil,
        error: "Failed to create UIImage from data"
      )
      completion(.success(result))
      return
    }
    
    // Check image size
    let maxSize: CGFloat = 4096
    if uiImage.size.width > maxSize || uiImage.size.height > maxSize {
      let result = SegmentationResult(
        maskImageBytes: nil,
        cutoutImageBytes: nil,
        error: "Image size too large. Maximum size is \(Int(maxSize))x\(Int(maxSize)) pixels"
      )
      completion(.success(result))
      return
    }
    
    // Convert to CIImage
    guard let ciImage = CIImage(image: uiImage) else {
      let result = SegmentationResult(
        maskImageBytes: nil,
        cutoutImageBytes: nil,
        error: "Failed to create CIImage"
      )
      completion(.success(result))
      return
    }
    
    // Create and perform Vision request
    if #available(iOS 17.0, *) {
      let request = VNGenerateForegroundInstanceMaskRequest()
      let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
      
      do {
        try handler.perform([request])
        
        guard let observation = request.results?.first as? VNInstanceMaskObservation else {
          let result = SegmentationResult(
            maskImageBytes: nil,
            cutoutImageBytes: nil,
            error: "No foreground objects detected"
          )
          completion(.success(result))
          return
        }
        
        // Process the mask
        guard let maskPixelBuffer = try? observation.generateScaledMaskForImage(forInstances: observation.allInstances, from: handler) else {
          let result = SegmentationResult(
            maskImageBytes: nil,
            cutoutImageBytes: nil,
            error: "Failed to generate mask"
          )
          completion(.success(result))
          return
        }
        
        // Convert mask to image data
        let maskCIImage = CIImage(cvPixelBuffer: maskPixelBuffer)
        let context = CIContext()
        
        // Generate mask image data
        var maskImageData: Data?
        if let cgImage = context.createCGImage(maskCIImage, from: maskCIImage.extent) {
          let maskUIImage = UIImage(cgImage: cgImage)
          maskImageData = maskUIImage.pngData()
        }
        
        // Generate cutout image
        var cutoutImageData: Data?
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
          let originalImage = UIImage(cgImage: cgImage)
          
          // Apply mask to original image
          if let cutoutImage = applyMask(to: originalImage, mask: maskCIImage, context: context) {
            cutoutImageData = cutoutImage.pngData()
          }
        }
        
        let result = SegmentationResult(
          maskImageBytes: maskImageData,
          cutoutImageBytes: cutoutImageData,
          error: nil
        )
        completion(.success(result))
        
      } catch {
        let result = SegmentationResult(
          maskImageBytes: nil,
          cutoutImageBytes: nil,
          error: "Vision processing failed: \(error.localizedDescription)"
        )
        completion(.success(result))
      }
    } else {
      let result = SegmentationResult(
        maskImageBytes: nil,
        cutoutImageBytes: nil,
        error: "This feature requires iOS 17.0 or later"
      )
      completion(.success(result))
    }
  }
  
  private func applyMask(to image: UIImage, mask: CIImage, context: CIContext) -> UIImage? {
    guard let cgImage = image.cgImage else { return nil }
    let ciImage = CIImage(cgImage: cgImage)
    
    // Create a filter to apply the mask
    guard let filter = CIFilter(name: "CIBlendWithMask") else { return nil }
    filter.setValue(ciImage, forKey: kCIInputImageKey)
    filter.setValue(mask, forKey: kCIInputMaskImageKey)
    
    // Create transparent background
    let transparent = CIImage(color: CIColor.clear).cropped(to: ciImage.extent)
    filter.setValue(transparent, forKey: kCIInputBackgroundImageKey)
    
    guard let outputImage = filter.outputImage,
          let cgOutput = context.createCGImage(outputImage, from: outputImage.extent) else {
      return nil
    }
    
    return UIImage(cgImage: cgOutput)
  }
}