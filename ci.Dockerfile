FROM python:3.11-slim-bullseye@sha256:9e25f400253a5fa3191813d6a67eb801ca1e6f012b3bd2588fa6920b59e3eba6

ENV BUILD_DEPENDENCIES="build-essential git curl file sudo"
ARG SUDO_FORCE_REMOVE="yes"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"

COPY requirements.txt /tmp/

RUN apt update \
    && apt install -y --no-install-recommends $BUILD_DEPENDENCIES \
    \
    # mecab
    && mkdir -p /tmp/mecab \
    && cd /tmp/mecab \
    && git clone https://github.com/taku910/mecab . \
    && cd mecab \
    && ./configure --enable-utf8-only \
    && make \
    && make install \
    && rm -rf /tmp/mecab \
    \
    # mecab-ipadic-neologd
    && mkdir -p /tmp/mecab-ipadic-neologd \
    && cd /tmp/mecab-ipadic-neologd \
    && git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd . \
    && ./bin/install-mecab-ipadic-neologd \
        -n \
        -y \
        --install_adjective_exp \
        --install_infreq_datetime \
        --install_infreq_quantity \
    && rm -rf /tmp/mecab-ipadic-neologd \
    \
    # pip
    && cd /tmp \
    && python -m pip install --upgrade pip \
    && pip install --no-cache-dir \
        -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt \
    \
    ## Cleanup
    && apt purge -y $BUILD_DEPENDENCIES \
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists

WORKDIR /app
RUN mkdir dist

COPY testMecab.py fetchTweets.py generateModel.py /app/

ARG MECAB_DICTIONARY_PATH="/usr/local/lib/mecab/dic/mecab-ipadic-neologd"
ARG USERS="samekan822"
ARG TWITTER_CK
ARG TWITTER_CS
ARG TWITTER_AT
ARG TWITTER_ATS
RUN python testMecab.py

ADD https://www.randomnumberapi.com/api/v1.0/random /tmp/cacheburst
RUN python fetchTweets.py \
    && python generateModel.py \
    && rm /tmp/cacheburst

COPY . /app/
EXPOSE 5000
ENV FLASK_APP=index.py
ENTRYPOINT ["flask", "run", "--host", "0.0.0.0"]
