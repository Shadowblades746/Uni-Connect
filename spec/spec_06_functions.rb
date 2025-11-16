def create_new_admin()
  admin = Admins.new
  admin.email = "admin@example.com"
  admin.first_names = "test"
  admin.last_name = "admin"
  admin.changed_password = 1
  admin.password = Login_Helper.hash_password("test")
  admin.save
end

def create_new_user(id, status, name ,nametwo)
  user = Users.new
  user.id = id
  user.user_status = status
  user.first_names = name
  user.last_name = nametwo
  user.password = Login_Helper.hash_password("password")
  user.email = nametwo + name + "@example.com"
  user.gender = "other"
  user.setup_complete = 1
  user.save
end

def setup_test_one()
  create_new_admin()
  create_new_user(1, "mentee", "one", "test")
  create_new_user(2, "mentor", "two", "test")
  create_new_user(3, "mentee", "three", "test")
end

def setup_test_two()
  create_new_admin()
  create_new_user(1, "mentee", "test","one")
  create_new_user(2, "mentor", "test","two")
  create_new_user(3, "mentee", "test","three")
end

def setup_test_three()
  create_new_admin()
  create_new_user(2, "mentor", "test","two")
end

def setup_test_four()
  create_new_admin()
  create_new_user(2, "mentee", "test","two")
end
