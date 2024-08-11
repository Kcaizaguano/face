import 'dart:typed_data';

import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:flutter/services.dart';
//import 'package:aws_signature_v4/aws_signature_v4.dart';

class RekognitionService {
  final Rekognition rekognition;

  RekognitionService({
    required String region,
    required String accessKeyId,
    required String secretAccessKey,
  }) : rekognition = Rekognition(
          region: region,
          credentials: AwsClientCredentials(
            accessKey: accessKeyId,
            secretKey: secretAccessKey,
          ),
        );

  // Hacer la solicitud con aws_rekognition_api
  Future<String> compareFaces() async {
    final ByteData imageData = await rootBundle.load('lib/assets/kevin.jpg');
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    print('Image in Bytes: $imageBytes');

    try {
      final response = await rekognition.compareFaces(
        sourceImage: Image(
            // s3Object: S3Object(
            //   bucket: 'rekognition-console-v4-prod-cmh',
            //   name: 'assets/StaticImageAssets/SampleImages/andy_portrait_2.jpg',
            // ),
            bytes: imageBytes),
        targetImage: Image(
            // s3Object: S3Object(
            //   bucket: 'rekognition-console-v4-prod-cmh',
            //   name: 'assets/StaticImageAssets/SampleImages/andy_portrait.jpg',
            // ),
            bytes: imageBytes),
        similarityThreshold: 0,
      );

      // Comparar mas de dos imagenes y retornar si son iguales o no
      final comparisonDetails = response.faceMatches?.map((match) {
            return 'Similarity: ${match.similarity}';
          }).join('\n') ??
          'No matches found';
      return 'Successful request:\n$comparisonDetails';
    } catch (e) {
      return 'Error comparing faces: $e';
    }
  }
}
