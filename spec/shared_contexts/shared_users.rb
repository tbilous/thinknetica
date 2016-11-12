shared_context "users", users: true do
  let(:user) { create(:user) }
  let(:john) { create(:user, name: "Johnny Cash") }
  let(:tom) { create(:user, name: "Tommy Cox") }
end
