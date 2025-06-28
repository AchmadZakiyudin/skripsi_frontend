import 'package:http/http.dart' as http;

void main() async {
  final response = await http.post(
    Uri.parse('http://10.219.14.221:8000/api/pembayaran'),
    body: {
      // Tambahkan data yang ingin dikirim di sini, contoh:
      // 'key1': 'value1',
      // 'key2': 'value2',
      'nama': 'faris',
      "lokasi": 'Bandung',
      "tujuan": 'Jakarta',
      "telepon": '08123456789',
      "tanggal": '2023-10-01',
      "nama_bus": 'Bus A',
      "harga": '100000',
    },
  );
  print('Status code: ${response.statusCode}');
  print('Body: ${response.body}');
}
