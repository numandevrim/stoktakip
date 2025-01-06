import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stok_takip/database_helper.dart';
import 'product_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Listesi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Veri bulunamadı.'));
          }

          final products = snapshot.data!.docs;

          return ListView(
            children: products.map((product) {
              return Dismissible(
                key: Key(product.id),
                onDismissed: (direction) async {
                  
                  await DatabaseHelper.insertProduct({
                    'urunid': product.id,
                    'urunad': product['urunad'],
                    'alisfiyati': product['alisfiyati'],
                    'satisfiyati': product['satisfiyati'],
                    'stok': product['stok'],
                  });

                  
                  setState(() {
                    products.insert(products.indexOf(product), product);
                  });
                },
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text(product['urunad']),
                  subtitle: Text(
                      'Alış Fiyatı: ${product['alisfiyati']}, Satış Fiyatı: ${product['satisfiyati']}, Stok: ${product['stok']}'),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductListPage()),
          );
        },
        child: Icon(Icons.list),
      ),
    );
  }
}
