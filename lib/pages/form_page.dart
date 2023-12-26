import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertualcardview/models/contact_model.dart';
import 'package:vertualcardview/providers/contract_provider.dart';

class FromPage extends StatefulWidget {
  static const String routeName = '/fromPage';

  const FromPage({super.key});

  @override
  State<FromPage> createState() => _FromPageState();
}

class _FromPageState extends State<FromPage> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final designationController = TextEditingController();
  final companyController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Contract'),
        actions: [
          IconButton(
            onPressed: _saveContract,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Form(
        key: formKey,
          child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Contract Name',
                filled: true,
                prefixIcon: const Icon(Icons.person),
              ),
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                if (value.length > 30) {
                  return 'Name should be more than 30 chars long';
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: mobileController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                filled: true,
                prefixIcon: const Icon(Icons.phone),
              ),
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                prefixIcon: const Icon(Icons.email),
              ),
              onChanged: (value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              controller: companyController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                filled: true,
                prefixIcon: const Icon(Icons.label),
              ),
              onChanged: (value) {},

            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              controller: designationController,
              decoration: InputDecoration(
                labelText: 'Designation',
                filled: true,
                prefixIcon: const Icon(Icons.label),
              ),
              onChanged: (value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.streetAddress,
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Street Adress',
                filled: true,
                prefixIcon: const Icon(Icons.home_work_outlined),
              ),
              onChanged: (value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.url,
              controller: websiteController,
              decoration: InputDecoration(
                labelText: 'Website',
                filled: true,
                prefixIcon: const Icon(Icons.web_outlined),
              ),
              onChanged: (value) {},
            ),
          )





        ],
      )),
    );
  }

  void _saveContract() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      final contract = ContactModel(
        name: nameController.text,
        mobile: mobileController.text,
        email: emailController.text,
        company: companyController.text,
        designation: designationController.text,
        address: addressController.text,
        website: websiteController.text,
      );
      Provider.of<ContractProvider>(context, listen: false)
      .insertContract(contract)
      .then((rowId) {
        if(rowId>0){
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    companyController.dispose();
    designationController.dispose();
    emailController.dispose();
    websiteController.dispose();
    mobileController.dispose();
    super.dispose();
  }
}
