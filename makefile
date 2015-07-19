PORT=8000

server:
	@echo "http://localhost:$(PORT)/"
	python -m SimpleHTTPServer $(PORT)


.PHONY: server
