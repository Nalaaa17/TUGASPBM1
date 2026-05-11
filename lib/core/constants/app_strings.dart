class AppStrings {
  AppStrings._();

  static const String appName = 'Katalog Produk';
  static const String appSubtitle = 'Praktikum Mobile Programming';
  static const String appOwner = 'Maulana Syahbana';
  static const String appNim = '232410103076';

  static const String loginWelcome = 'Pemograman Berbasis Mobile';
  static const String loginSubtitle =
      'Masuk menggunakan NIM sebagai username dan password';
  static const String labelNim = 'Username (NIM)';
  static const String hintNim = 'Contoh: 232410103076';
  static const String labelPassword = 'Password (NIM)';
  static const String hintPassword = 'Masukkan NIM kamu sebagai password';
  static const String btnLogin = 'Masuk';
  static const String loginFailed =
      'Login gagal. Periksa NIM kamu dan coba lagi.';
  static const String loginSuccess = 'Login berhasil!';
  static const String loginLoading = 'Sedang masuk...';

  static const String catalogTitle = 'Katalog Produk Saya';
  static const String btnAdd = 'Tambah Produk';
  static const String btnRefresh = 'Refresh';
  static const String emptyTitle = 'Belum Ada Produk';
  static const String emptySubtitle =
      'Tekan tombol + untuk menambah draft produk pertamamu';
  static const String deleteConfirmTitle = 'Hapus Produk?';
  static const String deleteConfirmMessage =
      'Produk akan dihapus dari tampilan. Data tetap tersimpan di server untuk pengecekan asisten.';
  static const String deleteSuccess = 'Produk berhasil dihapus';
  static const String btnDelete = 'Hapus';
  static const String btnCancel = 'Batal';

  static const String addProductTitle = 'Tambah Draft Produk';
  static const String labelProductName = 'Nama Produk';
  static const String hintProductName = 'Contoh: Kaos Polos Premium';
  static const String labelPrice = 'Harga (Rp)';
  static const String hintPrice = 'Contoh: 75000';
  static const String labelDescription = 'Deskripsi';
  static const String hintDescription =
      'Deskripsikan produk kamu secara singkat...';
  static const String btnSave = 'Simpan Draft';
  static const String warningNoEdit =
      '⚠️  Data tidak dapat diubah setelah disimpan. Pastikan semua data sudah benar sebelum menekan Simpan.';
  static const String addSuccess = 'Draft produk berhasil disimpan!';
  static const String addFailed = 'Gagal menyimpan produk. Coba lagi.';

  static const String submitTitle = 'Submit Tugas';
  static const String submitInfo =
      'ℹ️  Data yang dikirim akan dicatat dengan timestamp saat ini. Pastikan URL GitHub repository kamu sudah benar.';
  static const String labelGithubUrl = 'URL GitHub Repository';
  static const String hintGithubUrl = 'https://github.com/username/repo';
  static const String btnSubmit = 'Submit Tugas';
  static const String submitConfirmTitle = 'Konfirmasi Submit';
  static const String submitConfirmMessage =
      'Apakah kamu yakin ingin mengumpulkan tugas? Pastikan semua data sudah benar.';
  static const String submitSuccess = '🎉 Tugas berhasil dikumpulkan!';
  static const String submitSuccessDetail =
      'Data kamu sudah tercatat di sistem asisten praktikum.';
  static const String submitFailed = 'Gagal mengumpulkan tugas. Coba lagi.';

  static const String logoutConfirmTitle = 'Keluar?';
  static const String logoutConfirmMessage =
      'Apakah kamu yakin ingin keluar dari aplikasi?';
  static const String btnLogout = 'Keluar';
  static const String logoutSuccess = 'Berhasil keluar';

  static const String errorNetwork =
      'Tidak dapat terhubung ke server. Periksa koneksi internet kamu.';
  static const String errorUnauthorized = 'Sesi habis. Silakan login kembali.';
  static const String errorServer =
      'Terjadi kesalahan pada server. Coba lagi nanti.';
  static const String errorUnknown = 'Terjadi kesalahan. Coba lagi.';

  static const String validationRequired = 'Field ini tidak boleh kosong';
  static const String validationNim =
      'NIM harus berupa angka (contoh: 232410103076)';
  static const String validationPrice = 'Harga harus berupa angka lebih dari 0';
  static const String validationGithub =
      'URL harus diawali https://github.com/';
  static const String validationSensitive =
      '⚠️ Input mengandung kata yang tidak diperbolehkan. Hindari konten politik, SARA, atau tidak pantas.';

  static const List<String> sensitiveKeywords = [
    'komunis',
    'pki',
    'separatis',
    'makar',
    'kudeta',
    'kafir',
    'anjing',
    'babi',
    'monyet',
    'cina',
    'pribumi',
    'yahudi',
    'kristen',
    'muslim',
    'hindu',
    'buddha',
    'bangsat',
    'bajingan',
    'sial',
    'kontol',
    'memek',
    'ngentot',
    'brengsek',
    'tolol',
    'idiot',
    'bodoh',
    'bunuh',
    'mati',
    'hancur',
    'bakar',
    'serang',
    'porno',
    'bokep',
    'sex',
    'nude',
    'bugil',
    'telanjang',
  ];
}
