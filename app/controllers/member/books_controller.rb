class Member::BooksController < Member::Base
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to(member_book_path(@book), :notice => 'Book was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @book = Book.find(params[:id])

    if @book.update_attributes(book_params)
      redirect_to(member_book_path(@book), :notice => 'Book was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    redirect_to(member_books_path)
  end

  private

  def book_params
    params.require(:book).permit(
      :isbn,
      :name,
      :publisher,
      :publificationdate,
      :kind,
      :detailurl,
      :smallimgurl,
      :mediumimgurl,
      :largeimgurl
    )
  end
end
