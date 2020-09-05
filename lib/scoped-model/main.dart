import 'package:scoped_model/scoped_model.dart';

import './products.dart';
import './settings.dart';
import './auth.dart';
import './connected_products.dart';

class MainModel extends Model with ConnectedProducts, ProductsModel, AppSettingModel, AuthModel{}