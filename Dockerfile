FROM pritunl/archlinux

ENV NVM_VERSION "v0.33.6"

RUN pacman -Syy --noconfirm git wget npm python2 make gcc bc && \
    pacman -Scc --noconfirm && \
    ln -s /usr/sbin/python2 /usr/sbin/python && \
    ln -s /usr/sbin/python2-config /usr/sbin/python-config && \
    npm install -g lumo-cljs --unsafe-perm && \
    wget -qO- "https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh" | bash && \
    mkdir /root/closh

WORKDIR /root/closh

COPY bin bin
COPY src src
COPY test test
COPY package.json .
COPY package-lock.json .
COPY test.cljs .

RUN . "$HOME/.nvm/nvm.sh" && \
    nvm install $(lumo -e '(println process.version)') && \
    npm install

CMD ["/usr/sbin/npm", "run", "start"]
