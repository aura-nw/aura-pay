import 'package:flutter/material.dart';

class WCConnectionWidget extends StatelessWidget {
  const WCConnectionWidget({
    super.key,
    required this.title,
    required this.info,
  });

  final String title;
  final List<WCConnectionModel> info;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      padding: const EdgeInsets.all(
        8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(title),
          const SizedBox(height: 8),
          ...info.map(
            (e) => WCConnectionWidgetInfo(
              model: e,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Text(text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}

class WCConnectionWidgetInfo extends StatelessWidget {
  const WCConnectionWidgetInfo({
    Key? key,
    required this.model,
  }) : super(key: key);

  final WCConnectionModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      padding: const EdgeInsets.all(
        8,
      ),
      margin: const EdgeInsetsDirectional.only(
        top: 8,
      ),
      child: model.elements != null ? _buildList() : _buildText(),
    );
  }

  Widget _buildList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.title!,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          direction: Axis.horizontal,
          children: model.elements!.map((e) => _buildElement(e)).toList(),
        ),
      ],
    );
  }

  Widget _buildElement(String text) {
    return InkWell(
      onTap: model.elementActions != null ? model.elementActions![text] : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
        // margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(
          8,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildText() {
    return Text(
      model.text!,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      // textAlign: TextAlign.center,
    );
  }
}

class WCConnectionModel {
  final String? title;
  final String? text;
  final List<String>? elements;
  final Map<String, void Function()>? elementActions;

  WCConnectionModel({
    this.title,
    this.text,
    this.elements,
    this.elementActions,
  });

  @override
  String toString() {
    return 'WalletConnectRequestModel(title: $title, text: $text, elements: $elements, elementActions: $elementActions)';
  }
}
