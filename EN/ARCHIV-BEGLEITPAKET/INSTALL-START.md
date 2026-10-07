# Installation and start: check your own local setup

1. If you already have a local model server, use it. These files automatically install and start nothing.
2. For a new setup, read Ollama or LM Studio’s original instructions (SOURCES.txt), install the appropriate release and deliberately choose a locally hosted model appropriate for your hardware and license. No model size or memory fit is guaranteed here. Do not select a cloud model for this exercise.
3. In LM Studio, start the localhost server from the Developer tab. Ollama’s local API normally uses port 11434, with OpenAI-compatible endpoints under /v1. Keep documented authentication.
4. TEST-VERBINDUNG.ps1 only lists models from an already running loopback server: default LM Studio 1234; for Ollama use -BaseUrl http://127.0.0.1:11434. It loads no model and does not test the complete system shown in the film.
5. Source access needs your agent’s existing file/wiki/RAG integration. Expose only FAKTEN. Setup depends on the chosen program; these worksheets install neither OpenCode nor MCP nor a complete business system.
6. No fresh installation or script execution was performed for this new exercise package. Read the PowerShell script before using it; no global ExecutionPolicy change is required.
