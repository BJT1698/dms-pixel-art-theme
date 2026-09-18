/**
 * Pixel Art Animated Synthwave Horizon Canvas Engine
 */
(function() {
  const canvas = document.getElementById('pixelCanvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');

  // Virtual low-resolution canvas for crisp chunky pixel art
  const V_WIDTH = 480;
  const V_HEIGHT = 270;
  const virtualCanvas = document.createElement('canvas');
  virtualCanvas.width = V_WIDTH;
  virtualCanvas.height = V_HEIGHT;
  const vCtx = virtualCanvas.getContext('2d');
  vCtx.imageSmoothingEnabled = false;
  ctx.imageSmoothingEnabled = false;

  // Configuration & State
  window.pixelEngine = {
    speedMultiplier: 1.0,
    activeTheme: 'arcade-neon',
    paused: false
  };

  // Palette schemes for the canvas
  const palettes = {
    'arcade-neon': {
      skyTop: '#0b0416',
      skyMid: '#2d0c42',
      skyBot: '#7b1968',
      sunTop: '#ffe600',
      sunMid: '#ff5500',
      sunBot: '#ff007f',
      gridColor: '#00f0ff',
      gridGlow: '#004854',
      mountainFar: '#1c0c2e',
      mountainNear: '#0f061b',
      mountainRidge: '#ff007f',
      starColor: '#ffffff',
      groundBg: '#05030a'
    },
    'pico-8': {
      skyTop: '#000000',
      skyMid: '#1d2b53',
      skyBot: '#7e2553',
      sunTop: '#ffec27',
      sunMid: '#ffa300',
      sunBot: '#ff004d',
      gridColor: '#29adff',
      gridGlow: '#1d2b53',
      mountainFar: '#1d2b53',
      mountainNear: '#000000',
      mountainRidge: '#ff77a8',
      starColor: '#fff1e8',
      groundBg: '#000000'
    },
    'game-boy': {
      skyTop: '#082008',
      skyMid: '#0f380f',
      skyBot: '#1e4d1e',
      sunTop: '#9bbc0f',
      sunMid: '#8bac0f',
      sunBot: '#306230',
      gridColor: '#8bac0f',
      gridGlow: '#0f380f',
      mountainFar: '#1e4d1e',
      mountainNear: '#082008',
      mountainRidge: '#9bbc0f',
      starColor: '#9bbc0f',
      groundBg: '#051605'
    },
    '16bit-rpg': {
      skyTop: '#0a0712',
      skyMid: '#262b44',
      skyBot: '#472e18',
      sunTop: '#fee761',
      sunMid: '#f2b705',
      sunBot: '#b86f00',
      gridColor: '#38b764',
      gridGlow: '#181425',
      mountainFar: '#262b44',
      mountainNear: '#181425',
      mountainRidge: '#f2b705',
      starColor: '#fee761',
      groundBg: '#0f0b18'
    }
  };

  // Generate starfield
  const STARS_COUNT = 65;
  const stars = [];
  for (let i = 0; i < STARS_COUNT; i++) {
    stars.push({
      x: Math.floor(Math.random() * V_WIDTH),
      y: Math.floor(Math.random() * (V_HEIGHT * 0.55)),
      size: Math.random() > 0.85 ? 2 : 1,
      twinkleSpeed: 0.02 + Math.random() * 0.05,
      twinklePhase: Math.random() * Math.PI * 2
    });
  }

  // Shooting star
  let shootingStar = null;
  function spawnShootingStar() {
    if (Math.random() < 0.006 && !shootingStar) {
      shootingStar = {
        x: Math.floor(Math.random() * (V_WIDTH * 0.7)),
        y: Math.floor(Math.random() * (V_HEIGHT * 0.3)),
        vx: 4 + Math.random() * 3,
        vy: 2 + Math.random() * 2,
        length: 12 + Math.random() * 10,
        life: 1.0,
        decay: 0.03
      };
    }
  }

  // Mountain profiles (pre-baked pixel heights for smooth performance)
  const mountainFarHeights = [];
  const mountainNearHeights = [];
  function generateMountains() {
    for (let x = 0; x < V_WIDTH; x++) {
      const f1 = Math.sin(x * 0.015) * 14 + Math.sin(x * 0.04) * 8 + Math.cos(x * 0.08) * 3;
      mountainFarHeights[x] = Math.max(0, Math.floor(f1 + 10));

      const f2 = Math.sin(x * 0.025 + 2.0) * 18 + Math.sin(x * 0.06 + 1.0) * 10 + Math.cos(x * 0.1) * 4;
      mountainNearHeights[x] = Math.max(0, Math.floor(f2 + 14));
    }
  }
  generateMountains();

  // Grid animation state
  let gridOffset = 0;
  const HORIZON_Y = Math.floor(V_HEIGHT * 0.58);
  const SUN_RADIUS = 36;
  const SUN_CX = Math.floor(V_WIDTH / 2);
  const SUN_CY = HORIZON_Y - 10;

  function resizeCanvas() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    ctx.imageSmoothingEnabled = false;
  }
  window.addEventListener('resize', resizeCanvas);
  resizeCanvas();

  // Main Render Loop
  let lastTime = performance.now();

  function render(now) {
    requestAnimationFrame(render);
    const dt = Math.min(32, now - lastTime) / 1000;
    lastTime = now;

    if (!window.pixelEngine.paused) {
      gridOffset = (gridOffset + dt * 0.65 * window.pixelEngine.speedMultiplier) % 1.0;
    }

    const themeName = window.pixelEngine.activeTheme || 'arcade-neon';
    const theme = palettes[themeName] || palettes['arcade-neon'];

    // 1. Clear & Draw Sky Gradient
    const skyGrad = vCtx.createLinearGradient(0, 0, 0, HORIZON_Y);
    skyGrad.addColorStop(0.0, theme.skyTop);
    skyGrad.addColorStop(0.65, theme.skyMid);
    skyGrad.addColorStop(1.0, theme.skyBot);
    vCtx.fillStyle = skyGrad;
    vCtx.fillRect(0, 0, V_WIDTH, HORIZON_Y);

    // 2. Draw Stars
    for (let i = 0; i < stars.length; i++) {
      const s = stars[i];
      s.twinklePhase += s.twinkleSpeed;
      const alpha = 0.3 + 0.7 * Math.abs(Math.sin(s.twinklePhase));
      vCtx.fillStyle = theme.starColor;
      vCtx.globalAlpha = alpha;
      vCtx.fillRect(s.x, s.y, s.size, s.size);
    }
    vCtx.globalAlpha = 1.0;

    // 3. Draw Shooting Star
    spawnShootingStar();
    if (shootingStar) {
      vCtx.strokeStyle = theme.starColor;
      vCtx.lineWidth = 1;
      vCtx.globalAlpha = shootingStar.life;
      vCtx.beginPath();
      vCtx.moveTo(shootingStar.x, shootingStar.y);
      vCtx.lineTo(shootingStar.x - shootingStar.vx * (shootingStar.length / 5), shootingStar.y - shootingStar.vy * (shootingStar.length / 5));
      vCtx.stroke();
      vCtx.globalAlpha = 1.0;

      shootingStar.x += shootingStar.vx;
      shootingStar.y += shootingStar.vy;
      shootingStar.life -= shootingStar.decay;
      if (shootingStar.life <= 0 || shootingStar.x > V_WIDTH || shootingStar.y > HORIZON_Y) {
        shootingStar = null;
      }
    }

    // 4. Draw Giant Sliced Retro Sun
    for (let y = SUN_CY - SUN_RADIUS; y <= SUN_CY + SUN_RADIUS; y++) {
      if (y >= HORIZON_Y) continue;
      const dy = y - SUN_CY;
      const halfWidth = Math.sqrt(Math.max(0, SUN_RADIUS * SUN_RADIUS - dy * dy));
      if (halfWidth <= 0) continue;

      // Scanline slicing in lower half of sun
      if (dy > -4) {
        const slicePhase = (y - SUN_CY + (gridOffset * 10)) % 7;
        if (slicePhase < 2.5 && dy > 4) {
          continue; // Scanline gap
        }
      }

      // Vertical color interpolation for sun
      const t = (y - (SUN_CY - SUN_RADIUS)) / (SUN_RADIUS * 2);
      if (t < 0.45) {
        vCtx.fillStyle = theme.sunTop;
      } else if (t < 0.75) {
        vCtx.fillStyle = theme.sunMid;
      } else {
        vCtx.fillStyle = theme.sunBot;
      }

      const left = Math.floor(SUN_CX - halfWidth);
      const width = Math.floor(halfWidth * 2);
      vCtx.fillRect(left, y, width, 1);
    }

    // 5. Draw Distant Mountains
    vCtx.fillStyle = theme.mountainFar;
    for (let x = 0; x < V_WIDTH; x++) {
      const h = mountainFarHeights[x];
      if (h > 0) {
        vCtx.fillRect(x, HORIZON_Y - h, 1, h);
      }
    }

    // 6. Draw Near Mountains + Neon Ridge Highlight
    for (let x = 0; x < V_WIDTH; x++) {
      const h = mountainNearHeights[x];
      if (h > 0) {
        const topY = HORIZON_Y - h;
        // Ridge line
        vCtx.fillStyle = theme.mountainRidge;
        vCtx.fillRect(x, topY, 1, 1);
        // Body
        vCtx.fillStyle = theme.mountainNear;
        vCtx.fillRect(x, topY + 1, 1, h - 1);
      }
    }

    // 7. Draw Ground Base
    vCtx.fillStyle = theme.groundBg;
    vCtx.fillRect(0, HORIZON_Y, V_WIDTH, V_HEIGHT - HORIZON_Y);

    // 8. Draw 3D Perspective Synthwave Grid
    const groundH = V_HEIGHT - HORIZON_Y;
    const NUM_GRID_LINES = 12;

    // Horizontal scrolling grid lines (curved perspective density)
    vCtx.strokeStyle = theme.gridColor;
    vCtx.lineWidth = 1;

    for (let i = 0; i < NUM_GRID_LINES; i++) {
      const p = (i + gridOffset) / NUM_GRID_LINES;
      const py = Math.floor(HORIZON_Y + Math.pow(p, 2.2) * groundH);
      if (py >= HORIZON_Y && py < V_HEIGHT) {
        const alpha = Math.min(1.0, Math.pow(p, 1.2) * 1.5);
        vCtx.globalAlpha = alpha;
        vCtx.beginPath();
        vCtx.moveTo(0, py);
        vCtx.lineTo(V_WIDTH, py);
        vCtx.stroke();
      }
    }
    vCtx.globalAlpha = 1.0;

    // Perspective Vertical Rays from Vanishing Point
    const NUM_RAYS = 18;
    const vpX = SUN_CX;
    const vpY = HORIZON_Y;

    for (let i = -NUM_RAYS; i <= NUM_RAYS; i++) {
      const bottomX = SUN_CX + i * (V_WIDTH / 10);
      vCtx.strokeStyle = theme.gridColor;
      vCtx.globalAlpha = Math.max(0.2, 1.0 - Math.abs(i) / (NUM_RAYS * 1.2));
      vCtx.beginPath();
      vCtx.moveTo(vpX, vpY);
      vCtx.lineTo(bottomX, V_HEIGHT);
      vCtx.stroke();
    }
    vCtx.globalAlpha = 1.0;

    // 9. Horizon Line Glow
    vCtx.fillStyle = theme.gridColor;
    vCtx.fillRect(0, HORIZON_Y, V_WIDTH, 1);

    // 10. Scale virtual low-res canvas to real screen canvas
    ctx.drawImage(virtualCanvas, 0, 0, canvas.width, canvas.height);
  }

  requestAnimationFrame(render);
})();
