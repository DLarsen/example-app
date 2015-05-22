json.users @users do |user|
	json.id user.id
	json.name user.name
	json.items user.items do |item|
		json.name item.name
		json.categories item.categories.map(&:name).join(", ")
	end
end