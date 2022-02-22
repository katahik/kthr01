# ベースのイメージを指定
FROM ruby:2.7

# TODO:development環境の対応を考えること
# 環境変数設定
ENV RAILS_ENV=production

# 必要なライブラリをインストール(node.jsとyarnをインストール)※JavaScript関連
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn \
  && apt-get install -y vim
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
