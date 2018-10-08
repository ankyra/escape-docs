#!/bin/bash -e

DEPS="deps/heist/escape-integration-tests/deps"

rm -rf content/docs/reference/
mkdir -p content/docs/reference/

cp -r ${DEPS}/_/escape/docs/cmd/*.md content/docs/reference

cp ${DEPS}/_/escape/docs/generated/*.md content/docs/reference/
cp ${DEPS}/_/escape-core/docs/generated/*.md content/docs/reference/
cp ${DEPS}/_/escape-core/docs/*.md content/docs/reference/
cp ${DEPS}/_/escape-inventory/docs/*.md content/docs/reference/

PACKAGE_NAME="escape-docs"
DOCKER_PACKAGE_PATH="/src/${PACKAGE_NAME}"
DOCKER_PACKAGE_PARENT_PATH=$(dirname "${DOCKER_PACKAGE_PATH}")
DOCKER_IMAGE="ankyra/escape-nodejs:latest"
VOLUME_NAME="src$$"

cleanup_docker() {
    echo "Removing Docker data volume ${VOLUME_NAME}..."
    docker volume rm -f ${VOLUME_NAME} || true
}

prepare_volume() {
    echo "Preparing Docker data volume..."
    docker create -v "${DOCKER_PACKAGE_PARENT_PATH}" --name "${VOLUME_NAME}" "${DOCKER_IMAGE}" mkdir /code 1>/dev/null 2>&1
    docker_run "/" "mkdir -p ${DOCKER_PACKAGE_PATH}"

    find "$(realpath `pwd`)"  -maxdepth 1 -mindepth 1 -type d \! -name '.*' | while read line ; do
        to="${DOCKER_PACKAGE_PATH}/$(basename $line)"
        echo "Copying $line to $to"
        docker cp "${line}" "${VOLUME_NAME}:${to}" 1>/dev/null
    done
    docker cp "config.toml" "${VOLUME_NAME}:${DOCKER_PACKAGE_PATH}" 1>/dev/null
}

docker_run() {
    local cwd=$1
    local cmd=$2
    echo "Running '${cmd}' in Docker directory '${cwd}' (image ${DOCKER_IMAGE}):"
    local dockerCmd="docker run --rm --volumes-from ${VOLUME_NAME} -w '$cwd'"
    for var in $(env) ; do 
        if [[ $var == INPUT_* ]] || [[ $var == OUTPUT_* ]] || [[ $var == METADATA_* ]] ; then
          arrIN=(${var//=/ })
          if [ "${arrIN[1]+set}" == "set" ] ; then
              dockerCmd="$dockerCmd -e \"${var}\""
          fi
        fi
    done
    cmd=${cmd//\'/'"'"'"'"'}
    dockerCmd="$dockerCmd --entrypoint /bin/sh ${DOCKER_IMAGE} -c '$cmd'"
    eval $dockerCmd
}

main() {
    cleanup_docker
    prepare_volume 
    docker_run "${DOCKER_PACKAGE_PATH}" "sh -c 'apt-get install curl && curl -L -o hugo.deb https://github.com/gohugoio/hugo/releases/download/v0.22/hugo_0.22_Linux-64bit.deb && dpkg -i hugo.deb && npm -g config set user root && npm install -g hugulp@1.3.0 && hugulp build'"
    rm -rf public/
    docker cp "${VOLUME_NAME}:${DOCKER_PACKAGE_PATH}/public" "public/"
}

trap cleanup_docker EXIT
main
