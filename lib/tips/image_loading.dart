import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../element/tip_button.dart';
import '../globals_debug.dart';

class ImageLoading extends StatefulWidget {
  const ImageLoading({super.key});

  @override
  State<ImageLoading> createState() => _ImageLoadingState();
}

class _ImageLoadingState extends State<ImageLoading> {
  String imageUrl0 = 'https://picsum.photos/600/400';
  String imageUrl1 = 'https://picsum.photos/600/400';
  String imageUrl2 = 'https://picsum.photos/600/400';

  void _updateImages() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      imageUrl0 = 'https://picsum.photos/600/400?random=$timestamp';
      imageUrl1 = 'https://picsum.photos/600/400?random=$timestamp';
      imageUrl2 = 'https://picsum.photos/600/400?random=${timestamp + 100}';
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      imageUrl0 = 'https://picsum.photos/600/400?random=$timestamp';
      imageUrl1 = 'https://picsum.photos/600/400?random=$timestamp';
      imageUrl2 = 'https://picsum.photos/600/400?random=${timestamp + 100}';
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d("ImageLoading build triggered");

    return Scaffold(
      appBar: AppBar(title: const Text('🖼 圖片載入優化示範')),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionTitle('🔹 CachedNetworkImage（有快取）'),
            CachedNetworkImage(
              key: ValueKey(imageUrl0),
              imageUrl: imageUrl0,
              placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
              imageBuilder: (_, imageProvider) => Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            const SectionTitle('🔹 FadeInImage.assetNetwork（漸變 + 預設圖）'),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/testpng.png',
                image: imageUrl1,
                fadeInDuration: const Duration(milliseconds: 400),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),

            const SectionTitle('🔹 CachedNetworkImage + AssetImage（本地 + 緩存圖）'),
            CachedNetworkImage(
              key: const ValueKey("staticImage"),
              imageUrl: "https://img-blog.csdnimg.cn/20210324100419204.png",
              placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),
            const SizedBox(height: 32),

            const SectionTitle('🔹 本地圖片（Image.asset）'),
            const Image(
              image: AssetImage("assets/testpng.png"),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 32),

            const SectionTitle('🔹 Stack + 網路圖片 (避免閃爍)'),
            Stack(
              children: [
                // 本地預設圖
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/testpng.png',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // 網路圖覆蓋上來
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl2,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) {
                      return progress == null
                          ? child
                          : const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            TipButton(
              onPressed: _updateImages,
              text: '更新圖片',
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}
