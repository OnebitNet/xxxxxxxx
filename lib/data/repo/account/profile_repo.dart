import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:local_coin/constants/my_strings.dart';
import 'package:local_coin/data/model/authorization/AuthorizationResponseModel.dart';

import '../../../constants/method.dart';
import '../../../core/utils/url_container.dart';
import '../../../view/components/show_custom_snackbar.dart';
import '../../model/account/ProfileResponseModel.dart';
import '../../model/account/user_post_model/UserPostModel.dart';
import '../../model/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class ProfileRepo {
  ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  Future<bool> updateProfile(UserPostModel m,String callFrom) async {

    try{
      apiClient.initToken();

      String url = '${UrlContainer.baseUrl}${callFrom=='profile'?UrlContainer.updateProfileEndPoint:UrlContainer.profileCompleteEndPoint}';


      var request=http.MultipartRequest('POST',Uri.parse(url));
      //'image':m.image!=null?await dio_.MultipartFile.fromFile(m.image?.path??'',filename: m.image?.path.split('/').last??''):'',
      Map<String,String>finalMap={
        'firstname': m.firstname,
        'lastname': m.lastName,
        'address': m.address??'',
        'zip': m.zip??'',
        'state': m.state??"",
        'city': m.city??'',
      };

      request.headers.addAll(<String,String>{'Authorization' : 'Bearer ${apiClient.token}'});
      if(m.image!=null){
        request.files.add( http.MultipartFile('image', m.image!.readAsBytes().asStream(), m.image!.lengthSync(), filename: m.image!.path.split('/').last));
      }
      request.fields.addAll(finalMap);

      http.StreamedResponse response = await request.send();

      String jsonResponse=await response.stream.bytesToString();
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));



      if(model.status?.toLowerCase()==MyStrings.success.toLowerCase()){
        CustomSnackbar.showCustomSnackbar(errorList: [], msg: model.message?.success??[MyStrings.success], isError: false);
        return true;
      }else{
        CustomSnackbar.showCustomSnackbar(errorList: [], msg: model.message?.error??[MyStrings.error], isError: false);
        return false;
      }

    }catch(e){
      return false;
    }

  }

  Future<ProfileResponseModel> loadProfileInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';

    ResponseModel responseModel =
    await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (responseModel.statusCode == 200) {
      ProfileResponseModel model =
      ProfileResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == 'success') {
        return model;
      } else {
        return ProfileResponseModel();
      }
    } else {
      return ProfileResponseModel();
    }
  }

}