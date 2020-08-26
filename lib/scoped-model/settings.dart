import 'package:scoped_model/scoped_model.dart';

class AppSettingModel extends Model{
  bool _nightMode = false;

  void setDisplayMode() {
    _nightMode = !_nightMode;
    notifyListeners();
  }

  bool get displayMode {
    return _nightMode;
  }
}
