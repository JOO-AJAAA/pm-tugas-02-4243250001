import 'dart:io';

void main() {
  final Map<String, ({String nama, String kategori, int harga})> katalog = {
    'P01': (nama: 'Kopi Sidikalang 250 g', kategori: 'Kopi', harga: 45000),
    'P02': (nama: 'Kopi Gayo 250 g', kategori: 'Kopi', harga: 55000),
    'P03': (nama: 'Teh Kayu Aro 100 g', kategori: 'Teh', harga: 25000),
    'P04': (nama: 'Gula Aren 500 g', kategori: 'Pemanis', harga: 30000),
    'P05': (nama: 'Bolu Meranti', kategori: 'Makanan', harga: 80000),
  };

  print('============================================================');
  print('                        KATALOG TOKO                        ');
  print('============================================================');
  // TODO 1: tampilkan katalog sebagai tabel rapi (kode, nama, harga) dengan padRight/padLeft
  print('${'Kode'.padRight(6)} | ${'Nama Produk'.padRight(25)} | ${'Harga'.padLeft(10)}');
  print('------------------------------------------------------------');
  katalog.forEach((kode, produk) {
    print('${kode.padRight(6)} | ${produk.nama.padRight(25)} | Rp${produk.harga.toString().padLeft(8)}');
  });
  print('============================================================\n');

  stdout.write('Pesanan (contoh: P01x2, P03x1): ');
  final String input = stdin.readLineSync() ?? '';

  // Penampung data proses pembacaan pesanan
  final List<String> itemDitolak = [];
  final Set<String> kategoriDibeli = {};
  final List<({String kode, String nama, int harga, int jumlah})> daftarItemValid = [];

  // TODO 2: pecah input dengan split(',') lalu split('x') untuk tiap item
  final List<String> mentahItems = input.split(',');

  for (var item in mentahItems) {
    final String cleanItem = item.trim();
    if (cleanItem.isEmpty) continue;

    final List<String> parts = cleanItem.split('x');
    if (parts.length != 2) {
      itemDitolak.add(cleanItem);
      continue;
    }

    final String kode = parts[0].trim();
    final String jmlStr = parts[1].trim();
    
    // TODO 3: cari produk dengan katalog[kode]. Hasilnya NULLABLE: tangani tanpa crash
    final int? jumlah = int.tryParse(jmlStr);
    final var produk = katalog[kode];

    if (jumlah == null || jumlah <= 0 || produk == null) {
      itemDitolak.add(cleanItem);
      continue;
    }

    // Jika valid, masukkan ke daftar item valid dan simpan kategorinya
    kategoriDibeli.add(produk.kategori);
    daftarItemValid.add((
      kode: kode,
      nama: produk.nama,
      harga: produk.harga,
      jumlah: jumlah,
    ));
  }

  // TODO 4: hitung subtotal tiap item (map) dan total (fold); beri diskon 10% jika total >= 100000
  final List<int> daftarSubtotal = daftarItemValid.map((item) => item.harga * item.jumlah).toList();
  final int totalSebelumDiskon = daftarSubtotal.fold<int>(0, (sum, subtotal) => sum + subtotal);
  
  final int diskon = totalSebelumDiskon >= 100000 ? (totalSebelumDiskon * 0.1).round() : 0;
  final int totalBayar = totalSebelumDiskon - diskon;

  // TODO 5: cetak struk, Set kategori produk yang dibeli, dan daftar item yang ditolak
  print('\n============================================================');
  print('                       STRUK BELANJA                        ');
  print('============================================================');
  
  if (daftarItemValid.isEmpty) {
    print('Tidak ada pesanan valid yang diproses.');
  } else {
    for (int i = 0; i < daftarItemValid.length; i++) {
      final item = daftarItemValid[i];
      final subtotal = daftarSubtotal[i];
      print('${item.nama.padRight(25)} x ${item.jumlah.toString().padRight(3)} : Rp${subtotal.toString().padLeft(8)}');
    }
    print('------------------------------------------------------------');
    print('${'Total Awal'.padRight(31)} : Rp${totalSebelumDiskon.toString().padLeft(8)}');
    if (diskon > 0) {
      print('${'Diskon 10%'.padRight(31)} : Rp${diskon.toString().padLeft(8)}');
    }
    print('${'Total Bayar'.padRight(31)} : Rp${totalBayar.toString().padLeft(8)}');
    print('------------------------------------------------------------');
    print('Kategori produk yang dibeli: ${kategoriDibeli.join(', ')}');
  }

  // Menampilkan item yang ditolak (jika ada)
  if (itemDitolak.isNotEmpty) {
    print('------------------------------------------------------------');
    print('⚠️ Item ditolak/tidak valid: ${itemDitolak.join(', ')}');
  }
  print('============================================================');
}
