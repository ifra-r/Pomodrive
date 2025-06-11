<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Pomodrive</title>
  <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="css/home.css" />
</head>
<body>
  <!-- Top Left -->
  <div class="brand">
    <div class="title">Pomodrive</div>
    <div class="author">by Ifra</div>
  </div>

  <!-- Top Right -->
  <div class="quote" id="quote">Focus on being productive, not busy.</div>

  <!-- Center Time -->
  <div class="time" id="time">--:--:--</div>

  <!-- Bottom Left Icons -->
  <div class="bottom-left icons">
    <img src="icons/audio.png" alt="Audio" />
    <img src="icons/music.png" alt="Music" />
    <img src="icons/theme.png" alt="Theme" />
  </div>

  <!-- Bottom Right Icons -->
  <div class="bottom-right icons">
    <!-- <img src="icons/focus.png" alt="Focus" />
      -->
      <a href="focus.jsp">
        <img src="icons/focus.png" alt="Focus" />
      </a>
    <img src="icons/settings.png" alt="Settings" />
    <img src="icons/todo.png" alt="To-Do" />
  </div>

  <script>
    // Live Time Display
    function updateTime() {
      const now = new Date();
      const timeStr = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
      document.getElementById('time').textContent = timeStr;
    }
    setInterval(updateTime, 1000);
    updateTime();
  </script>

  
</body>
</html>
