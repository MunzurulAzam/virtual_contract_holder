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
                  Image.asset(
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
                  ),ListTile(
                    title: Text(contract.address.isEmpty ? 'Not Found' : contract.address ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _addressContract(contract.address);
                          },
                          icon: const Icon(Icons.location_on_outlined),
                        ),
                      ],
                    ),
                  ),ListTile(
                    title: Text(contract.website.isEmpty ? 'Not found' : contract.website),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _webContract(contract.website);
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

  void _smsContract(String mobile) async {
    final url = 'sms:$mobile';
    if(await canLaunchUrlString(url)){
      await launchUrlString(url);
    } else{
      ShowMsg(context, 'Can not perform this task');
    }

  }

  void _callContract(String mobile) async {
    final url = 'tel:$mobile';
    if(await canLaunchUrlString(url)){
    await launchUrlString(url);
    } else{
    ShowMsg(context, 'Can not perform this task');
    }
  }

  void _addressContract(String address) {

  }

  void _webContract(String website) {}
}
