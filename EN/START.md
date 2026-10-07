# Local AI: a source comparison you can run yourself

## Beginner path without assuming an agent
1. Use your working local chat. For a new basis: [our Vulkan tutorial](https://github.com/dolmario/llama-cpp-vulkan-tutorial). This exercise installs neither a model nor a company system. These are new synthetic learning tasks, not a reproduction of the earlier benchmark.
2. Record model name, version, quantization and settings in AUSWERTUNG.csv. No actual customer data needed.
3. Condition A: new chat; paste 01-OHNE-QUELLEN.txt without FAKTEN files. Save actual answers. T1/T2/T3/T4/T6 depend on unknown business facts; T5 is calculable without business knowledge.
4. Condition B: another fresh chat, same model; paste 02-MIT-EINGEFUEGTEN-QUELLEN.txt. It includes both short sources with filenames and versions. This path requires no file tools. It proves neither working MCP/RAG nor access restrictions.
5. Check evidence yourself in FAKTEN: version 3 supersedes version 1; 90 W instead of 120 W. Tuesday 18:00–19:00. IT laboratory is a role, not a named person. Exact CPU is absent. 90×8/1000 = 0.72 kWh is theoretical, not measured.
6. Repeat each condition three times with fresh chats. Record actual answers, citation/version, avoiding guesses, duration and errors separately. Read ERWARTUNGEN.md afterwards. Preserve failed repetitions.
7. Optional existing agent: permit only FAKTEN and check actual tool logs. Prompt instructions alone do not enforce permissions. Cited filenames alone do not prove file access.

## Optional existing loopback server
TEST-VERBINDUNG.ps1 -BaseUrl http://127.0.0.1:8091 only reads /v1/models. The exercise below makes actual model requests with new context per question, temperature 0, max_tokens 512 and no tools. B pastes source text. Check available resources first and use your server's exact model ID. Existing authentication is preserved; a token is prompted securely only in real mode and is not saved in result files.

PREPARE requests only, zero network calls or inference:
    .\MITMACH-TEST.ps1 -Model "lokales-modell" -Language en -OutputDirectory "C:\your\Kestrel-Preparation" -PrepareOnly

Actual attempts after checking resources yourself, explicitly type START:
    .\MITMACH-TEST.ps1 -Model "lokales-modell" -Language en -BaseUrl http://127.0.0.1:8091 -OutputDirectory "C:\your\Kestrel-Results"

OutputDirectory must be new. REQUESTS.json contains requests; STATE.json distinguishes preparation from actual attempts. RESPONSES.ndjson is created only in actual mode and preserves answers/errors/durations. No invented scores; assess evidence yourself. First error stops without automatic retry or server restart. Three repetitions of six tasks in A/B mean 36 actual requests. One repetition: -Runs 1. Runtime functionality has NOT been tested against a real model server; the separate PrepareOnly check proves request preparation only.

## Comparison boundary
Ollama/LM Studio can also connect tools. This compares conditions, not a fundamental product limitation. The older EVO benchmark remains separate archived evidence from a different task family. This guide supplies no operational approval. Source maintenance, enforced folder permissions, logs, ownership and organizational review are separate responsibilities; fill CHECKLISTE.md yourself.
