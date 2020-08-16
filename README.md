# Portfolio-app DB設計
***
## Usersテーブル
|Column|Type|Options|
|------|----|-------|
|avatar|string||
|nickname|string|null: false|
|email|string|null: false, default: "", unique: true|

### Association
- has_one  :card
- has_many :requests
- has_many :messages
***
## Cardsテーブル
|Column|Type|Options|
|------|----|-------|
|user|references|null: false, foreign_key: true|
|payjp_id|string|null: false|
|card_id|string|null: false|

### Association
- belongs_to :user
***
## Requestsテーブル
|Column|Type|Options|
|------|----|-------|
|title|string|null: false|
|content|text|null: false|
|reward|integer|null: false|
|user|references|null: false, foregin_key: true|
|client_id|bigint|null: false|
|contractor_id|bigint||
|condition|integer|null: false, default: 0, limit: 1|

### Association
- belongs_to :client, class_name: "User"
- belongs_to :contractor, class_name: "User", optional: true
- has_many :posts, dependent: :destroy
- has_many :messages
***
## Postsテーブル
|Column|Type|Options|
|------|----|-------|
|request|references|null: false, foregin_key: true|
|image|string||
|delete_instruction|integer|null: false, default: 0|

### Association
- belongs_to :request
***
## Messagesテーブル
|Column|Type|Options|
|------|----|-------|
|user|references|null: false, foregin_key: true|
|request|references|null: false, foregin_key: true|
|text|string||
|picture|string||

### Association
- belongs_to :user
- belongs_to :request
