# create 10 expenses
12.times do |i|
    Expense.create!(
        title: "Buy #{i+1} 2022",
        value: i * 15,
        created_at: Date.parse("05-#{i+1}-2022"),
        user_id: 1
    )
end

3.times do |i|
    Expense.create!(
        title: "Buy #{i+1} 2023",
        value: i * 15,
        created_at: Date.parse("05-#{i+1}-2023"),
        user_id: 1
    )
end