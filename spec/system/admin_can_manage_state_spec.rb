require 'rails_helper'

RSpec.describe "Admin manages articles", type: :system do
  let!(:admin) { User.create(email_address: "admin@test.com", password: "password", admin: true) }

  before do
    driven_by(:rack_test)

    # Login
    visit '/session/new'
    fill_in "Enter your email address", with: "admin@test.com"
    fill_in "Enter your password", with: "password"
    click_button "Sign in"
  end

  context "when admin create article" do
    it "Should be create an article and save as draft" do
      visit admin_articles_path
      expect(page).to have_selector("[data-testid='create-article']")

      find("[data-testid='create-article']").click
      fill_in "Title", with: "New Article"
      fill_in "Description", with: "Content of New article"
      click_button "Save as Draft"

      expect(page).to have_content("Article was successfully created.")
      expect(page).to have_content("New Article")
    end
  end

  context "when admin editing an article" do
    let!(:article) { Article.create(title: "Old Title", description: "Old content", status: "draft") }

    it "can update an article and submit for review" do
      visit edit_admin_article_path(article)

      fill_in "Title", with: "Updated Same Article"
      click_button "Submit for Review"

      expect(page).to have_content("Article was successfully updated.")
      expect(page).to have_content("Updated Same Article")
    end
  end

  context "when admin approving an article" do
    let!(:article) { Article.create(title: "Article for Approval", description: "Content", status: "waiting_for_review") }

    it "Admin can approve an article" do
      visit admin_article_path(article)
      click_button "Approve"
      expect(page).to have_content("Article approved")
    end
  end

  context "when admin rejecting an article" do
    let!(:article) { Article.create(title: "Article for Rejection", description: "Content", status: "waiting_for_review") }

    it "Admin can reject an article" do
      visit admin_article_path(article)
      click_button "Reject"
      expect(page).to have_content("Article rejected")
    end
  end
end
