# frozen_string_literal: true

require 'test_helper'

class PartitionsShowHtmlErbTest < ActionDispatch::IntegrationTest
  setup do
    @partition = partitions(:partition_1)
    @chapter = @partition.chapter

    @user = users(:users_1)
    sign_in @user
  end

  test 'should show partition' do
    get partition_path(@partition)
    assert_response :success

    assert_select 'a[text()=?]', 'Edit'
    assert_select 'a[href=?]', edit_partition_path(@partition)
    assert_select 'a[text()=?]', 'Back'
    assert_select 'a[href=?]', chapter_path(@chapter)
    assert_select '.footer>div>a', 2
    assert_template 'partitions/show'
  end
end
