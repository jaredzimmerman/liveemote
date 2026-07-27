PYTHON ?= python
CHARACTER ?= ./character_input
VOICE_BACKEND ?= luxtts
RENDERER ?= livetalking
AGENT_MODE ?= fake
HOST ?= 127.0.0.1
PORT ?= 8080

# Runtime dependencies only, without the vendor clones and model downloads that
# `setup` performs. Enough to import the package and serve the demo.
install:
	$(PYTHON) -m pip install -e .

# Import check: verifies the package and the FastAPI app factory both load.
build:
	$(PYTHON) -c "import hermes_avatar; from apps.demo_server.main import create_app; print('ok')"

# Serve the demo on an externally reachable interface. Startup blocks for up to
# ~30s while the renderer probes LiveTalking; it then logs "renderer backend
# offline" and serves in passthrough mode, which is the expected headless path.
preview:
	$(PYTHON) -m apps.demo_server.main --host 0.0.0.0 --port $(PORT) --character $(CHARACTER) --renderer $(RENDERER) --voice-backend none --agent-mode offline

setup:
	$(PYTHON) -m pip install -e ".[test]"
	mkdir -p vendor cache/voice
	$(PYTHON) scripts/create_sample_character.py --character $(CHARACTER)
	@test -d vendor/LiveTalking || git clone --depth 1 https://github.com/lipku/LiveTalking.git vendor/LiveTalking
	@test -d vendor/Deep-Live-Cam || git clone --depth 1 https://github.com/hacksider/Deep-Live-Cam.git vendor/Deep-Live-Cam
	@test -d vendor/LuxTTS || git clone --depth 1 https://github.com/ysharma3501/LuxTTS.git vendor/LuxTTS
	@test -d vendor/MOSS-TTS || git clone --depth 1 https://github.com/OpenMOSS/MOSS-TTS.git vendor/MOSS-TTS
	$(PYTHON) scripts/setup_deeplivecam_models.py

demo:
	$(PYTHON) -m apps.demo_server.main --character $(CHARACTER) --renderer $(RENDERER) --voice-backend $(VOICE_BACKEND) --agent-mode $(AGENT_MODE)

demo-fake-hermes:
	$(PYTHON) -m apps.demo_server.main --character $(CHARACTER) --renderer $(RENDERER) --voice-backend $(VOICE_BACKEND) --agent-mode fake

deeplivecam-models:
	mkdir -p vendor
	@test -d vendor/Deep-Live-Cam || git clone --depth 1 https://github.com/hacksider/Deep-Live-Cam.git vendor/Deep-Live-Cam
	$(PYTHON) scripts/setup_deeplivecam_models.py

check-deeplivecam-models:
	$(PYTHON) scripts/setup_deeplivecam_models.py --check-only

test:
	$(PYTHON) scripts/create_sample_character.py --character ./character_input
	$(PYTHON) -m pytest

push-check:
	$(PYTHON) scripts/check_push_ready.py
