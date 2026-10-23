# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A simple Flask-based real-time notification system with separate sender and receiver web interfaces. The system broadcasts notifications to all connected receivers with audio alerts (plays 3 times). Uses polling (2-second intervals) rather than WebSockets for simplicity.

## Development Commands

### Setup
```bash
pip install -r requirements.txt
```

### Running the Application
```bash
python app.py
```
Server starts at `http://0.0.0.0:5000`

Note: The app runs with `debug=False` by default (production setting).

### Required Assets
The system requires `notification.mp3` in the `static/` directory. This file must be manually added and is not tracked in git.

## Architecture

### Backend (app.py)
- Single Flask application with CORS enabled
- In-memory storage only (no database/persistence)
- Global `latest_notification` dict stores single most recent notification with message and ISO timestamp
- No authentication or authorization

### API Endpoints
- `POST /api/send`: Accepts `{"message": "text"}`, updates global state, returns success
- `GET /api/check`: Returns notification if timestamp > `last_check` query param, otherwise `has_notification: false`
- `GET /sender`: Renders sender interface
- `GET /receiver`: Renders receiver interface

### Frontend Templates
Both templates are self-contained with inline CSS and JavaScript (no build step).

**sender.html**
- Simple form to POST notifications to `/api/send`
- Displays success/error messages with 4-second timeout
- Prevents submission while request in flight

**receiver.html**
- Polls `/api/check` every 2 seconds
- Tracks `lastCheck` timestamp in localStorage to persist across page refreshes and avoid re-processing same notification
- Audio playback requires initial user interaction (click anywhere on page)
- Plays audio 3 times sequentially using Promise-based async playback
- Shows notification message with timestamp when received
- HTML escape function prevents XSS
- "Test Audio" button plays notification sound 3 times to verify audio is working
- "Acknowledge & Stop Sound" button stops repeating audio alerts (plays every 30 seconds until acknowledged)
- Acknowledged state persists until new notification arrives
- Clock display shows current time in HH:MM:SS format
- Link to PTC schedule (Google Sheets)

## Key Behaviors
- Only ONE notification stored at a time (new notifications overwrite old)
- ALL receivers get the SAME notification (broadcast model)
- Audio must be user-activated first due to browser autoplay policies
- Receiver works even when browser tab is not focused
- No notification history or persistence on server
- Last checked timestamp persists in browser localStorage to prevent showing old notifications after page refresh
- Audio repeats every 30 seconds until user acknowledges the notification
- Professional "Acknowledge & Stop Sound" button with clean styling (no pulsing animation)
