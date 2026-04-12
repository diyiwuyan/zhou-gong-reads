// Service Worker for 周公解书 PWA
const CACHE_NAME = 'zhougong-reads-v7';
const BASE = '/zhou-gong-reads';

const COVER_FILES = [
  'thinking-fast-slow','poor-charlies-almanack','black-swan','principles',
  'fifth-discipline','peak','outliers','art-of-thinking-clearly',
  'rich-dad-poor-dad','intelligent-investor','richest-man-babylon',
  'almanack-naval','reminiscences-stock-operator','zero-marginal-cost',
  'irrational-exuberance','psychology-of-money','courage-to-be-disliked',
  'flow','willpower-instinct','power-of-habit','toxic-parents',
  'maybe-you-should-talk','toad-therapy','7-habits','good-to-great',
  'innovators-dilemma','alliance','powerful-netflix','how-google-works',
  'art-of-war','sapiens','homo-deus','singularity-is-near','what-is-life',
  'brief-history-of-time','selfish-gene','guns-germs-steel','quantum-physics',
  'sophies-world','tao-te-ching','meditations','mans-search-for-meaning',
  'analects','myth-of-sisyphus','being-and-time','republic',
  'nicomachean-ethics','zen-motorcycle'
].map(f => `${BASE}/assets/covers/${f}.jpg`);

const STATIC_ASSETS = [
  BASE + '/',
  BASE + '/index.html',
  BASE + '/manifest.json',
  BASE + '/assets/icons/icon-192.png',
  BASE + '/assets/icons/icon-512.png',
  ...COVER_FILES
];

// Install: 预缓存所有静态资源（含封面图）
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      // 分批缓存，避免一次性请求过多
      const chunks = [];
      for (let i = 0; i < STATIC_ASSETS.length; i += 10) {
        chunks.push(STATIC_ASSETS.slice(i, i + 10));
      }
      return chunks.reduce((p, chunk) =>
        p.then(() => cache.addAll(chunk).catch(() => {})),
        Promise.resolve()
      );
    }).then(() => self.skipWaiting())
  );
});

// Activate: 清理旧缓存
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

// Fetch 策略：
// - index.html / 导航：网络优先（确保始终拿最新版）
// - 图片：缓存优先（加速加载，离线可用）
// - 其他：网络优先，失败回退缓存
self.addEventListener('fetch', event => {
  if (event.request.method !== 'GET') return;

  const url = new URL(event.request.url);
  if (url.origin !== location.origin) return;

  const isNavigation = event.request.mode === 'navigate';
  const isHtml = url.pathname.endsWith('.html') || url.pathname.endsWith('/');
  const isImage = /\.(jpg|jpeg|png|gif|webp|svg)$/i.test(url.pathname);

  if (isNavigation || isHtml) {
    // HTML / 导航：网络优先
    event.respondWith(
      fetch(event.request).then(response => {
        if (response && response.status === 200) {
          const clone = response.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(event.request, clone));
        }
        return response;
      }).catch(() => caches.match(event.request))
    );
  } else if (isImage) {
    // 图片：缓存优先（封面图已预缓存，极速加载）
    event.respondWith(
      caches.match(event.request).then(cached => {
        if (cached) return cached;
        return fetch(event.request).then(response => {
          if (response && response.status === 200) {
            const clone = response.clone();
            caches.open(CACHE_NAME).then(cache => cache.put(event.request, clone));
          }
          return response;
        });
      })
    );
  } else {
    // 其他资源：网络优先
    event.respondWith(
      fetch(event.request).then(response => {
        if (response && response.status === 200) {
          const clone = response.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(event.request, clone));
        }
        return response;
      }).catch(() => caches.match(event.request))
    );
  }
});
