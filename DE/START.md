# Lokale KI: Quellenvergleich zum Selbermachen

Backend-Zuordnung: Strix Halo nutzt in unserer llama.cpp-Reihe Vulkan; RTX 3080 Ti und RTX 3090 Ti nutzen den CUDA-Weg. Die Firmenübung verwendet deinen vorhandenen Chat/API-Server und wechselt kein Backend.

## Anfängerweg ohne vorausgesetzten Agenten
1. Deinen funktionierenden lokalen Chat verwenden. Neue Basis: [AMD/Vulkan- oder NVIDIA/CUDA-Anleitung passend zum Rechner](https://github.com/dolmario/llama-cpp-vulkan-tutorial). Diese Übung installiert weder Modell noch Firmensystem. Die Dateien sind neue synthetische Lernaufgaben, keine Reproduktion des alten Benchmarks.
2. Modellname, Version, Quantisierung und Einstellungen in AUSWERTUNG.csv notieren. Keine echten Kundendaten nötig.
3. Bedingung A: neuer Chat; 01-OHNE-QUELLEN.txt einfügen. Keine FAKTEN-Dateien mitgeben. Antworten selbst speichern. T1/T2/T3/T4/T6 brauchen unbekannte Firmenfakten; T5 ist ohne Firmenwissen rechenbar.
4. Bedingung B: wieder neuer Chat, gleiches Modell; 02-MIT-EINGEFUEGTEN-QUELLEN.txt einfügen. Darin stehen beide kurzen Quelldateien mit Namen und Version. Dieser Weg benötigt keine Dateiwerkzeuge. Er beweist weder funktionierendes MCP/RAG noch Rechteabschottung.
5. Belege in FAKTEN selbst kontrollieren: Version 3 ersetzt Version 1; 90 W statt 120 W. Dienstag 18:00–19:00. IT-Labor ist eine Rolle, kein persönlicher Name. Exakter CPU-Typ fehlt. 90×8/1000 = 0,72 kWh ist theoretisch, keine Messung.
6. Jede Bedingung dreimal mit frischem Chat. Tatsächliche Antworten, Beleg/Version, Nicht-Raten, Zeit und Fehler getrennt erfassen. ERWARTUNGEN.md erst danach vergleichen. Keine fehlgeschlagenen Durchgänge entfernen.
7. Optional vorhandener Agent: nur FAKTEN freigeben, echten Toolaufruf prüfen. Promptgrenzen allein sind keine Berechtigungssperre. Angeführte Dateinamen allein beweisen keinen Dateizugriff.

## Optionaler vorhandener Loopback-Server
TEST-VERBINDUNG.ps1 -BaseUrl http://127.0.0.1:8091 liest nur /v1/models. Die API-Übung darunter sendet echte Modellanfragen. Sie benutzt neuen Kontext je Frage, temperature 0, max_tokens 512, keine Werkzeuge. B fügt Quellen als Text ein. Vorher freie Ressourcen prüfen; genaue Modell-ID aus deinem Server verwenden. Vorhandene Authentifizierung wird beibehalten; Token wird erst im echten Lauf verdeckt abgefragt, nicht in Ergebnisdateien gespeichert.

Nur Anfragen VORBEREITEN, kein Netzwerk und keine Inferenz:
    .\MITMACH-TEST.ps1 -Model "lokales-modell" -Language de -OutputDirectory "C:\dein\Kestrel-Vorbereitung" -PrepareOnly

Echte Versuche nach eigener Ressourcenprüfung, ausdrücklich START eingeben:
    .\MITMACH-TEST.ps1 -Model "lokales-modell" -Language de -BaseUrl http://127.0.0.1:8091 -OutputDirectory "C:\dein\Kestrel-Ergebnisse"

OutputDirectory muss neu sein. REQUESTS.json sind Anfragen, STATE.json kennzeichnet Vorbereitungsmodus oder echte Versuche. RESPONSES.ndjson entsteht nur im echten Lauf; Antworten/Fehler/Zeit werden erhalten. Keine erfundenen Scores; Belege selbst beurteilen. Erster Fehler stoppt ohne automatische Wiederholung oder Serverneustart. Drei Durchgänge mit sechs Fragen in A/B ergeben 36 echte Anfragen. Nur einen Durchgang: -Runs 1. Laufzeit/Funktionsfähigkeit sind bislang NICHT auf einem echten Modellserver getestet; der gesonderte PrepareOnly-Test beweist nur die Anfragenvorbereitung.

## Grenze des Vergleichs
Ollama/LM Studio können selbst Werkzeuge anbinden. Verglichen werden Bedingungen, nicht ein grundsätzliches Produktverbot. Der alte EVO-Benchmark bleibt ein eigener Archivbefund mit anderer Aufgabenfamilie. Diese Anleitung enthält keine Produktionsfreigabe. Quellenpflege, technische Ordnerrechte, Protokolle, Verantwortliche und betriebliche Prüfung sind eigene Aufgaben; CHECKLISTE.md ausfüllen.
