clean:
	rm -rf public staging static

serve: clean
	hugulp watch

build: clean
	hugulp build

local_release_dev_depends:
	cd ../stdlib/ && escape run release -f && cd -
	cd ../extension-docker/ && escape run release -f && cd -
	cd ../extension-docker/ && escape run release -f && cd -
	cd ../extension-kubespec/ && escape run release -f && cd -
	cd ../extension-docker-kubespec/ && escape run release -f && cd -
	cd $(realpath ../escape-integration-tests/) && escape run release -f && cd -

dev: clean
	escape run build && hugulp watch
