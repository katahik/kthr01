# ベースのイメージを指定
FROM ruby:2.7

# 環境変数設定
# デフォルトはdevelopmentを指定
ARG RAILS_ENV=development
ENV RAILS_ENV $RAILS_ENV

## nodejsとyarnはwebpackをインストールする際に必要
# yarnパッケージ管理ツールをインストール
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

# 作業ディレクトリを/appディレクトリとする
WORKDIR /app
# ローカルのsrcをコンテナの/appディレクトリにコピーする
COPY ./src /app
# gemのインストール※Ruby関連
RUN bundle config --local set path 'vendor/bundle' \
  && bundle install

# start.shを実行
COPY start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["sh", "/start.sh"]
