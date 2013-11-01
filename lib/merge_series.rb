def ms(s0, s1)
  Serie.transaction do
    a = Serie.find(s0)
    b = Serie.find(s1)

    p a
    p b
    puts "Are you sure to merge them? [Y/n]"
    if gets.chomp != "Y"
      puts "Canceled."
      exit 1
    end

    a.magazines_series << b.magazines_series
    a.books << b.books
    a.ranks << b.ranks
    a.authors << b.authors

    a.save!
    b.destroy
    puts "Merged."
  end
end

