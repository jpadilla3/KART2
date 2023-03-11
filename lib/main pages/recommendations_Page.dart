import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/info.dart';
import 'package:kart2/main%20pages/List2.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecPageState();
}

class _RecPageState extends State<RecommendationsPage> {
  final List<Map<String, String>> itemss = [
    {
      'image':
          'https://kellogg-h.assetsadobe.com/is/image/content/dam/kelloggs/kna/us/digital-shelf/rice-krispies/00038000200038_C1L1.jpg',
      'title': 'Rice Krispies Cereal -> Kellog Flakes',
      'image2':
          'https://cdn.shopify.com/s/files/1/1614/9751/products/3960dcb287e20ee5798a05f9fac6531d_530x.jpg?v=1571439710'
    },
    {
      'image': 'https://i5.peapod.com/c/63/63OIA.png',
      'title': 'HotPockets Pepperoni -> Lean Pockets',
      'image2':
          'https://ipcdn.freshop.com/resize?url=https://images.freshop.com/00043695083057/fccdce6fad754a9b09492ff84ed3a4d4_large.png&width=512&type=webp&quality=90'
    },
    {
      'image':
          'https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcSM03KIfF8AODqR0AL0MimAm86l0LAelByuQhyF90MpwVekSPDdK3xfSUwyHHoxJnGp6v7FVGfm5wGLAl35G_Zl-SigGuWBPg',
      'title': 'Tyson Chicken Strips -> Tyson Blackend ChickenStrips',
      'image2': 'https://images.heb.com/is/image/HEBGrocery/002730530-1'
    },
    {
      'image': 'https://images.heb.com/is/image/HEBGrocery/000569244',
      'title': 'Hungry Jacks Pancake Mix -> Hungry Jacks Protien edtion',
      'image2':
          'https://ipcdn.freshop.com/resize?url=https://images.freshop.com/00051500929247/c1e27e391ab84c782fc5ffa081e8a4cb_large.png&width=256&type=webp&quality=80'
    },
    {
      'image': 'https://i5.peapod.com/c/3V/3VP33.png',
      'title': 'Stouffers Lasagna -> Lean Cusine Lasagna',
      'image2':
          'https://www.goodnes.com/sites/g/files/jgfbjl321/files/styles/gdn_hero_pdp_product_image/public/gdn_product/field_product_images/leancuisine-jvdlpgbdvi1plrvd4kbb.png.webp?itok=TeLDDhpv'
    },
    {
      'image': 'https://images.heb.com/is/image/HEBGrocery/000105727',
      'title': 'Banquat Chicken Pot Pie -> Marie Callenders Califlower Crust',
      'image2':
          'https://www.mariecallendersmeals.com/sites/g/files/qyyrlu306/files/images/products/chicken-pot-pie-with-crust-85705.png'
    },
    {
      'image':
          'https://images.heb.com/is/image/HEBGrocery/005684048?fit=constrain,1&wid=800&hei=800&fmt=jpg&qlt=85,0&resMode=sharp2&op_usm=1.75,0.3,2,0',
      'title':
          'Checkers Rallys Famous Seasoned Fries -> Alexia Organic Sweet Potato Fries',
      'image2':
          'https://www.eatthis.com/wp-content/uploads/sites/4/2019/10/alexia-organic-sweet-potato-fries.jpg'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar.large(
          leading: const Text(''),
          title: Text(
            'Recommendations',
            style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 45),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const InfoPage()));
              },
              icon: const Icon(
                Icons.info_outline,
                size: 35,
              ),
              color: Colors.indigo[400],
            )
          ],
        ),
      ],
    ));
  }
}
