/**
 * Search Engine & URL Input Handling
 */
(function() {
  const searchForm = document.getElementById('searchForm');
  const searchInput = document.getElementById('searchInput');
  const engineBadge = document.getElementById('engineBadge');
  const engineIcon = document.getElementById('engineIcon');
  const enginesMenu = document.getElementById('enginesMenu');

  if (!searchForm || !searchInput) return;

  const ENGINES = {
    google: {
      name: 'Google',
      url: 'https://www.google.com/search?q=',
      icon: 'G'
    },
    duckduckgo: {
      name: 'DuckDuckGo',
      url: 'https://duckduckgo.com/?q=',
      icon: 'D'
    },
    github: {
      name: 'GitHub',
      url: 'https://github.com/search?q=',
      icon: 'GH'
    },
    youtube: {
      name: 'YouTube',
      url: 'https://www.youtube.com/results?search_query=',
      icon: 'YT'
    },
    reddit: {
      name: 'Reddit',
      url: 'https://www.reddit.com/search/?q=',
      icon: 'R'
    },
    archwiki: {
      name: 'ArchWiki',
      url: 'https://wiki.archlinux.org/index.php?search=',
      icon: 'AW'
    }
  };

  let currentEngine = localStorage.getItem('pixel_search_engine') || 'google';
  if (!ENGINES[currentEngine]) currentEngine = 'google';

  function updateEngineDisplay() {
    const eng = ENGINES[currentEngine];
    if (engineIcon) engineIcon.textContent = eng.icon;
  }
  updateEngineDisplay();

  // Engine Dropdown
  if (engineBadge && enginesMenu) {
    engineBadge.addEventListener('click', (e) => {
      e.stopPropagation();
      enginesMenu.classList.toggle('hidden');
    });

    document.addEventListener('click', () => {
      enginesMenu.classList.add('hidden');
    });

    enginesMenu.querySelectorAll('.engine-opt').forEach((btn) => {
      btn.addEventListener('click', (e) => {
        const engKey = btn.dataset.engine;
        if (ENGINES[engKey]) {
          currentEngine = engKey;
          localStorage.setItem('pixel_search_engine', currentEngine);
          updateEngineDisplay();
        }
        enginesMenu.classList.add('hidden');
        searchInput.focus();
      });
    });
  }

  // Form Submit / Query Handling
  searchForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const query = searchInput.value.trim();
    if (!query) return;

    // Check for direct URL
    const urlPattern = /^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:\d+)?(\/.*)?$/;
    const isLocalhost = /^https?:\/\/localhost(:\d+)?(\/.*)?$/;

    if (urlPattern.test(query) || isLocalhost.test(query)) {
      const target = query.startsWith('http://') || query.startsWith('https://') ? query : `https://${query}`;
      window.location.href = target;
      return;
    }

    // Check for search engine bang prefixes (e.g. "!gh arch")
    let activeUrl = ENGINES[currentEngine].url;
    let cleanQuery = query;

    if (query.startsWith('!gh ')) {
      activeUrl = ENGINES.github.url;
      cleanQuery = query.slice(4);
    } else if (query.startsWith('!yt ')) {
      activeUrl = ENGINES.youtube.url;
      cleanQuery = query.slice(4);
    } else if (query.startsWith('!ddg ')) {
      activeUrl = ENGINES.duckduckgo.url;
      cleanQuery = query.slice(5);
    } else if (query.startsWith('!r ')) {
      activeUrl = ENGINES.reddit.url;
      cleanQuery = query.slice(3);
    } else if (query.startsWith('!aw ')) {
      activeUrl = ENGINES.archwiki.url;
      cleanQuery = query.slice(4);
    } else if (query.startsWith('!g ')) {
      activeUrl = ENGINES.google.url;
      cleanQuery = query.slice(3);
    }

    window.location.href = `${activeUrl}${encodeURIComponent(cleanQuery)}`;
  });

  // Hotkey: press '/' or 's' to focus search input
  document.addEventListener('keydown', (e) => {
    if (e.key === '/' && document.activeElement !== searchInput) {
      e.preventDefault();
      searchInput.focus();
    }
  });
})();
