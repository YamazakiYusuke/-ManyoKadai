require 'rails_helper'
RSpec.describe 'ラベルテスト', type: :system do
  describe 'ラベル機能' do
    describe 'タスクの作成' do
      context 'ラベルをつけたタスクの作成' do
        before do
          FactoryBot.create(:user)
          FactoryBot.create(:label)
          visit new_session_path
          fill_in 'session[email]', with: 'yokoi@gmail.com'
          fill_in 'session[password]', with: 'hogehoge'
          click_on 'commit'
          visit new_task_path
        end
        it '作成したラベル付きタスクが表示される' do
          fill_in 'task[title]', with: 'テストタイトル'
          fill_in 'task[content]', with: 'テストコンテンツ'
          select '未着手', from: 'task[status]'
          check '家庭'
          click_on '登録する'

          expect(page).to have_content 'テストタイトル'
          expect(page).to have_content 'テストコンテンツ'
          expect(page).to have_content '未着手'
          expect(page).to have_content '家庭'
        end
      end
    end
    describe 'タスクの編集' do #<= 途中
      before do
        FactoryBot.create(:user)
        FactoryBot.create(:label)
        FactoryBot.create(:label, label: "仕事")
        
        visit new_session_path
        fill_in 'session[email]', with: 'yokoi@gmail.com'
        fill_in 'session[password]', with: 'hogehoge'
        click_on 'commit'
        visit new_task_path
        fill_in 'task[title]', with: 'テストタイトル'
        fill_in 'task[content]', with: 'テストコンテンツ'
        select '未着手', from: 'task[status]'
        check '家庭'
        click_on '登録する'
      end
      context 'ラベルをつけたタスクの編集' do
        it '編集後仕事が表示' do
          click_on '編集'
          check '仕事'
          click_on '更新する'
          expect(page).to have_content '仕事'
        end
      end
    end
    describe 'ラベル検索' do
      before do
        FactoryBot.create(:user)
        FactoryBot.create(:label)
        FactoryBot.create(:label, label: "仕事")
        
        visit new_session_path
        fill_in 'session[email]', with: 'yokoi@gmail.com'
        fill_in 'session[password]', with: 'hogehoge'
        click_on 'commit'
        visit new_task_path
        fill_in 'task[title]', with: 'テストタイトル'
        fill_in 'task[content]', with: 'テストコンテンツ'
        select '未着手', from: 'task[status]'
        check '家庭'
        click_on '登録する'
        visit tasks_path
      end
      context 'ラベルのみで検索' do
        it 'テストタイトルが表示' do
          select '家庭', from: 'task[label_id]'

          click_on '検索'
          expect(page).to have_content 'テストタイトル'
        end
      end
      context 'ラベルとタイトルで検索' do
        it 'テストタイトルが表示' do
          select '家庭', from: 'task[label_id]'
          fill_in 'task[sarch_title]', with: 'テスト'

          click_on '検索'
          expect(page).to have_content 'テストタイトル'
        end
      end
      context 'ラベルとタイトルとステータスで検索' do
        it 'テストタイトルが表示' do
          select '家庭', from: 'task[label_id]'
          fill_in 'task[sarch_title]', with: 'テスト'
          select '未着手', from: 'task[sarch_status]'

          click_on '検索'
          expect(page).to have_content 'テストタイトル'
        end
      end
    end
  end
end