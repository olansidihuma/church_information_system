# Fitur Baca Alkitab Offline - Dokumentasi

## Gambaran Umum

Fitur Baca Alkitab Offline memungkinkan pengguna untuk membaca Alkitab, melacak progress bacaan, mengatur jadwal membaca harian, dan menerima pengingat melalui notifikasi - semuanya tanpa memerlukan koneksi internet.

## Fitur Utama

### 1. Daftar Lengkap Kitab Alkitab
- **66 Kitab** dengan nama Indonesia
- **Perjanjian Lama**: 39 kitab (Kejadian - Maleakhi)
- **Perjanjian Baru**: 27 kitab (Matius - Wahyu)
- Informasi lengkap jumlah pasal dan ayat untuk setiap kitab
- Filter berdasarkan testament (PL/PB/Semua)

### 2. Pelacakan Progress Bacaan
- **Posisi Bacaan Saat Ini**
  - Kitab yang sedang dibaca
  - Pasal dan ayat terakhir
  - Tanggal terakhir membaca

- **Statistik Bacaan**
  - Total ayat yang sudah dibaca
  - Total pasal yang sudah diselesaikan
  - Progress hari ini

- **Penanda Bacaan Harian**
  - Tandai berapa ayat sudah dibaca hari ini
  - Status "Sudah Membaca" atau "Belum Membaca"
  - History bacaan harian

### 3. Jadwal Membaca
- **Buat Jadwal Kustom**
  - Nama jadwal (contoh: "Bacaan Pagi", "Bacaan Malam")
  - Pilih waktu (format HH:mm, contoh: 06:00, 20:00)
  - Pilih hari:
    - Setiap hari
    - Hari tertentu (Sen, Sel, Rab, dst)
  
- **Manajemen Jadwal**
  - Aktifkan/nonaktifkan jadwal
  - Edit jadwal yang ada
  - Hapus jadwal
  - Multiple jadwal (bisa membuat lebih dari satu)

- **Notifikasi Pengingat**
  - Notifikasi otomatis sesuai jadwal
  - Dapat diaktifkan/nonaktifkan per jadwal
  - Muncul pada waktu yang ditentukan

### 4. Antarmuka Pengguna

#### Halaman Utama Alkitab
- Card progress hari ini
- Posisi bacaan saat ini dengan tombol "Lanjut"
- Statistik (ayat dibaca, pasal selesai)
- Quick actions (Baca Alkitab, Lihat Progress)
- Filter testament (Semua/PL/PB)
- Grid daftar kitab dengan ikon

#### Halaman Baca Alkitab
- Header informasi kitab
- Bookmark posisi terakhir
- Grid pemilihan pasal
- Tandai pasal sebagai dibaca
- Tombol untuk menandai progress harian

#### Halaman Progress
- Progress keseluruhan
- Progress hari ini dengan status
- Posisi bacaan saat ini
- Statistik detail dengan ikon visual

#### Halaman Jadwal
- Daftar semua jadwal
- Toggle aktif/nonaktif
- Tombol tambah, edit, hapus
- Informasi waktu dan hari untuk setiap jadwal

## Struktur Kode

### Models (`lib/models/bible_models.dart`)
```dart
- BibleBook: Struktur data kitab Alkitab
- ReadingProgress: Pelacakan progress bacaan
- ReadingSchedule: Konfigurasi jadwal membaca
- DailyReadingRecord: Catatan bacaan harian
```

### Services (`lib/services/bible_service.dart`)
```dart
- getAllBooks(): Dapatkan semua kitab
- getCurrentProgress(): Dapatkan progress saat ini
- saveProgress(): Simpan progress bacaan
- getSchedules(): Dapatkan jadwal membaca
- addSchedule(): Tambah jadwal baru
- updateSchedule(): Update jadwal
- deleteSchedule(): Hapus jadwal
```

### Controller (`lib/controllers/bible_controller.dart`)
```dart
- loadData(): Muat semua data
- updateProgress(): Update progress bacaan
- markVersesRead(): Tandai ayat sebagai dibaca
- addSchedule(): Tambah jadwal
- toggleScheduleActive(): Toggle status jadwal
```

### Screens
```
lib/screens/bible/
├── bible_screen.dart           # Halaman utama
├── bible_reading_screen.dart   # Halaman baca
├── bible_progress_screen.dart  # Halaman progress
├── bible_schedule_screen.dart  # Halaman jadwal
└── bible_binding.dart          # GetX binding
```

## Cara Menggunakan

### 1. Akses Fitur Alkitab
- Dari Dashboard: Tap card "Baca Alkitab" (warna ungu)
- Dari Menu Drawer: Pilih "Baca Alkitab"

### 2. Mulai Membaca
1. Di halaman utama, tap salah satu kitab dari grid
2. Atau tap "Lanjut" untuk melanjutkan dari posisi terakhir
3. Pilih pasal yang ingin dibaca
4. Tap "Tandai Sebagai Dibaca" setelah selesai

### 3. Tandai Progress Harian
1. Tap ikon bookmark di halaman Baca Alkitab
2. Masukkan jumlah ayat yang sudah dibaca
3. Tap "Simpan"
4. Progress akan ter-update di halaman utama

### 4. Buat Jadwal Membaca
1. Dari halaman utama Alkitab, tap ikon schedule (pojok kanan atas)
2. Atau tap tombol FAB (+) di halaman Jadwal
3. Isi form:
   - Nama jadwal (contoh: "Bacaan Pagi")
   - Waktu (contoh: "06:00")
   - Pilih "Setiap Hari" atau pilih hari tertentu
4. Tap "Simpan"
5. Notifikasi akan muncul sesuai jadwal

### 5. Kelola Jadwal
- **Aktif/Nonaktif**: Toggle switch di samping jadwal
- **Hapus**: Tap ikon delete, konfirmasi penghapusan
- **Edit**: Hapus dan buat ulang dengan setting baru

## Penyimpanan Data

Semua data disimpan secara lokal menggunakan **SharedPreferences**:
- Progress bacaan terkini
- Daftar jadwal membaca
- Catatan bacaan harian
- Statistik bacaan

Data tetap ada meskipun aplikasi ditutup dan tidak memerlukan koneksi internet.

## Notifikasi

Sistem notifikasi terintegrasi dengan `NotificationService`:
- Notifikasi dijadwalkan sesuai setting jadwal
- Muncul dengan judul: "Waktu Membaca Alkitab"
- Body: Nama jadwal yang sudah dibuat
- Tap notifikasi untuk membuka aplikasi

## Integrasi dengan Dashboard

Fitur Alkitab terintegrasi penuh dengan dashboard:
- Card "Baca Alkitab" di grid layanan (warna ungu)
- Menu item "Baca Alkitab" di navigation drawer
- Seamless navigation dengan GetX routing

## Data Alkitab

### Kitab Perjanjian Lama (39 kitab)
1. Kejadian (50 pasal)
2. Keluaran (40 pasal)
3. Imamat (27 pasal)
4. Bilangan (36 pasal)
5. Ulangan (34 pasal)
... dan seterusnya

### Kitab Perjanjian Baru (27 kitab)
1. Matius (28 pasal)
2. Markus (16 pasal)
3. Lukas (24 pasal)
4. Yohanes (21 pasal)
5. Kisah Para Rasul (28 pasal)
... dan seterusnya

Setiap kitab memiliki data lengkap jumlah ayat per pasal.

## Pengembangan Selanjutnya (Opsional)

Fitur yang bisa ditambahkan di masa depan:
- Teks lengkap Alkitab (saat ini hanya struktur)
- Bookmark ayat favorit
- Catatan pribadi per ayat
- Rencana bacaan (misalnya: baca Alkitab dalam 1 tahun)
- Pencarian ayat
- Highlight ayat
- Bagikan ayat ke social media
- Sync data ke cloud (opsional)
- Audio Alkitab
- Beberapa versi terjemahan

## Teknologi

- **Framework**: Flutter
- **State Management**: GetX
- **Local Storage**: SharedPreferences
- **Notifikasi**: Flutter Local Notifications
- **Data**: Hardcoded dalam service (offline-first)

## Kesimpulan

Fitur Baca Alkitab Offline memberikan pengalaman membaca Alkitab yang lengkap dengan pelacakan progress, jadwal yang dapat dikustomisasi, dan pengingat otomatis - semuanya tersedia secara offline. Fitur ini dirancang untuk membantu anggota gereja dalam membangun kebiasaan membaca Alkitab secara teratur.
