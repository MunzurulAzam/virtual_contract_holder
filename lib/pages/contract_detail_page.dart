import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vertualcardview/providers/contract_provider.dart';
import 'package:vertualcardview/utils/show_msg.dart';

class ContractDetailPage extends StatefulWidget {
  static const String routeName = 'contractDetailPage';

  const ContractDetailPage({super.key});

  @override
  State<ContractDetailPage> createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  int id = 0;

  @override
  void didChangeDependencies() {
    id = ModalRoute.of(context)?.settings.arguments as int;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Consumer<ContractProvider>(
        builder: (context, provider, _) => FutureBuilder(
          future: provider.getAllContractById(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final contract = snapshot.data!;
              return ListView(
                children: [
                  contract.image.isNotEmpty ? Image.file(
                    File(contract.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ) : Image.asset(
                    contract.image,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    title: Text(contract.name),
                  ),
                  ListTile(
                    title: Text(contract.mobile),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _smsContract(contract.mobile);
                          },
                          icon: const Icon(Icons.message),
                        ),
                        IconButton(
                          onPressed: () {
                            _callContract(contract.mobile);
                          },
                          icon: const Icon(Icons.call),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contract.email.isEmpty ? 'Not Found' : contract.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            contract.email.isNotEmpty ? _emailContract(contract.email) : null;
                          },
                          icon: const Icon(Icons.email),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contract.address.isEmpty ? 'Not Found' : contract.address),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            contract.address.isNotEmpty ? _addressContract(contract.address) : null;
                          },
                          icon: const Icon(Icons.location_on_outlined),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contract.website.isEmpty ? 'Not found' : contract.website),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            contract.website.isNotEmpty ? _webContract(contract.website) : null;
                          },
                          icon: const Icon(Icons.web_sharp),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: Text('Fail to fetch data'),
              );
            }
          },
        ),
      ),
    );
  }
//................................................................... for send sms
  void _smsContract(String mobile) async {
    final url = 'sms:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      ShowMsg(context, 'Can not perform this task');
    }
  }
//..................................................................... for send call
  void _callContract(String mobile) async {
    final url = 'tel:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      ShowMsg(context, 'Can not perform this task');
    }
  }
//...................................................................... for send location
  void _addressContract(String address) async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'geo:0,0?q=$address';
    } else {
      url = 'http://maps.apple.com/?q=$address';
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      ShowMsg(context, 'Cannot perform this task');
    }
  }
//...................................................................... for send website in the browser
  void _webContract(String website) async {
    final url = 'https://$website';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      ShowMsg(context, 'Could not perform this operation');
    }
  }
//....................................................................... for send email
  void _emailContract(String email) async {
    final url = 'mailto:$email';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      ShowMsg(context, 'Cannot perform this task');
    }
  }
}
