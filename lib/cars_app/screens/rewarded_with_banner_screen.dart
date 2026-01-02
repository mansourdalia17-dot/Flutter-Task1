import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedWithBannerScreen extends StatefulWidget {
  @override
  _RewardedWithBannerScreenState createState() => _RewardedWithBannerScreenState();
}

class _RewardedWithBannerScreenState extends State<RewardedWithBannerScreen> {
  RewardedAd? _rewardedAd;
  bool _isRewardedLoading = false;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  // ✅ تحميل Banner Ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // ✅ Test Banner ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
          debugPrint('✅ BannerAd Loaded');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('❌ Failed to load BannerAd: $error');
        },
      ),
    )..load();
  }

  // ✅ تحميل Rewarded Ad
  void _loadRewardedAd() {
    if (_isRewardedLoading) return;

    setState(() => _isRewardedLoading = true);

    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // ✅ Test Rewarded ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('✅ RewardedAd Loaded');
          setState(() {
            _isRewardedLoading = false;
            _rewardedAd = ad;
          });
          _showRewardedAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('❌ Failed to load RewardedAd: $error');
          setState(() {
            _isRewardedLoading = false;
            _rewardedAd = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('فشل تحميل الإعلان، حاول مرة أخرى')),
          );
        },
      ),
    );
  }

  // ✅ عرض Rewarded Ad
  void _showRewardedAd() {
    if (_rewardedAd == null) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('👋 تم إغلاق الإعلان');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('🚫 فشل عرض الإعلان: $error');
        ad.dispose();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('🎁 حصلت على ${reward.amount} ${reward.type}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🎉 حصلت على ${reward.amount} ${reward.type}')),
        );
      },
    );

    _rewardedAd = null;
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعلانات المكافأة + Banner'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: _isRewardedLoading ? null : _loadRewardedAd,
                child: const Text('🎬 شاهد إعلان واحصل على مكافأة'),
              ),
            ),
          ),
          if (_isBannerAdLoaded)
            Container(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}
