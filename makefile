PORT=8000

all:
	./build-html.sh

server:
	@echo "http://localhost:$(PORT)/"
	python -m SimpleHTTPServer $(PORT)

preview: all 
	@eval "sleep 1; open http://localhost:$(PORT)/" &
	python -m SimpleHTTPServer $(PORT)

.PHONY: server all preview
