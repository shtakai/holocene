# frozen_string_literal: true

require 'test_helper'

class ScenesNewHtmlErbTest < ActionDispatch::IntegrationTest
  setup do
    @scene = scenes(:scene_1)
    @key_point = @scene.key_point

    @user = users(:users_1)
    sign_in @user
  end

  test 'should get new' do
    get new_polymorphic_url([@key_point, :scene])
    assert_response :success

    assert_select 'a[text()=?]', 'Back'
    assert_select 'a[href=?]', polymorphic_path([@scene.situated, @scene.key_point, :list])
    assert_select '.footer>div>a', 1
    assert_template 'scenes/new'
  end
end
