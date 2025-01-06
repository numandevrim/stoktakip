import 'package:flutter/material.dart';
import 'package:stok_takip/database_helper.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favori Ürünler'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Hiç Ürün Yok.'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(products[index]['urunid'].toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  
                  await DatabaseHelper.deleteProduct(products[index]['urunad']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${products[index]['urunad']} silindi')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(products[index]['urunad']),
                  subtitle: Text(
                    'Alış Fiyatı: ${products[index]['alisfiyati']}, Satış Fiyatı: ${products[index]['satisfiyati']}, Stok: ${products[index]['stok']}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
