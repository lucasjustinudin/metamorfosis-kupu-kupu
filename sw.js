// ===== Metamorfosis Kupu-Kupu — Service Worker =====
// Cache-first strategy untuk offline support

const CACHE_NAME = 'metamorfosis-kupu-v1';
const ASSETS = [
  './',
  './index.html',
  './manifest.json',
  './icon-192.png',
  './icon-512.png',
  './icon-512-maskable.png'
];

// Install: precache semua asset
self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('[SW] Precaching assets');
      return cache.addAll(ASSETS);
    }).then(() => self.skipWaiting())
  );
});

// Activate: hapus cache lama
self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.filter((k) => k !== CACHE_NAME).map((k) => {
          console.log('[SW] Deleting old cache:', k);
          return caches.delete(k);
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch: cache-first, fallback ke network
self.addEventListener('fetch', (e) => {
  // Skip non-GET requests
  if (e.request.method !== 'GET') return;

  e.respondWith(
    caches.match(e.request).then((cached) => {
      if (cached) {
        return cached;
      }
      return fetch(e.request).then((response) => {
        // Cache response baru untuk next time
        if (response && response.status === 200 && response.type === 'basic') {
          const clone = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(e.request, clone));
        }
        return response;
      }).catch(() => {
        // Offline fallback
        if (e.request.destination === 'document') {
          return caches.match('./index.html');
        }
      });
    })
  );
});
