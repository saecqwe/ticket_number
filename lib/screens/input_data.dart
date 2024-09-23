import 'dart:async';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputDataWidget extends StatefulWidget {
  const InputDataWidget({super.key});

  @override
  State<InputDataWidget> createState() => _InputDataWidgetState();
}

enum Mode { enter, anim, show }

class _InputDataWidgetState extends State<InputDataWidget> {
  String? _code;
  late TextEditingController _codeController;
  Mode _mode = Mode.enter;
  Timer? _timer;

  @override
  void initState() {
    _codeController = TextEditingController(text: _code);
    _setPortraitMode();

    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _modeDependentResult() {
    switch (_mode) {
      case Mode.enter:
        return const SizedBox();
      case Mode.anim:
        return const CircularProgressIndicator();
      case Mode.show:
        return SizedBox(
          height: 120,
          child: BarcodeWidget(
            barcode: Barcode.code128(),
            data: _code!,
          ),
        );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        if (_code?.length == 13) {
          _mode = Mode.show;
        } else {
          _mode = Mode.enter;
        }
      });
    });
  }

  void _setPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _setPortraitOrLandscaptMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Center(child: Text('Ticket Number')),
        ),
        body: Padding(padding: const EdgeInsets.all(25.0), child: MediaQuery.of(context).orientation == Orientation.landscape && (_mode == Mode.show || _mode == Mode.anim) ? _buildLandscapeLayout() : _buildPortraitLayout()));
  }

  Widget _buildPortraitLayout() {
    return Column(children: [
      Expanded(child: Center(child: _modeDependentResult())),
      SizedBox(
        height: 100,
        child: TextField(
          controller: _codeController,
          decoration: const InputDecoration(
            labelText: 'Code',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          maxLength: 13,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 35.0,
            color: Colors.black,
          ),
          onChanged: (value) {
            setState(() {
              _code = value;
              if (value.length == 13) {
                _mode = Mode.anim;
                FocusScope.of(context).unfocus();
                _startTimer();
                _setPortraitOrLandscaptMode();
              } else {
                _setPortraitMode();
                _mode = Mode.enter;
              }
            });
          },
        ),
      ),
      const SizedBox(
        height: 100,
      )
    ]);
  }

  Widget _buildLandscapeLayout() {
    return Column(children: [Expanded(child: Center(child: _modeDependentResult()))]);
  }
}
