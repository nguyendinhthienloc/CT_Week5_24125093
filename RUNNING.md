# Running the project (frontend + translation backend)

This document explains how to run the frontend (static `index.html`) and the translation backend shipped in `backend/` on Windows (PowerShell). The instructions assume you are in the repository root: `D:\Github Projects\CT_Website`.

Prerequisites
- Python 3.8+ installed and available as `python` in PATH.
- Internet access (for installing packages and for translation fallbacks).

1) Start the backend

Two helper scripts are provided: Windows PowerShell (`backend/run_backend.ps1`) and POSIX shell (`backend/run_backend.sh`). Both create a `.venv`, install dependencies, and run the Flask app.

Windows (PowerShell)

```powershell
cd 'D:\Github Projects\CT_Website\backend'
.\run_backend.ps1
```

POSIX (Linux / macOS / Codespaces terminal)

```bash
cd /workspaces/CT_Website/backend    # adjust path inside Codespaces or your workspace
chmod +x ./run_backend.sh
./run_backend.sh
```

Notes
- The helpers create a virtual environment at `backend/.venv` and install the packages from `backend/requirements.txt`.
- The backend runs on `http://0.0.0.0:5001/` (health) and `http://0.0.0.0:5001/translate` (POST API).

Health check (curl / PowerShell)

```bash
# curl example
curl http://localhost:5001/

# PowerShell example
Invoke-RestMethod -Uri http://localhost:5001/ -Method GET
```

Quick server-side test (curl / PowerShell):

```bash
curl -s -X POST http://localhost:5001/translate -H 'Content-Type: application/json' -d '{"text":"Hello"}'
```

```powershell
Invoke-RestMethod -Uri http://localhost:5001/translate -Method POST -Body (ConvertTo-Json @{ text = 'Hello' }) -ContentType 'application/json'
```

Successful response will be JSON containing `translated` text. The backend first attempts `googletrans` and then falls back to public endpoints if needed.

2) Serve the frontend (simple static server)

Do not open `index.html` directly with `file://` — use a static server so fetch/XHR requests to the backend work.

From the repository root, run a simple Python static server:

```powershell
cd 'D:\Github Projects\CT_Website'
python -m http.server 8000
```

- Open `http://localhost:8000/index.html` in your browser.

3) Translate from the UI

- In the page, locate the "Dịch nhanh (English → Tiếng Việt)" box.
- Enter English text and click `Dịch`.
- The frontend will POST to `http://localhost:5001/translate` and display the translated Vietnamese text.

Troubleshooting
- If the UI shows an error like `Unexpected token '<'`, this usually means the frontend requested the wrong port and received HTML (an HTML page) instead of JSON. Make sure the backend URL configured in `index.html` matches the running backend (`http://localhost:5001/translate`).
- If you see an error about `TKK token` or `googletrans` failing, the backend will automatically try LibreTranslate (no API key required). If both fail, check your internet connection and retry.
- If port 5001 is in use, either stop the process using it or edit `backend/app.py` to use another port and restart the backend.

Notes & alternatives
- `googletrans` is an unofficial wrapper and may break occasionally. The backend includes a fallback to a public LibreTranslate instance to keep the feature working without extra setup.
- For production or heavy usage, consider Google Cloud Translation (paid) or self-hosting LibreTranslate. If you want, I can add an option to configure Google Cloud credentials and use the official client. That requires creating a Google Cloud project and enabling the Cloud Translation API; you'll need an API key or service account JSON.

Stopping services
- Backend: in the PowerShell window running `run_backend.ps1` press `Ctrl+C` to stop the Flask server.
- Frontend static server: press `Ctrl+C` in the PowerShell window running `python -m http.server 8000`.

If you want, I can also:
- Add a one-line `run_all.ps1` that starts both servers in background and opens the browser, or
- Replace `googletrans` with Google Cloud Translate (I'll implement and document the required GCP steps).

Happy testing — tell me if you want the Google Cloud Translate integration added.