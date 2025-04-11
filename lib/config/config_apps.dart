
class ConfigApps {
  final String url ='http://10.0.2.2:8000';
  //login backend
  final String login= '/auth/login';
  final String logout= '/auth/logout';
  final String check= '/auth/checkstatus';

  //data buku
    final String listbuku= '/buku';
    final String detilbuku= '/buku/detil';
    final String caribuku= '/buku/cari';
    final String tambahbuku= '/buku/tambah';
    final String hapusbuku= '/buku/hapus/';
    final String editbuku= '/buku/edit/';
}