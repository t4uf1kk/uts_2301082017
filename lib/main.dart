import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pembayaran PDAM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentPage(),
    );
  }
}

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String _kodePembayaran = '';
  String _namaPelanggan = '';
  String _jenisPelanggan = 'GOLD';
  int _meterBulanIni = 0;
  int _meterBulanLalu = 0;
  double _totalBayar = 0.0;
  bool _isCalculated = false; // Untuk menandakan apakah sudah dihitung

  void _calculatePayment() {
    setState(() {
      int meterPakai = _meterBulanLalu - _meterBulanIni;
      double biayaPerMeter = 0.0;

      if (_jenisPelanggan == 'GOLD') {
        if (meterPakai <= 10) {
          biayaPerMeter = 5000;
        } else if (meterPakai <= 20) {
          biayaPerMeter = 10000;
        } else {
          biayaPerMeter = 20000;
        }
      } else if (_jenisPelanggan == 'SILVER') {
        if (meterPakai <= 10) {
          biayaPerMeter = 4000;
        } else if (meterPakai <= 20) {
          biayaPerMeter = 8000;
        } else {
          biayaPerMeter = 10000;
        }
      } else if (_jenisPelanggan == 'UMUM') {
        if (meterPakai <= 10) {
          biayaPerMeter = 2000;
        } else if (meterPakai <= 20) {
          biayaPerMeter = 3000;
        } else {
          biayaPerMeter = 5000;
        }
      }

      _totalBayar = meterPakai * biayaPerMeter.toDouble();
      _isCalculated = true; // Tandai bahwa perhitungan telah dilakukan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pembayaran PDAM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Kode Pembayaran'),
                onChanged: (value) {
                  _kodePembayaran = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                onChanged: (value) {
                  _namaPelanggan = value;
                },
              ),
              DropdownButtonFormField<String>(
                value: _jenisPelanggan,
                items: ['GOLD', 'SILVER', 'UMUM']
                    .map((jenis) => DropdownMenuItem(
                          value: jenis,
                          child: Text(jenis),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _jenisPelanggan = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Jenis Pelanggan'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Meter Bulan Ini'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _meterBulanIni = int.tryParse(value) ?? 0;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Meter Bulan Lalu'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _meterBulanLalu = int.tryParse(value) ?? 0;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculatePayment,
                child: Text('Hitung total'),
              ),
              SizedBox(height: 20),
              if (_isCalculated) _buildCustomerData(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data pembayaran:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('Kode Pembayaran: $_kodePembayaran'),
        Text('Nama Pelanggan: $_namaPelanggan'),
        Text('Jenis Pelanggan: $_jenisPelanggan'),
        Text('Meter Bulan Ini: $_meterBulanIni'),
        Text('Meter Bulan Lalu: $_meterBulanLalu'),
        Text('Pemakaian Meter: ${_meterBulanLalu - _meterBulanIni}'),
        Text('Total Bayar: Rp ${_totalBayar.toStringAsFixed(2)}'),
      ],
    );
  }
}
