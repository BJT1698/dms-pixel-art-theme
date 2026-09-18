/**
 * Pixel Bookmarks Manager
 */
(function() {
  const bookmarksGrid = document.getElementById('bookmarksGrid');
  const bookmarkModal = document.getElementById('bookmarkModal');
  const bookmarkModalTitle = document.getElementById('bookmarkModalTitle');
  const closeBookmarkBtn = document.getElementById('closeBookmarkBtn');
  const bookmarkForm = document.getElementById('bookmarkForm');
  const bookmarkIndexInput = document.getElementById('bookmarkIndex');
  const bmTitleInput = document.getElementById('bmTitle');
  const bmUrlInput = document.getElementById('bmUrl');
  const bmTagInput = document.getElementById('bmTag');
  const deleteBmBtn = document.getElementById('deleteBmBtn');
  const addBookmarkBtn = document.getElementById('addBookmarkBtn');
  const settingsModal = document.getElementById('settingsModal');

  if (!bookmarksGrid) return;

  const DEFAULT_BOOKMARKS = [
    { title: 'GitHub', url: 'https://github.com', tag: 'GH' },
    { title: 'YouTube', url: 'https://youtube.com', tag: 'YT' },
    { title: 'Reddit', url: 'https://reddit.com', tag: 'RD' },
    { title: 'Discord', url: 'https://discord.com/app', tag: 'DC' },
    { title: 'Arch Wiki', url: 'https://wiki.archlinux.org', tag: 'AW' },
    { title: 'ChatGPT', url: 'https://chatgpt.com', tag: 'AI' },
    { title: 'Twitter / X', url: 'https://x.com', tag: 'X' },
    { title: 'Gmail', url: 'https://mail.google.com', tag: 'GM' }
  ];

  function getBookmarks() {
    try {
      const stored = localStorage.getItem('pixel_bookmarks');
      if (stored) {
        return JSON.parse(stored);
      }
    } catch (e) {
      console.warn('Could not parse stored bookmarks', e);
    }
    return DEFAULT_BOOKMARKS;
  }

  function saveBookmarks(bms) {
    localStorage.setItem('pixel_bookmarks', JSON.stringify(bms));
  }

  function renderBookmarks() {
    const list = getBookmarks();
    bookmarksGrid.innerHTML = '';

    list.forEach((bm, idx) => {
      const card = document.createElement('a');
      card.href = bm.url;
      card.className = 'bookmark-card';
      card.title = `${bm.title} (${bm.url})`;

      const tagSpan = document.createElement('span');
      tagSpan.className = 'bookmark-tag';
      tagSpan.textContent = bm.tag || bm.title.slice(0, 2).toUpperCase();

      const titleSpan = document.createElement('span');
      titleSpan.className = 'bookmark-title';
      titleSpan.textContent = bm.title;

      card.appendChild(tagSpan);
      card.appendChild(titleSpan);

      // Context menu for editing/deleting
      card.addEventListener('contextmenu', (e) => {
        e.preventDefault();
        openEditModal(idx);
      });

      bookmarksGrid.appendChild(card);
    });
  }

  function openEditModal(idx) {
    const list = getBookmarks();
    const bm = list[idx];
    if (!bm) return;

    bookmarkModalTitle.textContent = 'EDIT BOOKMARK';
    bookmarkIndexInput.value = idx;
    bmTitleInput.value = bm.title;
    bmUrlInput.value = bm.url;
    bmTagInput.value = bm.tag || '';
    deleteBmBtn.classList.remove('hidden');
    bookmarkModal.classList.remove('hidden');
  }

  function openAddModal() {
    bookmarkModalTitle.textContent = 'ADD BOOKMARK';
    bookmarkIndexInput.value = '-1';
    bmTitleInput.value = '';
    bmUrlInput.value = '';
    bmTagInput.value = '';
    deleteBmBtn.classList.add('hidden');
    if (settingsModal) settingsModal.classList.add('hidden');
    bookmarkModal.classList.remove('hidden');
  }

  if (closeBookmarkBtn) {
    closeBookmarkBtn.addEventListener('click', () => {
      bookmarkModal.classList.add('hidden');
    });
  }

  if (addBookmarkBtn) {
    addBookmarkBtn.addEventListener('click', openAddModal);
  }

  if (bookmarkForm) {
    bookmarkForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const list = getBookmarks();
      const idx = parseInt(bookmarkIndexInput.value, 10);
      const newBm = {
        title: bmTitleInput.value.trim(),
        url: bmUrlInput.value.trim(),
        tag: bmTagInput.value.trim().toUpperCase()
      };

      if (idx >= 0 && idx < list.length) {
        list[idx] = newBm;
      } else {
        list.push(newBm);
      }

      saveBookmarks(list);
      renderBookmarks();
      bookmarkModal.classList.add('hidden');
    });
  }

  if (deleteBmBtn) {
    deleteBmBtn.addEventListener('click', () => {
      const list = getBookmarks();
      const idx = parseInt(bookmarkIndexInput.value, 10);
      if (idx >= 0 && idx < list.length) {
        list.splice(idx, 1);
        saveBookmarks(list);
        renderBookmarks();
      }
      bookmarkModal.classList.add('hidden');
    });
  }

  // Initial render
  renderBookmarks();
})();
