import 'package:booking_bus/model/bus.dart';
import 'package:booking_bus/model/harga.dart';
import 'package:booking_bus/page/pesanan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_pesanan.dart';

class BookingPage extends StatefulWidget {
  final Bus bus;
  const BookingPage({super.key, required this.bus});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController busController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  String? selectedTujuan;
  String selectedHarga = '0';

  get bus => widget.bus;

  @override
  void initState() {
    super.initState();
    busController.text = widget.bus.title!;
  }

  void updateHarga(String tujuan) {
    final hargaData = listharga.firstWhere(
      (h) => h.lokasi == tujuan,
      orElse: () => Harga(harga: '0'),
    );
    setState(() {
      selectedHarga = hargaData.harga ?? '0';
    });
  }

  Future<void> simpanPesanan({
    required String nama,
    required String lokasi,
    required String tujuan,
    required String telepon,
    required String tanggal,
    required String namaBus,
    required String harga,
  }) async {
    final url = Uri.parse('http://192.168.1.7:8000/api/pesanan');
    // final url = Uri.parse('http://127.0.0.1:8000/api/pesanan');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'uid': FirebaseAuth.instance.currentUser?.uid ?? '',
        'nama': namaController.text,
        'lokasi': lokasiController.text,
        'tujuan': selectedTujuan ?? '',
        'telepon': teleponController.text,
        'tanggal': tanggalController.text,
        'nama_bus': widget.bus.title ?? '',
        'harga': selectedHarga,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];
      final idPesanan = data['id'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PesananPage(
            bus: widget.bus,
            nama: namaController.text,
            lokasi: lokasiController.text,
            tujuan: selectedTujuan ?? '',
            telepon: teleponController.text,
            tanggal: tanggalController.text,
            harga: selectedHarga,
            idPesanan: idPesanan,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal simpan pesanan: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Pilih Tujuan"),
          backgroundColor: const Color(0xFF60C0F0)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Find a route.",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(
                      labelText: "Nama Lengkap",
                      prefixIcon: Icon(Icons.person)),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Nama wajib diisi'
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: lokasiController,
                  decoration: const InputDecoration(
                      labelText: "Lokasi Penjemputan",
                      prefixIcon: Icon(Icons.place)),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Lokasi wajib diisi'
                      : null,
                ),
                const SizedBox(height: 10),

                /// Dropdown untuk tujuan
                DropdownButtonFormField<String>(
                  value: selectedTujuan,
                  decoration: const InputDecoration(
                      labelText: "Tujuan Perjalanan",
                      prefixIcon: Icon(Icons.place)),
                  items: listharga
                      .map((harga) => DropdownMenuItem(
                            value: harga.lokasi,
                            child: Text(harga.lokasi ?? ''),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTujuan = value;
                      updateHarga(value!);
                    });
                  },
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Pilih tujuan' : null,
                ),
                const SizedBox(height: 5),
                Text("Harga: Rp $selectedHarga",
                    style: const TextStyle(fontWeight: FontWeight.bold)),

                const SizedBox(height: 10),
                TextFormField(
                  controller: teleponController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      labelText: "Nomor Telepon",
                      prefixIcon: Icon(Icons.phone)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Telepon wajib diisi';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Hanya angka yang diperbolehkan';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: tanggalController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Tanggal",
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      setState(() {
                        tanggalController.text = formattedDate;
                      });
                    }
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Tanggal wajib diisi'
                      : null,
                ),
                const SizedBox(height: 10),

                // Nama bus (readonly)
                TextFormField(
                  controller: busController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Bus yang Dipilih",
                    prefixIcon: Icon(Icons.directions_bus),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        // Simpan ke Laravel
                        await simpanPesanan(
                          nama: namaController.text,
                          lokasi: lokasiController.text,
                          tujuan: selectedTujuan ?? '',
                          telepon: teleponController.text,
                          tanggal: tanggalController.text,
                          namaBus: widget.bus.title ?? '',
                          harga: selectedHarga,
                        );

                        // Tampilkan notifikasi sukses
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pesanan berhasil disimpan!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Langsung ke halaman detail pesanan
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailPesananPage(),
                          ),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        // Tampilkan notifikasi error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal menyimpan pesanan: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text("Pesanan"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
