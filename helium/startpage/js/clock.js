/**
 * Pixel Clock & Date Component
 */
(function() {
  const clockTime = document.getElementById('clockTime');
  const clockDate = document.getElementById('clockDate');
  if (!clockTime || !clockDate) return;

  const DAYS = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'];
  const MONTHS = ['JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'];

  function pad(n) {
    return n < 10 ? '0' + n : n;
  }

  function updateClock() {
    const now = new Date();
    const showSeconds = localStorage.getItem('pixel_clock_seconds') !== 'false';
    const is24h = localStorage.getItem('pixel_clock_24h') !== 'false';

    let hours = now.getHours();
    let ampm = '';

    if (!is24h) {
      ampm = hours >= 12 ? ' PM' : ' AM';
      hours = hours % 12 || 12;
    }

    const hStr = pad(hours);
    const mStr = pad(now.getMinutes());
    const sStr = pad(now.getSeconds());

    if (showSeconds) {
      clockTime.textContent = `${hStr}:${mStr}:${sStr}${ampm}`;
    } else {
      clockTime.textContent = `${hStr}:${mStr}${ampm}`;
    }

    const dayName = DAYS[now.getDay()];
    const dayNum = pad(now.getDate());
    const monthName = MONTHS[now.getMonth()];
    const year = now.getFullYear();

    clockDate.textContent = `${dayName}, ${dayNum} ${monthName} ${year}`;
  }

  setInterval(updateClock, 1000);
  updateClock();
})();
