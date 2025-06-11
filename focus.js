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

    const sound = new Audio("sounds/bell.mp3");

    const timeDisplay = document.getElementById("time");
    const startPauseBtn = document.getElementById("startPause");
    const resetBtn = document.getElementById("reset");

    function formatTime(seconds) {
        const mins = String(Math.floor(seconds / 60)).padStart(2, "0");
        const secs = String(seconds % 60).padStart(2, "0");
        return `${mins}:${secs}`;
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
        timer = setInterval(() => {
            if (timeLeft > 0) {
                timeLeft--;
                updateTimeDisplay();
            } else {
                sound.play();
                stopTimer();
                autoSwitch();
            }
        }, 1000);
    }

    function stopTimer() {
        clearInterval(timer);
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

    startPauseBtn.addEventListener("click", () => {
        if (isRunning) {
            stopTimer();
        } else {
            startTimer();
        }
    });

    resetBtn.addEventListener("click", () => {
        resetTimer();
    });

    document.querySelectorAll(".modes button").forEach((btn, i) => {
        btn.addEventListener("click", () => {
            const modes = ["focus", "short", "long"];
            setTimeForMode(modes[i]);
            document.querySelectorAll(".modes button").forEach(b => b.classList.remove("active"));
            btn.classList.add("active");
        });
    });

    // === Audio popup logic ===
    const audioIcon = document.getElementById("audio-btn");
    const popup = document.getElementById("sound-popup");
    const soundOptions = document.querySelectorAll(".sound-option");

    let currentSound = null;
    let currentAudio = null;
    let isPopupVisible = false;

    audioIcon.addEventListener("click", (e) => {
        e.stopPropagation();
        isPopupVisible = !isPopupVisible;
        popup.style.display = isPopupVisible ? "block" : "none";
    });

    // Close popup when clicking outside
    document.addEventListener("click", (e) => {
        if (!popup.contains(e.target) && e.target !== audioIcon && isPopupVisible) {
            isPopupVisible = false;
            popup.style.display = "none";
        }
    });

    soundOptions.forEach(option => {
        option.addEventListener("click", (e) => {
            e.stopPropagation();
            const soundFile = option.dataset.sound;

            if (currentSound === soundFile) {
                // Stop current sound
                if (currentAudio) {
                    currentAudio.pause();
                    currentAudio.currentTime = 0;
                }
                currentSound = null;
                option.classList.remove("active");
            } else {
                // Stop previous sound and start new one
                if (currentAudio) {
                    currentAudio.pause();
                    document.querySelector(".sound-option.active")?.classList.remove("active");
                }
                
                currentAudio = new Audio(`sounds/${soundFile}`);
                currentAudio.loop = true;
                currentAudio.play();
                currentSound = soundFile;
                option.classList.add("active");
            }
        });
    });

    // Initialize
    setTimeForMode("focus");
    document.getElementById("focusBtn").classList.add("active");
});