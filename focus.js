document.addEventListener("DOMContentLoaded", function () {
    // === Timer logic ===
    let timer;
    let isRunning = false;
    let currentMode = "focus";
    let timeLeft = 0;
    let cycleCount = 0;

    const modeDurations = {
        focus: 1 * 60,
        short: 2 * 60,
        long: 3 * 60
    };

    const sound = new Audio("sounds/bell.mp3");

    const timeDisplay = document.getElementById("time");
    const startPauseBtn = document.getElementById("startPause");
    const resetBtn = document.getElementById("reset");
    // const pipBtn = document.getElementById("pip");

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
    }

    function updateTimeDisplay() {
        timeDisplay.textContent = formatTime(timeLeft);
    }

    function startTimer() {
        if (isRunning) return;
        isRunning = true;
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
    }

    function resetTimer() {
        setTimeForMode(currentMode);
    }

    function autoSwitch() {
        if (currentMode === "focus") {
            cycleCount++;
            setTimeForMode("short");
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

    // // PiP functionality
    // pipBtn.addEventListener("click", async () => {
    //     try {
    //         const video = document.createElement("video");
    //         video.srcObject = await navigator.mediaDevices.getDisplayMedia({ video: true });
    //         video.play();
    //         document.body.appendChild(video);
    //         await video.requestPictureInPicture();
    //     } catch (error) {
    //         console.error("PiP error:", error);
    //     }
    // });

    setTimeForMode("focus");

    // === Audio logic ===
    const audioIcon = document.getElementById("audio-btn");
    const modal = document.getElementById("sound-modal");
    const closeModal = document.getElementById("close-sound-modal");
    const soundOptions = document.querySelectorAll(".sound-option");

    let currentSound = null;
    let currentAudio = null;

    audioIcon.addEventListener("click", () => {
        modal.style.display = "block";
    });

    closeModal.addEventListener("click", () => {
        modal.style.display = "none";
    });

    window.addEventListener("click", (e) => {
        if (e.target === modal) {
            modal.style.display = "none";
        }
    });

    soundOptions.forEach(option => {
        option.addEventListener("click", () => {
            const soundFile = option.dataset.sound;

            if (currentSound === soundFile) {
                currentAudio.pause();
                currentAudio.currentTime = 0;
                currentSound = null;
                option.classList.remove("active");
            } else {
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
});
