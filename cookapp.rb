require 'rubygems'
require 'bundler'
require 'digest/sha2'
require 'will_paginate/view_helpers/sinatra'
require 'will_paginate/active_record'

Bundler.require

#データベースの設定 データベースの使用する種類と使うデータベースファイル名を記述
set :database,{adapter: "sqlite3",database: "cookapp.sqlite3"}

enable :sessions

#labelの表示を変更しています
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '&lt 前へ'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '次へ &gt'


class Account < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :hashed
  validates :name, uniqueness: true,
                   length: { maximum: 6 }
  has_many :contents, dependent: :destroy
end

class Content < ActiveRecord::Base
  belongs_to :account
end

#ホームページ
get '/' do
  if session[:user_name].present?
    @login_account = Account.find_by(name: session[:user_name])
  end
  #will_pagenateで全件取得してデータの表示数を指定している
  @contents = Content.paginate(page: params[:page], per_page: 6)
  erb :index
end

#検索機能
get '/search' do
  @search = params[:search]
  #ログインしている場合はアカウントを表示させるためインスタンスに入れている
  @login_account = Account.find_by(name: session[:user_name]) if session[:user_name]
  @contents = Content.where('title like?',"%#{params[:search]}%").paginate(page: params[:page], per_page: 6)
  erb :search
end

#サインアップ画面の表示
get '/signup' do
  @signupmiss = session.delete :signupmiss
  @namemiss = session.delete :namemiss
  @nickname = session.delete :nickname
  @name_length_miss = session.delete :name_length_miss
  erb :signup
end

#サインアップ機能
post '/signup' do
  @username = params[:name]
  password = params[:password]
  confirmation = params[:confirmation]
  nickname = params[:nickname]
  
  
  if @username.present? && password.present? && confirmation.present? && nickname.present?
    if password == confirmation
      r = Random.new
      salt = Digest::SHA256.hexdigest(r.bytes(20))
      hashed = Digest::SHA256.hexdigest(password + salt)
      account = Account.new({ name: @username, hashed: hashed, salt: salt ,nickname: nickname})

      if account.save
        session[:user_name] = @username
        redirect '/'
      else 
        session[:namemiss] = @username
        session[:nickname] = nickname
        session[:signupmiss] = "その名前は使えません別の名前にしてください" if Account.find_by(name: @username).present?
        session[:name_length_miss] = " ニックネームは６文字以内にしてください" if nickname.length > 6
        redirect '/signup'
      end

    else
      session[:signupmiss] = "パスワードを間違えています"
      session[:namemiss] = @username
      session[:nickname] = nickname
      redirect '/signup'
    end
  else
    session[:signupmiss] = "すべて入力してください"
    session[:namemiss] = @username
    session[:nickname] = nickname
    redirect '/signup'
  end
end

#ログイン画面
get '/login' do
  @upmiss = session.delete :upmiss
  @namemiss = session.delete :namemiss
  erb :login
end

#ログイン機能
post '/login' do
  name = params[:name]
  password = params[:password]
  confirmation = params[:confirmation]

  #パスワードが同じでかつformに空欄がない場合
  if password == confirmation && name.present? && password.present?
    begin
      account = Account.find_by(name: name)
      salt = account.salt
      hashed = Digest::SHA256.hexdigest(password + salt)
      @account = Account.where(name: name,hashed: hashed,salt: salt)
    rescue => e
      session[:upmiss] = "ログインできませんでした"
      redirect '/login'
    end
    #アカウントがデータにあれば’/’にredirectする
    if @account
      session[:user_name] = name
      redirect '/'
    end

  end

  session[:namemiss] = name
  session[:upmiss] = "ログインできませんでした"
  redirect '/login'
end

#ログアウト画面
get '/logout' do
  erb :logout
end

#ログアウト機能
post '/logout' do
  session[:user_name] = nil
  redirect '/'
end

#フォームの表示
get '/contentform/:id' do
  @nilimgfile = session.delete :nilimgfile
  @content = session.delete :content
  @title = session.delete :title
  @account_id = params[:id]
  erb :contentform
end

#投稿をデータに保存する機能
post '/contentsave/:id' do
  begin
    
    @imgname = params[:imgfile][:filename].slice(-1,3)
    img = params[:imgfile][:tempfile]
    r = Random.new
    salt = Digest::SHA256.hexdigest(r.bytes(1))
    @imgname.insert(0,salt)
    File.open("./public/img/#{@imgname}",'wb') do |i|
      i.write(img.read)
    end
    @content = Content.new({post_content: params[:content],account_id: params[:id],imgfile: @imgname,title: params[:title]})

  rescue => e
    session[:nilimgfile] = "画像は必ず選択してください"
    session[:content] = params[:content]
    session[:title] = params[:title]
    redirect "contentform/#{params[:id]}"
  end

  if @content.save
    redirect '/'
  else
    redirect '/contect_form'
  end
end

#ログインしている自身のアカウント画面
get '/account/:id' do
  redirect '/' if session[:user_name] == nil
  @account = Account.find(params[:id])
  @contents = Content.where(account_id: params[:id])
  erb :account
end

#投稿しているアカウント画面
get '/detail_account/:id' do
  @account = Account.find(params[:id])
  @contents = Content.where(account_id: params[:id])
  erb :detail
end

#投稿の詳細
get '/detail_content/:id' do
  @content = Content.find(params[:id])
  id = @content.account_id
  @account = Account.find(id)
  erb :detail_content
end

#消去する投稿の確認画面
get '/delete/:id' do
  @content = Content.find(params[:id])
  erb :delete
end

#消去機能
post '/delete/:id' do
  content = Content.find(params[:id])
  account_id = content.account_id
  content.destroy
  redirect "/account/#{account_id}"
end

#登録しているアカウントの消去確認画面
get '/account_delete/:id' do
  @account = Account.find(params[:id])
  erb :account_delete
end

#アカウント消去機能
post '/account_deleted/:id' do
  account = Account.find(params[:id])
  if account.destroy
    session[:user_name] = nil
    redirect '/'
  else
    redirect '/'
  end
end

#編集画面
get '/edit/:id' do
  @content = Content.find(params[:id])
  erb :edit
end

#編集機能
post '/edited/:id' do
  @content = Content.find(params[:id])
  if params[:imgfile]
    @imgname = @content.imgfile
    img = params[:imgfile][:tempfile]
    File.open("./public/img/#{@imgname}",'wb') do |i|
      i.write(img.read)
    end
    @content.update(post_content: params[:content],imgfile: @imgname,title: params[:title])
  else
    @content.update(post_content: params[:content],title: params[:title])
  end

  account_id = @content.account_id
  redirect "/account/#{account_id}"
end