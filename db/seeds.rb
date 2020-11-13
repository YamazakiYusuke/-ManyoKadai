30.times do |n|
  fake_name = Faker::Name.name
  email = Faker::Internet.email
  password = 'hogehoge'
  admin = [false,false,false,false,false,false,false,false,true].sample

  User.create!(
    name: fake_name,
    email: email,
    password: password,
    admin: admin
  )
end

user_id = []
users = User.all
users.each do |user|
  user_id << user.id
end

1000.times do |n|
  id = user_id.sample
  title = ['テスト勉強する','カニ食べる','旅行に行く','買い物に行く'].sample
  style = ['一生懸命','コツコツと','時々','だらだらと'].sample
  content = "#{style}#{title}"
  updated_at = Faker::Time.between(from: DateTime.now - 100, to: DateTime.now)
  limit = Faker::Time.between(from: DateTime.now - 100, to: DateTime.now)
  status = ['未着手','着手中','完了'].sample
  priority = ['低','中','高'].sample

  Task.create!(
    title: title,
    content: content,
    updated_at: updated_at,
    limit: limit,
    status: status,
    priority: priority,
    user_id: id 
  )
end


# ['家庭','仕事','個人'].each do |n|
#   Label.create!
#     label: n
#   end
# end
