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
    final url = Uri.parse('http://192.168.1.5:8000/api/pesanan?uid=$uid');
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
    final url = Uri.parse('http://192.168.1.5:8000/api/pesanan/$id');
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
    final url = Uri.parse('http://192.168.1.5:8000/api/pesanan/$id');
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
    final TextEditingController namaController =
        TextEditingController(text: item['nama']);
    final TextEditingController teleponController =
        TextEditingController(text: item['telepon']);
    final TextEditingController tanggalController =
        TextEditingController(text: item['tanggal']);
    String tujuan = item['tujuan'] ?? '';
    String harga = item['harga'] ?? '0';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          void updateHarga(String tujuanBaru) {
            final hargaData = listharga.firstWhere(
              (h) => h.lokasi == tujuanBaru,
              orElse: () => Harga(harga: '0'),
            );
            harga = hargaData.harga ?? '0';
          }

          return AlertDialog(
            title: const Text("Edit Pesanan"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: const InputDecoration(labelText: "Nama"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: teleponController,
                    decoration: const InputDecoration(labelText: "Telepon"),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: tujuan,
                    decoration: const InputDecoration(labelText: "Tujuan"),
                    items: listharga
                        .map((harga) => DropdownMenuItem(
                              value: harga.lokasi,
                              child: Text(harga.lokasi ?? ''),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        tujuan = value!;
                        updateHarga(tujuan);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Text("Harga: Rp $harga"),
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
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (namaController.text.isEmpty ||
                      teleponController.text.isEmpty ||
                      tujuan.isEmpty ||
                      tanggalController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mohon lengkapi data')),
                    );
                    return;
                  }

                  updatePesanan(item['id'], {
                    'nama': namaController.text,
                    'telepon': teleponController.text,
                    'tujuan': tujuan,
                    'harga': harga,
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['nama']} - ${item['tujuan']}',
                        ),
                        Text(
                          'Tanggal: ${item['tanggal']}',
                        ),
                        Text(
                          'Harga: Rp ${item['harga']}',
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text("Status: "),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item['status'] == 'lunas'
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['status'] == 'lunas'
                                      ? 'Lunas'
                                      : 'Belum Dikonfirmasi',
                                  style: TextStyle(
                                    color: item['status'] == 'lunas'
                                        ? Colors.green
                                        : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    isThreeLine: true,
                    // trailing: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     IconButton(
                    //       icon: const Icon(Icons.edit, color: Colors.blue),
                    //       onPressed: () => showEditDialog(item),
                    //     ),
                    //     IconButton(
                    //       icon: const Icon(Icons.delete, color: Colors.red),
                    //       onPressed: () {
                    //         showDialog(
                    //           context: context,
                    //           builder: (ctx) => AlertDialog(
                    //             title: const Text("Konfirmasi"),
                    //             content: const Text(
                    //                 "Yakin ingin menghapus pesanan?"),
                    //             actions: [
                    //               TextButton(
                    //                 onPressed: () => Navigator.pop(ctx),
                    //                 child: const Text("Batal"),
                    //               ),
                    //               ElevatedButton(
                    //                 onPressed: () {
                    //                   Navigator.pop(ctx);
                    //                   deletePesanan(item['id']);
                    //                 },
                    //                 child: const Text("Hapus"),
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ],
                    // ),
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
