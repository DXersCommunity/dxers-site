FROM klakegg/hugo:ext-nodejs
WORKDIR /home/docsy/app
RUN mkdir -p /home/docsy/deps
COPY package.json /home/docsy/deps/
COPY package-lock.json /home/docsy/deps/
RUN cd /home/docsy/deps/ && npm install -g
# Go is required to resolve Docsy's Hugo Module dependencies (Bootstrap,
# Font Awesome) via `hugo mod tidy`. The klakegg/hugo base image does not
# include Go, so it's installed explicitly here.
# NOTE: could not be tested in this environment (no Docker daemon available
# in the sandbox) — verify with `docker build -f dev.Dockerfile .` before
# relying on it, and re-check the Alpine `go` package version satisfies
# Hugo Modules' requirements.
RUN apk add --no-cache go
# COPY . .
CMD [ "server" ]
