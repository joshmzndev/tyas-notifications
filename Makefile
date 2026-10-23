.PHONY: help install run dev stop clean

help:
	@echo "Available commands:"
	@echo "  make install    - Install dependencies including gunicorn"
	@echo "  make run        - Run the app with gunicorn (production)"
	@echo "  make dev        - Run the app with Flask development server"
	@echo "  make stop       - Stop any running gunicorn processes"
	@echo "  make clean      - Clean up Python cache files"

install:
	pip install -r requirements.txt
	pip install gunicorn

run:
	gunicorn -w 4 -b 0.0.0.0:5000 --timeout 120 --access-logfile - --error-logfile - app:app

dev:
	python app.py

stop:
	@pkill -f gunicorn || echo "No gunicorn processes found"

clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
