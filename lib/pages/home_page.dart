import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertualcardview/models/contact_model.dart';
import 'package:vertualcardview/pages/form_page.dart';
import 'package:vertualcardview/pages/scan_pages.dart';
import 'package:vertualcardview/providers/contract_provider.dart';
import 'package:vertualcardview/utils/show_msg.dart';

import 'contract_detail_page.dart';

class Homepage extends StatefulWidget {
  static const String routeName = '/';

  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;
  bool isFirst = true;
  String name = '', mobile = '', email = '', address = '', company = '', designation = '', website = '', image = '';

  @override
  void didChangeDependencies() {
    if (isFirst) {
      Provider.of<ContractProvider>(context, listen: false).getAllContractsData();
    }
    isFirst = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contract'),
          actions: [
            GestureDetector(
                onTap: _goToFromPage,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 38),
                  child: Icon(Icons.add),
                ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, ScanPage.routeName);
          },
          shape: CircleBorder(),
          child: const Icon(Icons.document_scanner_outlined),
        ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.zero,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
              backgroundColor: Colors.blue.shade100,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              currentIndex: selectedIndex,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'All'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
              ]),
        ),
        body: Consumer<ContractProvider>(
          builder: (context, provider, _) {
            if (provider.contractList.isEmpty) {
              return const Center(
                child: Text('Nothing To Show'),
              );
            }
            return ListView.builder(
              itemCount: provider.contractList.length,
              itemBuilder: (context, index) {
                final contract = provider.contractList[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: _showConfirmationDialogue,
                  onDismissed: (direction) async {
                    await provider.deleteContract(contract.id);
                    ShowMsg(context, 'Deleted');
                  },
                  child: ListTile(
                    onTap: () => Navigator.pushNamed(context, ContractDetailPage.routeName, arguments: contract.id),
                    title: Text(contract.name),
                    trailing: IconButton(
                      onPressed: () {
                        provider.updateContractField(contract, tblContactColFavorite);
                      },
                      icon: Icon(
                        contract.favorite ? Icons.favorite : Icons.favorite_border,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ));
  }

  Future<bool?> _showConfirmationDialogue(DismissDirection direction) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Contract'),
              content: const Text('Are you sure to delete this contract'),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('no')),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('yes')),
              ],
            ));
  }

  void _goToFromPage() {
    final contract = ContactModel(
      name: name,
      mobile: mobile,
      email: email,
      address: address,
      company: company,
      designation: designation,
      website: website,
    );
    Navigator.pushNamed(context, FromPage.routeName, arguments: contract);
  }
}
