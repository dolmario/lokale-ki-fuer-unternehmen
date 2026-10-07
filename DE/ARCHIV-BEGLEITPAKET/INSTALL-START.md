# Installation und Start: eigene lokale Basis prüfen

1. Wenn du bereits einen lokalen Modellserver hast, verwende ihn. Diese Dateien starten und installieren nichts automatisch.
2. Für eine neue Basis lies die Originalanleitung von Ollama oder LM Studio (Links in SOURCES.txt), installiere die passende Ausgabe und lade bewusst ein hardware- und lizenzgeeignetes lokales Modell. Keine konkrete Modellgröße oder Speicherpassung wird hier garantiert. Kein Cloudmodell für diese Übung auswählen.
3. In LM Studio im Developer-Tab den Server auf localhost starten. Ollama stellt die lokale API normalerweise auf Port 11434 bereit; OpenAI-kompatibel unter /v1. Dokumentierte Authentifizierung beibehalten.
4. TEST-VERBINDUNG.ps1 liest nur die Modellliste eines bereits laufenden Loopback-Servers: Standard LM Studio 1234, für Ollama -BaseUrl http://127.0.0.1:11434. Der Test lädt kein Modell und ist kein Test des im Video gezeigten gesamten Serveraufbaus.
5. Für Quellenzugriff benötigst du eine bereits eingerichtete Datei-/Wiki-/RAG-Anbindung deines Agenten. Binde nur FAKTEN ein. Wie das eingerichtet wird, hängt vom ausgewählten Programm ab; diese Arbeitsblätter installieren weder OpenCode noch MCP oder ein vollständiges Firmensystem.
6. Neuinstallation und Skriptlauf wurden für dieses neue Übungspaket nicht ausgeführt. PowerShell-Skript vor Nutzung lesen; keine globale ExecutionPolicy-Abschaltung erforderlich.
