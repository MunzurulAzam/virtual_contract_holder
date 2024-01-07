import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vertualcardview/models/contact_model.dart';
import 'package:vertualcardview/pages/form_page.dart';
import 'package:vertualcardview/utils/constant.dart';

class ScanPage extends StatefulWidget {
  //************** for routing page
  static const String routeName = '/scanPage';

  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isScanOver = false;
  List<String> lines = [];
  String name = '', mobile = '', email = '', address = '', company = '', designation = '', website = '', image = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Page'),
        actions: [
          TextButton(onPressed: image.isEmpty ? null :  _createContractButtonFromScannedValues, child: const Text('Next'))
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text('Capture'),
              ),
              TextButton.icon(
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo_album),
                label: const Text('Gallery'),
              ),
            ],
          ),
          if (isScanOver)
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    DropTargetItem(property: ContractProperties.name, onDrop: _getPropertyValue),
                    DropTargetItem(property: ContractProperties.designation, onDrop: _getPropertyValue),
                    DropTargetItem(property: ContractProperties.company, onDrop: _getPropertyValue),
                    DropTargetItem(property: ContractProperties.address, onDrop: _getPropertyValue),
                    DropTargetItem(property: ContractProperties.email, onDrop: _getPropertyValue),
                    DropTargetItem(property: ContractProperties.mobile, onDrop: _getPropertyValue),
                    DropTargetItem(property: ContractProperties.website, onDrop: _getPropertyValue),
                  ],
                ),
              ),
            ),
          if (isScanOver)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(dragInstruction),
            ),
          Wrap(
            spacing: 3.0,
            children: lines
                .map((line) => LineItem(
                      line: line,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    final xFile = await ImagePicker().pickImage(source: source);
    if (xFile != null) {
      image = xFile.path;
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(InputImage.fromFile(
        File(image),
      ));
      final temList = <String>[];

      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          temList.add(line.text);
        }
      }
      setState(() {
        lines = temList;
        isScanOver = true;
      });
      print('..........................................................................$lines');
    }
  }

  _getPropertyValue(String property, String value) {
    switch (property) {
      case ContractProperties.name:
        name = value;
        break;
      case ContractProperties.designation:
        designation = value;
        break;
      case ContractProperties.company:
        company = value;
        break;
      case ContractProperties.address:
        address = value;
        break;
      case ContractProperties.email:
        email = value;
        break;
      case ContractProperties.mobile:
        mobile = value;
        break;
      case ContractProperties.website:
        website = value;
        break;
    }
  }

  void _createContractButtonFromScannedValues() {
    final contract = ContactModel(
      name: name,
      mobile: mobile,
      email: email,
      address: address,
      company: company,
      designation: designation,
      website: website,
      image: image,
    );
    Navigator.pushNamed(context, FromPage.routeName, arguments: contract);
  }
}

class DropTargetItem extends StatefulWidget {
  final String property;
  final Function(String, String) onDrop;

  const DropTargetItem({super.key, required this.property, required this.onDrop});

  @override
  State<DropTargetItem> createState() => _DropTargetItemState();
}

class _DropTargetItemState extends State<DropTargetItem> {
  String dragItem = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(widget.property)),
        Expanded(
          flex: 2,
          child: DragTarget<String>(
            builder: (context, candidateData, rejectedData) => Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(border: candidateData.isNotEmpty ? Border.all(color: Colors.red, width: 2) : null),
              child: Row(
                children: [
                  Expanded(child: Text(dragItem.isEmpty ? 'Drop Here' : dragItem)),
                  if (dragItem.isNotEmpty)
                    InkWell(
                      onTap: () {
                        setState(() {
                          dragItem = '';
                        });
                      },
                      child: Icon(
                        Icons.clear,
                        size: 15,
                      ),
                    )
                ],
              ),
            ),
            onAccept: (data) {
              setState(() {
                if (dragItem.isEmpty) {
                  dragItem = data;
                } else {
                  dragItem += ' $data';
                }
              });
              widget.onDrop(widget.property, dragItem);
            },
          ),
        )
      ],
    );
  }
}

class LineItem extends StatelessWidget {
  final String line;

  const LineItem({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    final GlobalKey _globalKey = GlobalKey();
    return LongPressDraggable(
      data: line,
      dragAnchorStrategy: childDragAnchorStrategy,
      feedback: Container(
        key: _globalKey,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.black45),
        child: Text(
          line,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
      ),
      child: Chip(label: Text(line)),
    );
  }
}
