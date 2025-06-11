<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Pomodrive Focus</title>
  <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="css/focus.css" />
  <script src="focus.js" defer></script>
</head>

<body>
  <!-- Top Bar -->
  <div class="top-bar">
    <div class="brand">
      <div class="title">Pomodrive</div>
      <div class="author">by Ifra</div>
    </div>
    <div class="quote">Stay focused and never give up.</div>
  </div>

  <!-- Main Content -->
  <div class="main-container">
    <!-- Mode Buttons -->
    <div class="modes">
      <button id="focusBtn">Focus</button>
      <button id="shortBreakBtn">Short Break</button>
      <button id="longBreakBtn">Long Break</button>
    </div>


    <!-- Timer Display -->
    <div class="time" id="time">24:49</div>

    <!-- Timer Controls -->
    <div class="controls">
      <button id="startPause">Start</button>
      <button id="reset">Reset</button> 
      <!-- <button id="pip">Picture-in-Picture</button>  -->
    </div>
  </div>

  <!-- Bottom Toolbar -->
  <div class="bottom-toolbar">
    <div class="left-icons">
      <img src="icons/audio.png" id="audio-btn" title="Sounds"> 
      <img src="icons/music.png" alt="Music" />
      <img src="icons/theme.png" alt="Theme" />
    </div>

    <div class="right-icons">
      <a href="home.jsp"> <img src="icons/home.png" alt="Home" /> </a>
      <img src="icons/settings.png" alt="Settings" />
      <img src="icons/todo.png" alt="To-Do" />
      <img src="icons/fullscreen.png" alt="Fullscreen" />
    </div>
  </div>



  <!-- Sound Modal -->
  <div id="sound-modal" class="modal">
    <div class="modal-content">
      <span id="close-sound-modal" class="close-btn">&times;</span>
      <h3>Select Background Sound</h3>
      <div class="sound-grid">
        <div class="sound-option" data-sound="bell.mp3">🔔 Bell</div>
        <div class="sound-option" data-sound="birds_chirping.mp3">🐦 Birds</div>
        <div class="sound-option" data-sound="rain_and_thunder.mp3">🌩️ Rain & Thunder</div>
        <div class="sound-option" data-sound="raindrops_falling.mp3">💧 Raindrops</div>
        <div class="sound-option" data-sound="smooth_jazz.mp3">🎷 Jazz</div>
        <div class="sound-option" data-sound="ocean_waves.mp3">🌊 Ocean</div>
        <div class="sound-option" data-sound="cafe_music.mp3">☕ Cafe</div>
        <div class="sound-option" data-sound="footsteps_on_leaves.mp3">🍂 Leaves</div>
      </div>
    </div>
  </div>

</body>
</html>
