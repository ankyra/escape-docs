clean:
	rm -rf public staging static

serve: clean
	hugulp watch

build: clean
	hugulp build

dev: clean
	escape run build && hugulp watch
