import 'package:scoped_model/scoped_model.dart';

class AppSettingModel extends Model{
  bool _nightMode = false;

  void setMode() {
    _nightMode = !_nightMode;
  }

  bool get displayMode {
    return _nightMode;
  }
}
