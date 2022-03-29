import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kyc/middleware/models/merapi.dart';

class PostKycUploadRequest extends Equatable implements MerapiInputData {
  const PostKycUploadRequest({required this.docType, required this.frontFilePath, required this.backFilePath});

  /// Document type, as string.
  final String docType;

  /// Full path to the filename
  final String frontFilePath;

  /// Full path to the filename
  final String backFilePath;

  @override
  Future<Map<String, dynamic>> toMap() async {
    final contentType = MediaType('image', 'jpeg');

    return <String, dynamic>{
      'auto_upload_file': await MultipartFile.fromFile(
        frontFilePath,
        contentType: contentType,
        filename: '${docType}_FRONT.jpg',
      ),
      'auto_upload_file_back': await MultipartFile.fromFile(
        backFilePath,
        contentType: contentType,
        filename: '${docType}_BACK.jpg',
      )
    };
  }

  @override
  List<Object> get props => [docType, frontFilePath, backFilePath];
}
