json.product_id @pbis.first.dao_product_id
json.pbis @pbis do |i|
  json.release_number @releases.find { |r| r.items.include?(i.id) }.number
  json.pbi_type i.pbi_type
  json.description i.description

  json.criteria i.criteria do |c|
    json.content c.content
  end
end
