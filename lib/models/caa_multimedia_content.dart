abstract class CaaMultimediaContent {
  CaaMultimediaContent();
  int? _id;
  late String _label;
  late String _url;

  int? get id => this._id;
  set id(value) => this._id = value;
  String get label => this._label;
  set label(value) => this._label = value;
  String get url => this._url;
  set url(value) => this._url = value;
}
