import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:npos/Theme/app_theme.dart';


class ThemekBloc extends Bloc<ThemekEvent, ThemekState> {
  ThemekBloc() : super(ThemekState(themeData: AppThemes.appThemData[AppTheme.lightTheme]));

  @override
  Stream<ThemekState> mapEventToState(ThemekEvent event  ) async* {
    try {
      print("Called");
      if (event is ThemekEvent) {
        print("Called 12 ");
        yield ThemekState(
          themeData: AppThemes.appThemData[event.appTheme],

        );
        print("Called 123 ${event.appTheme}");
      }
    }
    catch( e)
    {
      print(e.toString());
    }
  }
}

@immutable
class ThemekEvent {
  final AppTheme appTheme;
  ThemekEvent({required this.appTheme});
}

@immutable
class ThemekState {
  final ThemeData? themeData;
  ThemekState({required this.themeData});
}

