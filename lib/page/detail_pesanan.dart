import 'package:booking_bus/page/pesanan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booking_bus/model/harga.dart';
import 'package:booking_bus/model/bus.dart';

class DetailPesananPage extends StatefulWidget {
  const DetailPesananPage({super.key});

  @override
  State<DetailPesananPage> createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  List<dynamic> dataPesanan = [];
  String selectedTujuan = '';
  String selectedHarga = '0';
  String uid = '';

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      uid = currentUser.uid;
      getPesanan();
    } else {
      print('User belum login');
    }
  }

  Future<void> getPesanan() async {
    final url = Uri.parse('http://192.168.1.7:8000/api/pesanan?uid=$uid');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          dataPesanan = json.decode(response.body);
        });
      } else {
        print('Gagal memuat data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deletePesanan(int id) async {
    final url = Uri.parse('http://192.168.1.7:8000/api/pesanan/$id');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pesanan berhasil dihapus")),
      );
      getPesanan();
    } else {
      print('Gagal hapus: ${response.body}');
    }
  }

  Future<void> updatePesanan(int id, Map<String, String> data) async {
    final url = Uri.parse('http://192.168.1.7:8000/api/pesanan/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    print('RESP STATUS: ${response.statusCode}');
    print('RESP BODY: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pesanan berhasil diupdate")),
      );
      getPesanan();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update: ${response.body}')),
      );
    }
  }

  void showEditDialog(Map<String, dynamic> item) {
    final TextEditingController tanggalController =
        TextEditingController(text: item['tanggal']);
    selectedTujuan = item['tujuan'];
    selectedHarga = item['harga'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          void updateHarga(String tujuan) {
            final hargaData = listharga.firstWhere(
              (h) => h.lokasi == tujuan,
              orElse: () => Harga(harga: '0'),
            );
            selectedHarga = hargaData.harga ?? '0';
          }

          return AlertDialog(
            title: const Text("Edit Pesanan"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedTujuan,
                  decoration: const InputDecoration(labelText: "Tujuan"),
                  items: listharga
                      .map((harga) => DropdownMenuItem(
                            value: harga.lokasi,
                            child: Text(harga.lokasi ?? ''),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setStateDialog(() {
                      selectedTujuan = value!;
                      updateHarga(selectedTujuan);
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text("Harga: Rp $selectedHarga"),
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
                      setStateDialog(() {
                        tanggalController.text = formattedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedTujuan.isEmpty ||
                      tanggalController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mohon lengkapi data')),
                    );
                    return;
                  }

                  updatePesanan(item['id'], {
                    'tujuan': selectedTujuan,
                    'harga': selectedHarga,
                    'tanggal': tanggalController.text,
                  });

                  Navigator.pop(context);
                },
                child: const Text("Simpan"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesanan Saya"),
        backgroundColor: const Color(0xFF60C0F0),
      ),
      body: dataPesanan.isEmpty
          ? const Center(child: Text("Belum ada pesanan"))
          : ListView.builder(
              itemCount: dataPesanan.length,
              itemBuilder: (context, index) {
                final item = dataPesanan[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.directions_bus),
                    title: Text(item['nama_bus'] ?? '-'),
                    subtitle: Text(
                      '${item['nama']} - ${item['tujuan']}\nTanggal: ${item['tanggal']}\nHarga: Rp ${item['harga']}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showEditDialog(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Konfirmasi"),
                                content: const Text(
                                    "Yakin ingin menghapus pesanan?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text("Batal"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      deletePesanan(item['id']);
                                    },
                                    child: const Text("Hapus"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PesananPage(
                            bus: Bus(title: item['nama_bus']),
                            nama: item['nama'],
                            lokasi: item['lokasi'],
                            tujuan: item['tujuan'],
                            telepon: item['telepon'],
                            tanggal: item['tanggal'],
                            harga: item['harga'],
                            idPesanan: item['id'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
