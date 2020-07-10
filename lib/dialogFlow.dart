import "package:flutter/material.dart";
import 'package:flutter_dialogflow/dialogflow_v2.dart';

import 'chatBotUI.dart';

class CharlieTheChatBot extends StatefulWidget {
  CharlieTheChatBot({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CharlieTheChatBotState createState() => new _CharlieTheChatBotState();
}

class _CharlieTheChatBotState extends State<CharlieTheChatBot> {
  final List<FactsMessage> _messages = <FactsMessage>[];
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Charlie The ChatBot"),
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true, //To keep the latest messages at the bottom
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
        Divider(height: 1.0),
        Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _queryInputWidget(context),
        ),
      ]),
    );
  }  

  Widget _queryInputWidget(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _submitQuery,
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  color: Colors.green,
                  onPressed: () => _submitQuery(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

void _submitQuery(String text) {
  _textController.clear();
  FactsMessage message = new FactsMessage(
    text: text,
    name: "Shreyas",
    type: true,
  );

  setState(() {
    _messages.insert(0, message);
  });
  _dialogFlowResponse(text);
}

void _dialogFlowResponse(query) async {
  _textController.clear();
  AuthGoogle authGoogle =
  await AuthGoogle(fileJson: "assets/project-peace-3-egvsxd-df6354a2558e.json").build();
  Dialogflow dialogFlow =
  Dialogflow(authGoogle: authGoogle, language: Language.english);
  AIResponse response = await dialogFlow.detectIntent(query);
  FactsMessage message = FactsMessage(
    text: response.getMessage() ??
         CardDialogflow(response.getListMessage()[0]).title,
    name: "Charlie",
    type: false,
  );
  setState(() {
    _messages.insert(0, message);
  });
}
}  