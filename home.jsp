<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Pomodrive</title>
  <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&display=swap" rel="stylesheet" />
  <style>
    body {
      margin: 0;
      padding: 0;
      height: 100vh;
      background: url('images/pink_orange_heart.jpg') no-repeat center center fixed;
      background-size: cover;
      color: #fff;
      font-family: 'Segoe UI Emoji', 'Noto Color Emoji', 'Josefin Sans', sans-serif;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
    }

    /* Optional: Add a subtle overlay to improve text readability */
    body::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.1);
        pointer-events: none;
        z-index: -1;
    }

    .brand {
      position: absolute;
      top: 25px;
      left: 30px;
      font-family: 'Josefin Sans', sans-serif;
      font-weight: 900;
    }

    .brand .title {
      font-size: 2.2em;
      font-weight: 900;
      margin-bottom: -1.5px;
      line-height: 1;
    }

    .brand .author {
      font-size: 0.9em;
      font-weight: 900;
      text-align: right;
    }

    /* Quote (top-right) */
    .quote {
      position: absolute;
      top: 25px;
      right: 30px;
      font-size: 2em;
      font-weight: 700;
      max-width: 400px;
      text-align: right;
    }

    /* Time in center */
    .time {
      font-size: 7em;
      font-weight: 700;
    }

    /* Icons */
    .icons {
      display: flex;
      gap: 20px;
    }
    .icons img {
      width: 40px;
      height: 40px;
      opacity: 0.7;
      cursor: pointer;
      transition: 0.3s;
      border-radius: 12px;
    }
    .icons img:hover {
      opacity: 1;
      transform: scale(1.1);
    }

    /* Bottom Left */
    .bottom-left {
      position: absolute;
      bottom: 20px;
      left: 30px;
    }

    /* Bottom Right */
    .bottom-right {
      position: absolute;
      bottom: 20px;
      right: 30px;
    }

    
    #sound-popup {
        position: fixed;
        bottom: 6rem;
        left: 30px; /* Align with the left edge of bottom-left icons */
        max-width: 300px;
        max-height: 40vh;
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(10px);
        border-radius: 1rem;
        padding: 1.5rem;
        display: none;
        z-index: 1000;
        overflow-y: auto;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    /* Theme Popup Styling - positioned above theme icon */
    #theme-popup {
        position: fixed;
        bottom: 6rem;
        left: 90px; /* Position above theme icon (30px + 40px icon + 20px gap) */
        max-width: 350px;
        max-height: 45vh;
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(10px);
        border-radius: 1rem;
        padding: 1.5rem;
        display: none;
        z-index: 1000;
        overflow-y: auto;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        border: 1px solid rgba(255, 255, 255, 0.1);
    }
    

    /* Grid layout for sound and theme options */
    .sound-grid, .theme-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 0.75rem;
    }

    .theme-grid {
        grid-template-columns: repeat(2, 1fr);
        gap: 0.5rem;
    }

    /* Individual sound and theme buttons */
    .sound-option, .theme-option {
        padding: 0.75rem 1rem;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        color: white;
        cursor: pointer;
        transition: all 0.2s ease;
        font-size: 0.9em;
        text-align: center;
        border: 1px solid transparent;
        font-family: 'Segoe UI Emoji', 'Noto Color Emoji', 'Apple Color Emoji', sans-serif;
        font-variant-emoji: emoji; /* Force emoji rendering */
    }

    .theme-option {
        padding: 0.5rem;
        font-size: 0.8em;
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 40px;
    }

    .sound-option:hover, .theme-option:hover {
        background: rgba(255, 255, 255, 0.2);
        transform: translateY(-1px);
    }

    .sound-option.active, .theme-option.active {
        border: 2px solid rgba(255, 255, 255, 0.4);
        background: rgba(255, 255, 255, 0.25);
        transform: scale(1.02);
    }

    /* Popup title */
    .popup-title {
        color: white;
        font-size: 1.1em;
        font-weight: 600;
        margin-bottom: 1rem;
        text-align: center;
    }
  </style>
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
    <img src="icons/audio.png" id="audio-btn" alt="Audio" title="Sounds" />
    <!-- <img src="icons/music.png" alt="Music" /> -->
    <img src="icons/theme.png" id="theme-btn" alt="Theme" title="Themes" />
  </div>

  <!-- Bottom Right Icons -->
  <div class="bottom-right icons">
    <a href="focus.jsp">
      <img src="icons/focus.png" alt="Focus" />
    </a>
    <!-- <img src="icons/settings.png" alt="Settings" /> -->
    <!-- <img src="icons/todo.png" alt="To-Do" /> -->
  </div>

  <!-- Sound Popup -->
  <div id="sound-popup">
    <div class="popup-title">Ambient Sounds</div>
    <div class="sound-grid">
      <div class="sound-option" data-sound="birds_chirping.mp3">Birds Chirping 🐦</div>
      <div class="sound-option" data-sound="rain_and_thunder.mp3">Rain & Thunder ⛈️</div>
      <div class="sound-option" data-sound="raindrops_falling.mp3">Raindrops 🌧️</div>
      <div class="sound-option" data-sound="smooth_jazz.mp3">Smooth Jazz 🎷</div>
      <div class="sound-option" data-sound="ocean_waves.mp3">Ocean Waves 🌊</div>
      <div class="sound-option" data-sound="cafe_music.mp3">Cafe Ambience ☕</div>
      <div class="sound-option" data-sound="footsteps_on_leaves.mp3">Footsteps on Leaves 🍃</div>
    </div>
  </div>

  <!-- Theme Popup -->
  <div id="theme-popup">
    <div class="popup-title">Choose Theme</div>
    <div class="theme-grid">
      <div class="theme-option" data-theme="batman.jpg">🦇 Batman</div>
      <div class="theme-option" data-theme="blue.jpg">💙 Blue</div>
      <div class="theme-option" data-theme="cat.jpg">🐱 Cat</div>
      <div class="theme-option" data-theme="cloudy.jpg">☁️ Cloudy</div>
      <div class="theme-option" data-theme="green.jpg">💚 Green</div>
      <div class="theme-option" data-theme="pink_heart.jpg">💖 Pink Heart</div>
      <div class="theme-option active" data-theme="pink_orange_heart.jpg">🧡 Pink Orange</div>
      <div class="theme-option" data-theme="red.jpg">❤️ Red</div>
      <div class="theme-option" data-theme="purple.jpg">💜 Purple</div>
    </div>
  </div>

  <script>
    document.addEventListener("DOMContentLoaded", function () {

      var savedTheme = localStorage.getItem('selectedTheme');
      if (savedTheme) {
          document.body.style.backgroundImage = "url('images/" + savedTheme + "')";
          // Update active theme option
          var activeThemeOption = document.querySelector(".theme-option.active");
          if (activeThemeOption) {
              activeThemeOption.classList.remove("active");
          }
          var newActiveOption = document.querySelector(".theme-option[data-theme='" + savedTheme + "']");
          if (newActiveOption) {
              newActiveOption.classList.add("active");
          }
      }

        // Live Time Display
        function updateTime() {
          const now = new Date();
          const timeStr = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
          document.getElementById('time').textContent = timeStr;
        }
        setInterval(updateTime, 1000);
        updateTime();

        // === Audio popup logic ===
        const audioIcon = document.getElementById("audio-btn");
        const soundPopup = document.getElementById("sound-popup");
        const soundOptions = document.querySelectorAll(".sound-option");

        let currentSound = null;
        let currentAudio = null;
        let isSoundPopupVisible = false;

        audioIcon.addEventListener("click", function(e) {
            e.stopPropagation();
            // Close theme popup if open
            if (isThemePopupVisible) {
                isThemePopupVisible = false;
                themePopup.style.display = "none";
            }
            isSoundPopupVisible = !isSoundPopupVisible;
            soundPopup.style.display = isSoundPopupVisible ? "block" : "none";
        });

        for (var k = 0; k < soundOptions.length; k++) {
            soundOptions[k].addEventListener("click", function(e) {
                e.stopPropagation();
                var soundFile = this.dataset.sound;

                if (currentSound === soundFile) {
                    // Stop current sound
                    if (currentAudio) {
                        currentAudio.pause();
                        currentAudio.currentTime = 0;
                    }
                    currentSound = null;
                    this.classList.remove("active");
                } else {
                    // Stop previous sound and start new one
                    if (currentAudio) {
                        currentAudio.pause();
                        var activeOption = document.querySelector(".sound-option.active");
                        if (activeOption) {
                            activeOption.classList.remove("active");
                        }
                    }
                    
                    try {
                        currentAudio = new Audio("sounds/" + soundFile);
                        currentAudio.loop = true;
                        currentAudio.play().catch(function(error) {
                            console.log("Audio play failed:", error);
                        });
                        currentSound = soundFile;
                        this.classList.add("active");
                    } catch (error) {
                        console.log("Audio creation failed:", error);
                    }
                }
            });
        }

        // === Theme popup logic ===
        const themeIcon = document.getElementById("theme-btn");
        const themePopup = document.getElementById("theme-popup");
        const themeOptions = document.querySelectorAll(".theme-option");

        let currentTheme = "pink_orange_heart.jpg";
        let isThemePopupVisible = false;

        themeIcon.addEventListener("click", function(e) {
            e.stopPropagation();
            // Close sound popup if open
            if (isSoundPopupVisible) {
                isSoundPopupVisible = false;
                soundPopup.style.display = "none";
            }
            isThemePopupVisible = !isThemePopupVisible;
            themePopup.style.display = isThemePopupVisible ? "block" : "none";
        });

        for (var m = 0; m < themeOptions.length; m++) {
            themeOptions[m].addEventListener("click", function(e) {
                e.stopPropagation();
                var themeFile = this.dataset.theme;

                // Remove active class from all theme options
                var activeThemeOption = document.querySelector(".theme-option.active");
                if (activeThemeOption) {
                    activeThemeOption.classList.remove("active");
                }

                // Add active class to clicked option
                this.classList.add("active");

                // Change background image
                document.body.style.backgroundImage = "url('images/" + themeFile + "')";
                currentTheme = themeFile;
                
                // Save theme selection - MOVED HERE
                localStorage.setItem('selectedTheme', themeFile);

                // Close theme popup after selection
                isThemePopupVisible = false;
                themePopup.style.display = "none";
            });
        }

        // Close popups when clicking outside
        document.addEventListener("click", function(e) {
            if (!soundPopup.contains(e.target) && e.target !== audioIcon && isSoundPopupVisible) {
                isSoundPopupVisible = false;
                soundPopup.style.display = "none";
            }
            if (!themePopup.contains(e.target) && e.target !== themeIcon && isThemePopupVisible) {
                isThemePopupVisible = false;
                themePopup.style.display = "none";
            }
        });
    });
</script>
</body>
</html>