<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Pomodrive Focus</title>
  <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&display=swap" rel="stylesheet" />
  <style>
    body {
        margin: 0;
        padding: 0;
        height: 100vh;
        background: url('images/pink_orange_heart.jpg') no-repeat center center fixed;
        background-size: cover;
        color: #fff;
        font-family: 'Josefin Sans', sans-serif;
        display: flex;
        flex-direction: column;
        justify-content: space-between; 
        font-family: 'Segoe UI Emoji', 'Noto Color Emoji', 'Josefin Sans', sans-serif;
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

    .top-bar {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        padding: 25px 30px;
    }

    .brand {
        font-weight: 900;
        line-height: 1.1;
    }

    .brand .title {
        font-size: 2.2em;
        font-weight: 900;
    }

    .brand .author {
        font-size: 0.9em;
        font-weight: 900;
        text-align: right;
    }

    .quote {
        font-size: 1.5em;
        font-weight: 700;
        max-width: 400px;
        text-align: right;
    }

    /* Main Centered Content */
    .main-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        flex-grow: 1;
        gap: 20px;
    }

    .modes button {
        background: rgba(255, 255, 255, 0.2);
        border: none;
        color: white;
        font-size: 1em;
        padding: 8px 16px;
        margin: 0 10px;
        border-radius: 8px;
        cursor: pointer;
        transition: 0.3s;
    }

    .modes button:hover {
        background: rgba(255, 255, 255, 0.4);
    }

    .modes button.active {
        background: rgba(255, 255, 255, 0.5);
    }

    .time {
        font-size: 11em;
        font-weight: 700;
        text-align: center;
    }

    .controls {
        display: flex;
        gap: 20px;
        align-items: center;
    }

    .controls button {
        background: rgba(255, 255, 255, 0.15);
        border: none;
        padding: 10px 20px;
        font-size: 1em;
        color: white;
        border-radius: 10px;
        cursor: pointer;
        transition: 0.3s;
    }

    .controls button:hover {
        background: rgba(255, 255, 255, 0.3);
    }

    .controls img {
        width: 24px;
        height: 24px;
    }

    /* Bottom Toolbar */
    .bottom-toolbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 30px;
    }

    .left-icons, .right-icons {
        display: flex;
        gap: 20px;
    }

    .left-icons img, .right-icons img {
        width: 40px;
        height: 40px;
        opacity: 0.7;
        cursor: pointer;
        transition: 0.3s;
        border-radius: 12px;
    }

    .left-icons img:hover, .right-icons img:hover {
        opacity: 1;
        transform: scale(1.1);
    }

    /* Sound Popup Styling */
    #sound-popup {
        position: fixed;
        bottom: 6rem;
        left: 5vw;
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

    /* Grid layout for sound options */
    .sound-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 0.75rem;
    }

    /* Individual sound buttons */
    .sound-option {
        padding: 0.75rem 1rem;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        color: white;
        cursor: pointer;
        transition: all 0.2s ease;
        font-size: 0.9em;
        text-align: center;
        border: 1px solid transparent;
    }

    .sound-option:hover {
        background: rgba(255, 255, 255, 0.2);
        transform: translateY(-1px);
    }

    .sound-option.active {
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
      <button id="focusBtn" class="active">Focus</button>
      <button id="shortBreakBtn">Short Break</button>
      <button id="longBreakBtn">Long Break</button>
    </div>

    <!-- Timer Display -->
    <div class="time" id="time">25:00</div>

    <!-- Timer Controls -->
    <div class="controls">
      <button id="startPause">Start</button>
      <button id="reset">Reset</button> 
    </div>
  </div>

  <!-- Bottom Toolbar -->
  <div class="bottom-toolbar">
    <div class="left-icons">
      <img src="${pageContext.request.contextPath}/icons/audio.png" id="audio-btn" title="Sounds"> 
      <img src="${pageContext.request.contextPath}/icons/music.png" alt="Music" />
      <img src="${pageContext.request.contextPath}/icons/theme.png" alt="Theme" />
    </div>

    <div class="right-icons">
      <a href="${pageContext.request.contextPath}/home.jsp"> 
        <img src="${pageContext.request.contextPath}/icons/home.png" alt="Home" /> 
      </a>
      <img src="${pageContext.request.contextPath}/icons/settings.png" alt="Settings" />
      <img src="${pageContext.request.contextPath}/icons/todo.png" alt="To-Do" />
      <img src="${pageContext.request.contextPath}/icons/fullscreen.png" alt="Fullscreen" />
    </div>
  </div>

  <!-- Sound Popup -->
  <div id="sound-popup">
    <div class="popup-title">Ambient Sounds</div>
    <div class="sound-grid">
      <div class="sound-option" data-sound="birds_chirping.mp3">🐦 Birds Chirping</div>
      <div class="sound-option" data-sound="rain_and_thunder.mp3">⛈️ Rain & Thunder</div>
      <div class="sound-option" data-sound="raindrops.mp3">🌧️ Raindrops</div>
      <div class="sound-option" data-sound="smooth_jazz.mp3">🎷 Smooth Jazz</div>
      <div class="sound-option" data-sound="ocean_waves.mp3">🌊 Ocean Waves</div>
      <div class="sound-option" data-sound="cafe.mp3">☕ Cafe Ambience</div>
      <div class="sound-option" data-sound="footsteps.mp3">🍃 Footsteps on Leaves</div>
    </div>
  </div>

  <script type="text/javascript">
    // Get context path for dynamic resource loading
    var contextPath = '${pageContext.request.contextPath}';
    
    document.addEventListener("DOMContentLoaded", function () {
        // === Timer logic ===
        let timer;
        let isRunning = false;
        let currentMode = "focus";
        let timeLeft = 0;
        let cycleCount = 0;

        const modeDurations = {
            focus: 25 * 60,
            short: 5 * 60,
            long: 15 * 60
        };

        // Use context path for sound file
        const sound = new Audio(contextPath + "/sounds/bell.mp3");

        const timeDisplay = document.getElementById("time");
        const startPauseBtn = document.getElementById("startPause");
        const resetBtn = document.getElementById("reset");

        function formatTime(seconds) {
            const mins = String(Math.floor(seconds / 60)).padStart(2, "0");
            const secs = String(seconds % 60).padStart(2, "0");
            return mins + ":" + secs;
        }

        function setTimeForMode(mode) {
            currentMode = mode;
            timeLeft = modeDurations[mode];
            updateTimeDisplay();
            stopTimer();
            updateStartPauseButton();
        }

        function updateTimeDisplay() {
            timeDisplay.textContent = formatTime(timeLeft);
        }

        function updateStartPauseButton() {
            startPauseBtn.textContent = isRunning ? "Pause" : "Start";
        }

        function startTimer() {
            if (isRunning) return;
            isRunning = true;
            updateStartPauseButton();
            timer = setInterval(function() {
                if (timeLeft > 0) {
                    timeLeft--;
                    updateTimeDisplay();
                } else {
                    try {
                        sound.play().catch(function(error) {
                            console.log("Sound play failed:", error);
                        });
                    } catch (e) {
                        console.log("Sound error:", e);
                    }
                    stopTimer();
                    autoSwitch();
                }
            }, 1000);
        }

        function stopTimer() {
            if (timer) {
                clearInterval(timer);
            }
            isRunning = false;
            updateStartPauseButton();
        }

        function resetTimer() {
            setTimeForMode(currentMode);
        }

        function autoSwitch() {
            if (currentMode === "focus") {
                cycleCount++;
                setTimeForMode(cycleCount % 4 === 0 ? "long" : "short");
            } else {
                setTimeForMode("focus");
            }
            startTimer();
        }

        startPauseBtn.addEventListener("click", function() {
            if (isRunning) {
                stopTimer();
            } else {
                startTimer();
            }
        });

        resetBtn.addEventListener("click", function() {
            resetTimer();
        });

        var modeButtons = document.querySelectorAll(".modes button");
        for (var i = 0; i < modeButtons.length; i++) {
            (function(index) {
                modeButtons[index].addEventListener("click", function() {
                    var modes = ["focus", "short", "long"];
                    setTimeForMode(modes[index]);
                    for (var j = 0; j < modeButtons.length; j++) {
                        modeButtons[j].classList.remove("active");
                    }
                    this.classList.add("active");
                });
            })(i);
        }

        // === Audio popup logic ===
        const audioIcon = document.getElementById("audio-btn");
        const popup = document.getElementById("sound-popup");
        const soundOptions = document.querySelectorAll(".sound-option");

        let currentSound = null;
        let currentAudio = null;
        let isPopupVisible = false;

        audioIcon.addEventListener("click", function(e) {
            e.stopPropagation();
            isPopupVisible = !isPopupVisible;
            popup.style.display = isPopupVisible ? "block" : "none";
        });

        // Close popup when clicking outside
        document.addEventListener("click", function(e) {
            if (!popup.contains(e.target) && e.target !== audioIcon && isPopupVisible) {
                isPopupVisible = false;
                popup.style.display = "none";
            }
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
                        currentAudio = new Audio(contextPath + "/sounds/" + soundFile);
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

        // Initialize
        setTimeForMode("focus");
        document.getElementById("focusBtn").classList.add("active");
    });
  </script>
</body>
</html>