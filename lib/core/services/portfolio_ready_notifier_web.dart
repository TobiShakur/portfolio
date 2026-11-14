import 'package:web/web.dart' as web;

/// Dispatches the `portfolio-ready` DOM event once fonts, images, and first
/// frame have settled so `#initial-loader` transitions out smoothly.
void notifyPortfolioReady() {
  web.window.dispatchEvent(web.Event('portfolio-ready'));
}
