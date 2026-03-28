# eval-models# Codespace: LLM & Systems Lab 🚀

This workspace is configured for local LLM inference using `llama.cpp` and development in Python and Rust.

## 🛠 Tech Stack
- **OS:** Linux (GitHub Codespaces)
- **RAM:** 16GB (14GB Available)
- **Storage:** 32GB (20GB Available)
- **Core Tools:** `llama.cpp`, `Python 3.x`, `Rust/Cargo`

## 🦙 Running the Reasoning Model
This Codespace is currently optimized for **Qwen3.5-4B-Claude-Opus-Reasoning**. This model uses distilled reasoning patterns from Claude 4.6 Opus.

### Start Interactive Chat
```bash
./llama.cpp/build/bin/llama-cli \
  -hf Jackrong/Qwen3.5-4B-Claude-4.6-Opus-Reasoning-Distilled-v2-GGUF:Qwen3.5-4B.Q5_K_M.gguf \
  -cnv --color -t $(nproc) -c 16384