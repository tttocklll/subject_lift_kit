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
    // TODO: Implement Vision Framework processing
    let result = SegmentationResult(
      maskImageBytes: nil,
      cutoutImageBytes: nil,
      error: "Not implemented yet"
    )
    completion(.success(result))
  }
}