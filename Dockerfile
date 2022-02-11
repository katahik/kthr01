# ベースのイメージを指定
FROM ruby:2.7

# 必要なライブラリをインストール(node.jsとyarnをインストール)※JavaScript関連
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn
# 作業ディレクトリを/appディレクトリとする
WORKDIR /app
# ローカルのsrcをコンテナの/appディレクトリにコピーする
COPY ./src /app
# gemのインストール※Ruby関連
RUN bundle config --local set path 'vendor/bundle' \
  && bundle install