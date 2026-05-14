const CACHE = 'metacognition-v2';

// Static assets: cache-first (fonts, CSS, favicon)
const STATIC_RE = /\.(ttf|woff2|css|ico|png|svg)$/i;
// Dynamic content: network-first (HTML, JSON, MD)
const DYNAMIC_RE = /\.(html|json|md)$/i;

self.addEventListener('install', e => {
  e.waitUntil(self.skipWaiting());
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys =>
    Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
  ).then(() => self.clients.claim()));
});

self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET') return;

  // ── Network-only: external scripts (Giscus, Google Fonts CDN) ──
  const url = e.request.url;
  if (url.includes('giscus.app') || url.includes('utteranc.es') || url.includes('fonts.gstatic.com')) {
    return; // let browser handle normally
  }

  // ── Static assets: cache-first with background refresh ──
  if (STATIC_RE.test(url)) {
    e.respondWith(
      caches.match(e.request).then(cached => {
        const fetchPromise = fetch(e.request).then(resp => {
          if (resp.ok) { const clone = resp.clone(); caches.open(CACHE).then(c => c.put(e.request, clone)); }
          return resp;
        }).catch(() => cached);
        return cached || fetchPromise;
      })
    );
    return;
  }

  // ── Dynamic content + navigation: network-first ──
  if (DYNAMIC_RE.test(url) || e.request.mode === 'navigate') {
    e.respondWith(
      fetch(e.request).then(resp => {
        if (resp.ok) {
          const clone = resp.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone));
        }
        return resp;
      }).catch(() => caches.match(e.request))
    );
    return;
  }

  // ── Everything else: stale-while-revalidate ──
  e.respondWith(
    caches.open(CACHE).then(cache =>
      cache.match(e.request).then(cached => {
        const fetchPromise = fetch(e.request).then(resp => {
          if (resp.ok) cache.put(e.request, resp.clone());
          return resp;
        }).catch(() => cached);
        return cached || fetchPromise;
      })
    )
  );
});
