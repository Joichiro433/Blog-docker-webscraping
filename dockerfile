FROM python:3.9.12

RUN apt update && apt install -y \
    sudo \
    wget \
    curl \
    htop \
    vim \
    git \
    gnupg \
    unzip \
    tzdata \
    locales && \
    locale-gen ja_JP.UTF-8

# google-chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable

# ChromeDriver
ADD https://chromedriver.storage.googleapis.com/101.0.4951.41/chromedriver_linux64.zip /opt/chrome/
RUN cd /opt/chrome/ && \
    unzip chromedriver_linux64.zip

# python package
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r  requirements.txt

# vim setting
RUN echo '\n\
    set fenc=utf-8\n\
    set encoding=utf-8\n\
    set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8\n\
    set fileformats=unix,dos,mac\n\
    syntax on' >> /root/.vimrc

WORKDIR /app
COPY main.py .

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/chrome
ENV TZ Asia/Tokyo
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja