import 'package:flutter/material.dart';
import 'paper_shimmer_loading.dart';

/// Backwards compatibility alias for PaperShimmerLoading
class PaperListShimmer extends PaperShimmerLoading {
  const PaperListShimmer({
    super.key,
    super.itemCount = 3,
    super.padding,
    super.shrinkWrap,
  });
}

/// Backwards compatibility class for individual paper card shimmer
class PaperCardShimmer extends StatelessWidget {
  const PaperCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Return the private _PaperCardShimmer from paper_shimmer_loading.dart
    // Since we can't directly access it, we create a minimal paper shimmer here
    return _MinimalPaperCardShimmer();
  }
}

/// Minimal paper card shimmer for backwards compatibility
class _MinimalPaperCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaperShimmerLoading(itemCount: 1, shrinkWrap: true);
  }
}
