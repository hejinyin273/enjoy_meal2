

import 'load_state.dart';

class DataLoadState<T>{
  LoadState loadState;
  T? data;

  DataLoadState(this.loadState, {this.data});

  @override
  String toString() {
    return 'DataLoadState{loadState: $loadState, data: $data}';
  }
}