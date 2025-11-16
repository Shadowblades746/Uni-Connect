def spec_before
  Notifications.dataset.delete
  Users.dataset.delete
  Admins.dataset.delete
  AdminActivity.dataset.delete
  Requests.dataset.delete

  newSettings = GlobalSettings.new
  newSettings.global_max_mentee_capacity = 10
  newSettings.save
end