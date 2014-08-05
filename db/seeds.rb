# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

s0 = Stock.create!(ticker: '2330', category: 'common')
s1 = Stock.create!(ticker: '2882', category: 'finance', sub_category: 'bank')

(1..4).to_a.each do |q|
  st0 = s0.statements.create!(year: 2014, quarter: q, s_type: 'ifrs')
  st1 = s1.statements.create!(year: 2014, quarter: q, s_type: 'ifrs')
end


root = Item.create!(name: 'root', has_value: false)

bs = root.children.create!(name: '資產負債表', has_value: false)
is = root.children.create!(name: '綜合損益表', has_value: false)
cf = root.children.create!(name: '現金流量表', has_value: false)

is.children.create!(name: '營業收入', has_value: false).children.create(name: '營業收入合計', has_value: true)
is.children.create!(name: '營業成本', has_value: false).children.create(name: '營業成本合計', has_value: true)
is.children.create!(name: '營業毛利（毛損）', has_value: true)
is.children.create!(name: '已實現銷貨（損）益', has_value: true)

tmp = is.children.create(name: '營業費用', has_value: false)
tmp.children.create!(name: '推銷費用', has_value: false).children.create!(name: '推銷費用合計', has_value: true)
tmp.children.create!(name: '管理費用', has_value: false).children.create!(name: '管理費用合計', has_value: true)
tmp.children.create!(name: '研究發展費用', has_value: false).children.create!(name: '研究發展費用合計', has_value: true)
tmp.children.create!(name: '營業費用合計', has_value: true)


i = Item.find 4
st1 = Statement.find 1
st2 = Statement.find 2
i.statements << st1
i.statements << st2
