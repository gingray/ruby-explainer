class TestKwargsHandling
  def call(user: nil)
    check_user2?(user_id: user.id, account_id: nil)
  end

  private
  def check_user?(account, user_id:)
    process(account: account, user_id: user_id)
    check_user2?(user_id:, account_id:)
  end

  def check_user2?(user_id:, account_id:)

  end
end