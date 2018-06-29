json.id             word.id.to_s
json.name           word.name
json.proper_noun    word.proper_noun
json.created_at     word.created_at.utc.iso8601
json.updated_at     word.updated_at.utc.iso8601
json.deleted_at     word.deleted_at.utc.iso8601 unless word.deleted_at.nil?
