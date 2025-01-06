import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum LoaderType {
  chasingDots,
  doubleBounce,
  wave,
  wanderingCubes,
}

class Loading extends StatelessWidget {
  final LoaderType? loaderType;

  const Loading({super.key, this.loaderType = LoaderType.chasingDots});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
      child: Center(
        child: _getLoader(context),
      ),
    );
  }

  Widget _getLoader(BuildContext context) {
    switch (loaderType) {
      case LoaderType.chasingDots:
        return SpinKitChasingDots(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        );
      case LoaderType.doubleBounce:
        return SpinKitDoubleBounce(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        );
      case LoaderType.wave:
        return SpinKitWave(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        );
      case LoaderType.wanderingCubes:
        return SpinKitWanderingCubes(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        );
      default:
        return SpinKitChasingDots(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        );
    }
  }
}
