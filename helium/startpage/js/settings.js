/**
 * Startpage Settings & Theme Controller
 */
(function() {
  const THEMES = ['arcade-neon', 'pico-8', 'game-boy', '16bit-rpg'];

  const themeToggleBtn = document.getElementById('themeToggleBtn');
  const settingsToggleBtn = document.getElementById('settingsToggleBtn');
  const settingsModal = document.getElementById('settingsModal');
  const closeSettingsBtn = document.getElementById('closeSettingsBtn');
  const themeSelect = document.getElementById('themeSelect');
  const gridSpeedSelect = document.getElementById('gridSpeed');
  const crtToggle = document.getElementById('crtToggle');
  const crtOverlay = document.getElementById('crtOverlay');
  const clockSecondsToggle = document.getElementById('clockSecondsToggle');
  const militaryTimeToggle = document.getElementById('militaryTimeToggle');
  const resetDefaultsBtn = document.getElementById('resetDefaultsBtn');

  // Load Saved Preferences
  let currentTheme = localStorage.getItem('pixel_theme') || 'arcade-neon';
  if (!THEMES.includes(currentTheme)) currentTheme = 'arcade-neon';

  function applyTheme(theme) {
    currentTheme = theme;
    document.body.setAttribute('data-theme', theme);
    localStorage.setItem('pixel_theme', theme);
    if (themeSelect) themeSelect.value = theme;
    if (window.pixelEngine) {
      window.pixelEngine.activeTheme = theme;
    }
  }
  applyTheme(currentTheme);

  // Cycle Theme Button & Hotkey
  function cycleTheme() {
    const idx = THEMES.indexOf(currentTheme);
    const nextIdx = (idx + 1) % THEMES.length;
    applyTheme(THEMES[nextIdx]);
  }

  if (themeToggleBtn) {
    themeToggleBtn.addEventListener('click', cycleTheme);
  }

  // Settings Modal
  if (settingsToggleBtn && settingsModal) {
    settingsToggleBtn.addEventListener('click', () => {
      settingsModal.classList.toggle('hidden');
    });
  }

  if (closeSettingsBtn && settingsModal) {
    closeSettingsBtn.addEventListener('click', () => {
      settingsModal.classList.add('hidden');
    });
  }

  // Theme Select dropdown
  if (themeSelect) {
    themeSelect.value = currentTheme;
    themeSelect.addEventListener('change', (e) => {
      applyTheme(e.target.value);
    });
  }

  // Grid Speed
  const savedSpeed = localStorage.getItem('pixel_grid_speed') || '1';
  if (gridSpeedSelect) {
    gridSpeedSelect.value = savedSpeed;
    if (window.pixelEngine) window.pixelEngine.speedMultiplier = parseFloat(savedSpeed);
    gridSpeedSelect.addEventListener('change', (e) => {
      const spd = parseFloat(e.target.value);
      localStorage.setItem('pixel_grid_speed', spd);
      if (window.pixelEngine) {
        window.pixelEngine.speedMultiplier = spd;
        window.pixelEngine.paused = (spd === 0);
      }
    });
  }

  // CRT Scanlines
  const crtEnabled = localStorage.getItem('pixel_crt_enabled') !== 'false';
  if (crtToggle && crtOverlay) {
    crtToggle.checked = crtEnabled;
    if (!crtEnabled) crtOverlay.classList.add('disabled');

    crtToggle.addEventListener('change', (e) => {
      const enabled = e.target.checked;
      localStorage.setItem('pixel_crt_enabled', enabled);
      if (enabled) {
        crtOverlay.classList.remove('disabled');
      } else {
        crtOverlay.classList.add('disabled');
      }
    });
  }

  // Clock Options
  if (clockSecondsToggle) {
    clockSecondsToggle.checked = localStorage.getItem('pixel_clock_seconds') !== 'false';
    clockSecondsToggle.addEventListener('change', (e) => {
      localStorage.setItem('pixel_clock_seconds', e.target.checked);
    });
  }

  if (militaryTimeToggle) {
    militaryTimeToggle.checked = localStorage.getItem('pixel_clock_24h') !== 'false';
    militaryTimeToggle.addEventListener('change', (e) => {
      localStorage.setItem('pixel_clock_24h', e.target.checked);
    });
  }

  // Reset Defaults
  if (resetDefaultsBtn) {
    resetDefaultsBtn.addEventListener('click', () => {
      localStorage.removeItem('pixel_theme');
      localStorage.removeItem('pixel_grid_speed');
      localStorage.removeItem('pixel_crt_enabled');
      localStorage.removeItem('pixel_clock_seconds');
      localStorage.removeItem('pixel_clock_24h');
      localStorage.removeItem('pixel_search_engine');
      localStorage.removeItem('pixel_bookmarks');
      window.location.reload();
    });
  }

  // Keyboard Shortcuts
  document.addEventListener('keydown', (e) => {
    // If typing in input, ignore global shortcuts
    if (['INPUT', 'SELECT', 'TEXTAREA'].includes(document.activeElement.tagName)) {
      if (e.key === 'Escape') {
        document.activeElement.blur();
        if (settingsModal) settingsModal.classList.add('hidden');
      }
      return;
    }

    if (e.key.toLowerCase() === 't') {
      cycleTheme();
    } else if (e.key.toLowerCase() === 'c') {
      if (settingsModal) settingsModal.classList.toggle('hidden');
    } else if (e.key === 'Escape') {
      if (settingsModal) settingsModal.classList.add('hidden');
    }
  });
})();
