import "package:app/service/exceptions.dart";
import "package:flutter/services.dart";
import "package:http/http.dart" as http;
import "package:m7_livelyness_detection/index.dart";

class DeepFaceApi {
  // 172.20.10.7
  final String _basePath = "http://10.10.23.228:8080";

  // convert image from path into a base64, then it can be feeded to the API

  Future<String> convertImageFromPath(String imagePath) async {
    final byteData = await rootBundle.load("assets/$imagePath");
    final file = File("${(await getTemporaryDirectory()).path}/$imagePath");
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    Uint8List bytes = file.readAsBytesSync();
    String base64Image = base64Encode(bytes);
    String base64ImageApiFormat = "data:image/jpeg;base64,${base64Image}";
    debugPrint(base64ImageApiFormat);
    return base64ImageApiFormat;
  }

  Future<void> verifyFace(String imagePath1, String imagePath2) async {
    Map<String, String> headers = <String, String>{
      "Content-Type": "application/json"
    };
    String base64Image1 = await convertImageFromPath(imagePath1);
    String base64Image2 = await convertImageFromPath(imagePath2);

    Map<String, String> body = <String, String>{
      "img1_path": base64Image1,
      "img2_path": base64Image2,
      "model_name": "GhostFaceNet",
      "detector_backend": "mtcnn",
      "distance_metric": "euclidean"
    };
    final msg = jsonEncode(body);
    final url = Uri.parse("$_basePath/verify");
    print("sending request to: $url");
    try {
      http.Response res = await http.post(url, body: msg, headers: headers);
      switch (res.statusCode) {
        case HttpStatus.ok:
          print("Response from the API${res.body}");
        default:
          throw UnexpectedResponseException(
              "unexpected HTTP status : ${res.statusCode} ${res.reasonPhrase}");
      }
    } on SocketException catch (e) {
      throw NoConnectionException(e);
    }
  }
}
