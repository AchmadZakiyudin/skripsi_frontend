class Harga {
  String? id;
  String? harga;
  String? lokasi;

  Harga({
    this.id,
    this.harga,
    this.lokasi,
  });
}

final listharga = [
  Harga(
    id: 'harga1',
    harga: '7000000',
    lokasi: 'Bali, Indonesia',
  ),
  Harga(
    id: 'harga2',
    harga: '7000000',
    lokasi: 'Jogjakarta, Indonesia',
  ),
  Harga(
    id: 'harga3',
    harga: '4000000',
    lokasi: 'Wali 5', // Contoh lokasi
  ),
  Harga(
    id: 'harga4',
    harga: '5000000',
    lokasi: 'Wali 8',
  ),
  Harga(
    id: 'harga5',
    harga: '7000000',
    lokasi: 'Wali 9',
  ),
  Harga(
    id: 'harga6',
    harga: '4500000',
    lokasi: 'Malang, Indonesia',
  ),
  Harga(
    id: 'harga7',
    harga: '4000000',
    lokasi: 'Surabaya, Indonesia',
  ),
];
