// new_dog_form.dart

import 'package:flutter/material.dart';

import 'dog_model.dart';

class AddDogFormPage extends StatefulWidget {
  @override
  _AddDogFormPageState createState() => _AddDogFormPageState();
}

class _AddDogFormPageState extends State<AddDogFormPage> {
  // One Text Editing Controler for each form input:
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    // new page needs scaffolding!
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Dog'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        color: Colors.black54,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0, 
              horizontal: 32.0
          ),
          child: Column(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  // tell your textfield which controller it owns
                  controller: nameController,
                  // Every single time the text changes in a
                  // TextField, this onChange callback is called
                  // and it passes in the value.
                  //
                  // set the text of your controller to
                  // to the next value.
                  //onChanged: (v) => nameController.text = v,
                  decoration: InputDecoration(
                    labelText: 'Name the Pup',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: locationController,
                  //onChanged: (v) => locationController.text = v,
                  decoration: InputDecoration(
                    labelText: "Pup's location",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: descriptionController,
                  //onChanged: (v) => descriptionController.text = v,
                  decoration: InputDecoration(
                    labelText: 'All about the pup',
                  ),
                ),
              ),
              // A strange situation.
              // A piece of the app that you ''ll add in the next
              // section *needs* to know its context.
              // and the easiest way to pass a context is to
              // use a builder method. So I've wrapped 
              // this button in a builder a a sort of 'hack'.
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                    builder: (context) {
                      // The basic Material Design Action button.
                      return RaisedButton(
                        // if onpressed is null, the button is disabled
                        // this is my goto temporary callback.
                        onPressed: () => submitPup(context),
                        color: Colors.indigoAccent,
                        child: Text('Submit Pup'),
                      );
                    },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void submitPup(BuildContext context) {
    // First make  sure there is some information in the form.
    // a dog needs a name, but may be location independent,
    // so we'll only abandon the save if there's no name.

    if (nameController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Pups neeed names!'),
        )
      );

    } else {
      // create a new dog with the information from the form.

      var newDog = Dog(nameController.text, locationController.text, descriptionController.text);
      // pop the page off the route stack and pass the new
      // dog back to wherever this page was created.
      Navigator.of(context).pop(newDog);
    }
  }
}
