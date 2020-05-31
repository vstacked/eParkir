import 'package:eparkir/api/api_provider.dart';
import 'package:eparkir/models/api_model.dart';

class ApiRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<List<ApiModel>> get getDataPostFromApi =>
      apiProvider.getDataPostFromApiAsync();
}
