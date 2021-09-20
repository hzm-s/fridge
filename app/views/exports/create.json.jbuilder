json.product_id @issues.first.dao_product_id
json.issues @issues do |i|
  json.issue_type i.issue_type
  json.description i.description

  json.criteria i.criteria do |c|
    json.content c.content
  end
end
