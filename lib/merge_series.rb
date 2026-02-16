module MergeSeries
  class << self
    def call(serie_a, serie_b)
      Serie.transaction do
        a = Serie.find(serie_a)
        b = Serie.find(serie_b)

        Rails.logger.debug a
        Rails.logger.debug b
        Rails.logger.debug 'Are you sure to merge them? [Y/n]'
        if gets.chomp != 'Y'
          Rails.logger.debug 'Canceled.'
          exit 1 # rubocop:disable Rails/Exit
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
  end
end
