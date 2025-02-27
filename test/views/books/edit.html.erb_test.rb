# frozen_string_literal: true

require 'test_helper'

class BooksEditHtmlErbTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:book_1)

    @user = users(:users_1)
    sign_in @user
  end

  test 'should get edit' do
    get edit_book_url(@book)
    assert_response :success

    assert_select 'a[text()=?]', 'Show'
    assert_select 'a[href=?]', book_path(@book)
    assert_select 'a[text()=?]', 'Back'
    assert_select 'a[href=?]', books_path
    assert_select '.footer>div>a', 2
    assert_template 'books/edit'
  end
end
