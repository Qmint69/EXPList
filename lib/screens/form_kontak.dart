import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../model/kontak.dart';

class FormKontak extends StatefulWidget {
  final Kontak? kontak;

  const FormKontak({super.key, this.kontak});

  @override
  _FormKontakState createState() => _FormKontakState();
}

class _FormKontakState extends State<FormKontak> {
  DbHelper db = DbHelper();

  TextEditingController? name;
  TextEditingController? mobileNo;
  TextEditingController? email;
  TextEditingController? company;

  @override
  void initState() {
    name = TextEditingController(text: widget.kontak?.name ?? '');
    mobileNo = TextEditingController(text: widget.kontak?.mobileNo ?? '');
    email = TextEditingController(text: widget.kontak?.email ?? '');
    company = TextEditingController(text: widget.kontak?.company ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Form')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          buildTextField(name!, 'Name'),
          buildTextField(mobileNo!, 'Phone Number'),
          buildTextField(email!, 'Email'),
          buildTextField(company!, 'Company'),
          const SizedBox(height: 20),
          SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: upsertKontak,
              child: Text(
                widget.kontak == null ? 'Add' : 'Update',
                style: const TextStyle(color: Colors.white, fontSize: 25.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Future<void> upsertKontak() async {
    final kontakData = Kontak(
      id: widget.kontak?.id,
      name: name!.text,
      mobileNo: mobileNo!.text,
      email: email!.text,
      company: company!.text,
    );

    if (widget.kontak != null) {
      await db.updateKontak(kontakData);
      Navigator.pop(context, 'update');
    } else {
      await db.insertKontak(kontakData);
      Navigator.pop(context, 'save');
    }
  }
}
