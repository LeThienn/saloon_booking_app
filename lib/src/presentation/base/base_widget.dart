import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:saloon_booking_app/src/presentation/base/base_viewmodel.dart';

class BaseWidget<T extends BaseViewModel> extends StatefulWidget {
  /*
    child, childDesktop, childMobile, childTablet:
    Its widget not listen on consumer
    Use to paint to widget not change(Appbar, background....)
   */
  final Widget? child;
  final Widget? childDesktop;
  final Widget? childMobile;
  final Widget? childTablet;

  final Widget Function(BuildContext context, T viewModel, Widget? child)
      builder;
  final T viewModel;
  final Function(T? viewModel)? onViewModelReady;

  const BaseWidget({
    Key? key,
    required this.builder,
    required this.viewModel,
    this.child,
    this.childDesktop,
    this.childMobile,
    this.childTablet,
    this.onViewModelReady,
  }) : super(key: key);

  @override
  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends BaseViewModel> extends State<BaseWidget<T>>
    with ResponsiveWidget {
  T? viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;
    if (widget.onViewModelReady != null) {
      widget.onViewModelReady!(viewModel);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => viewModel!..setContext(context),
      child: Consumer<T>(
        builder: widget.builder,
        child: buildUi(defaultWidget: widget.child, context: context),
      ),
    );
  }

  @override
  Widget buildDesktop(BuildContext context) {
    return widget.childDesktop ?? widget.child ?? const SizedBox();
  }

  @override
  Widget buildMobile(BuildContext context) {
    return widget.childMobile ?? widget.child ?? const SizedBox();
  }

  @override
  Widget buildTablet(BuildContext context) {
    return widget.childDesktop ?? widget.child ?? const SizedBox();
  }
}

abstract class ResponsiveWidget {
  Widget buildDesktop(BuildContext context);

  Widget buildTablet(BuildContext context);

  Widget buildMobile(BuildContext context);

  Widget buildUi({required BuildContext context, Widget? defaultWidget}) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      if (sizeInfo.deviceScreenType == DeviceScreenType.desktop) {
        return buildDesktop(context);
      } else if (sizeInfo.deviceScreenType == DeviceScreenType.tablet) {
        return buildTablet(context);
      } else if (sizeInfo.deviceScreenType == DeviceScreenType.mobile) {
        return buildMobile(context);
      }
      return defaultWidget ?? const SizedBox();
    });
  }
}
