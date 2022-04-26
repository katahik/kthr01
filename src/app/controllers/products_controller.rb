class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  # GET /products or /products.json
  def index
    # @products = Product.all


    # 配列の初期化
    sample_array = []
    # 変数の初期化
    input_txt = ""

    # sample_arrayの中に100000個の配列を作成
    100000.times do |i|
      sample_array << i
    end

    # 配列から一つ一つ取り出して、input_txtに文字列として結合して、入れていく
    # \nは改行文字を出力するためのエスケープシーケンス
    # こんな感じ "0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n"
    sample_array.each do |i|
      input_txt += i.to_s + "\n"
    end

    ## ファイルの作成
    # ファイルパス + 乱数発生器(16進数)+拡張子,新規書き込み
    File::open('./app/tmp/' + SecureRandom.hex(8) + '.txt', 'w') do |file|
      # 新規作成したファイルの中身に生成した文字列を格納する
      file.puts(input_txt)
    end
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :price, :vendor)
  end
end
