import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kyc/middleware/models/merapi.dart';

class PostKycSelfieRequest extends Equatable implements MerapiInputData {
  const PostKycSelfieRequest({required this.filePath});

  /// Full path to the filename
  final String filePath;

  @override
  Future<Map<String, dynamic>> toMap() async {
    final contentType = MediaType('image', 'jpeg');

    return <String, dynamic>{
      'auto_upload_file': await MultipartFile.fromFile(
        filePath,
        contentType: contentType,
        filename: 'SELFIE.jpg',
      )
    };
  }

  @override
  List<Object> get props => [filePath];
}
