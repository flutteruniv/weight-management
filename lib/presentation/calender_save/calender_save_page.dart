import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_management/presentation/carrender_save/carender_save_carender.dart';
import 'package:weight_management/presentation/carrender_save/carender_save_model.dart';

class CarrenderSavePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CrenderSaveModel>(
      create: (_) => CrenderSaveModel()..init(),
      child: Consumer<CrenderSaveModel>(
        builder: (context, model, child) {
          if (model.googleCalendar != null) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Container(
                    child: CalendarWidget(model: model),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
