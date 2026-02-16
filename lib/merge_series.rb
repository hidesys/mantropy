def ms(s0, s1)
  Serie.transaction do
    a = Serie.find(s0)
    b = Serie.find(s1)

    Rails.logger.debug a
    Rails.logger.debug b
    Rails.logger.debug 'Are you sure to merge them? [Y/n]'
    if gets.chomp != 'Y'
      Rails.logger.debug 'Canceled.'
      exit 1
    end

    a.magazines_series << b.magazines_series
    a.books << b.books
    a.ranks << b.ranks
    a.authors << b.authors

    a.save!
    b.destroy
    Rails.logger.debug 'Merged.'
  end
end
