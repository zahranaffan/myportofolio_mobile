import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();

  String _company = '';
  String _position = '';
  String _description = '';
  DateTime? _startDate;

  @override
  void dispose() {
    _startDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _selectStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _startDate = pickedDate;
      _startDateController.text = _formatDate(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Experience Form'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            16.0,
            16.0,
            16.0,
            16.0 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Nama Perusahaan/Institusi',
                  hintText: 'Contoh: PT Teknologi Indonesia',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _company = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama perusahaan/institusi tidak boleh kosong.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Posisi/Jabatan',
                  hintText: 'Contoh: Mobile Developer Intern',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _position = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Posisi/jabatan tidak boleh kosong.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                onTap: _selectStartDate,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Mulai',
                  hintText: 'Pilih tanggal mulai pengalaman',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (_startDate == null) {
                    return 'Tanggal mulai wajib dipilih.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Pengalaman',
                  hintText: 'Jelaskan tanggung jawab atau pencapaianmu.',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi pengalaman tidak boleh kosong.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Experience berhasil disimpan!'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Perusahaan/Institusi: $_company'),
                                Text('Posisi/Jabatan: $_position'),
                                Text(
                                  'Tanggal Mulai: ${_formatDate(_startDate!)}',
                                ),
                                Text('Deskripsi: $_description'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _formKey.currentState!.reset();
                                  setState(() {
                                    _company = '';
                                    _position = '';
                                    _startDate = null;
                                    _startDateController.clear();
                                    _description = '';
                                  });
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
