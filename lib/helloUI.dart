import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp8/contract_linking.dart';

class HelloUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Getting the value and object or contract_linking
    var contractLink = Provider.of<ContractLinking>(context);

    TextEditingController yourNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Hello World !"), centerTitle: true),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: contractLink.isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Hello ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 52,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                contractLink.deployedName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 52,
                                  color: Colors.tealAccent,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 29),
                          child: TextFormField(
                            controller: yourNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Your Name",
                              hintText: "What is your name ?",
                              icon: Icon(Icons.drive_file_rename_outline),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              contractLink.setName(yourNameController.text);

                              yourNameController.clear();
                            },
                            child: Text(
                              'Set Name',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
