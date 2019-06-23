class Category < ApplicationRecord
    #カテゴリーの情報が格納されています。
    #現在、カテゴリーはドロップリストの中身を出力しています。
    belongs_to :event, optional: true
end
