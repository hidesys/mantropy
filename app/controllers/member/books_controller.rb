class Member::BooksController < Member::Base
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.all
  end

  def show; end

  def new
    @book = Book.new
  end

  def edit; end

  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to(member_book_path(@book), notice: 'Book was successfully created.')
    else
      render action: 'new'
    end
  end

  def update
    if @book.update(book_params)
      redirect_to(member_book_path(@book), notice: 'Book was successfully updated.')
    else
      render action: 'edit'
    end
  end

  def destroy
    @book.destroy

    redirect_to(member_books_path)
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.expect(
      book: %i[isbn
               name
               publisher
               publificationdate
               kind
               detailurl
               smallimgurl
               mediumimgurl
               largeimgurl]
    )
  end
end
