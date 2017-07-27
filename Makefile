clean:
	rm -rf public staging static

serve: clean
	hugulp watch

build: clean
	hugulp build
